import sys
import json
from PyQt6.QtWidgets import (
    QApplication,
    QWidget,
    QLabel,
    QListWidget,
    QLineEdit,
    QVBoxLayout,
    QHBoxLayout,
    QComboBox,
    QPushButton,
    QMessageBox
)

PATH = r'D:\Python\pythonProject5\papka\tracks.json'

class PlaylistService:
    def __init__(self):
        self.tracks = {}
        self.load_tracks()

    def load_tracks(self):
        try:
            with open(PATH, 'r', encoding='UTF-8') as file:
                self.tracks = json.load(file)
        except(FileNotFoundError, json.JSONDecodeError):
            self.tracks = {
                "Lucid Dreams": {
                    "genre": "emo-rap",
                    "author": "Juice WRLD",
                    "year_of_release": 2017
                },
                "Falling Down": {
                    "genre": ["emo-pop", "pop-rock"],
                    "author": ["Lil Peep", "XXXTentacion"],
                    "year_of_release": 2018
                }
            }  

    def save_tracks(self):
        with open(PATH, 'w', encoding='utf-8') as file:
            json.dump(self.tracks, file, ensure_ascii=False, indent=4)
    
    def get_tracks(self, genre_filter=None, search_filter=None):
        results = []
        for name, info in self.tracks.items():
            if genre_filter and info['genre'] != genre_filter:
                continue
            if search_filter and search_filter.lower() not in name.lower():
                continue
            results.append(name)
        return results
    
    def get_track_info(self, name):
        return self.tracks.get(name, {}).get("genre", "Жанр не обнаружен")
    
    def add_track(self, name, genre, author, year_of_release):
        if name in self.tracks:
            return False
        self.tracks[name] = {"genre": genre, "author": author, "year_of_release": year_of_release}
        self.save_tracks()
        return True
    
    # Добавленные методы для удаления и изменения
    def delete_track(self, name):
        if name in self.tracks:
            del self.tracks[name]
            self.save_tracks()
            return True
        return False
    
    def update_track(self, old_name, new_name, genre, author, year_of_release):
        if old_name != new_name and new_name in self.tracks:
            return False
        if old_name in self.tracks:
            if old_name != new_name:
                self.tracks[new_name] = self.tracks.pop(old_name)
            self.tracks[new_name].update({"genre": genre, "author": author, "year_of_release": year_of_release})
            self.save_tracks()
            return True
        return False

class TrackWindow(QWidget):
    def __init__(self):
        super().__init__()
        self.setWindowTitle('Проигрыватель')
        self.resize(400, 300)  # Увеличил размер окна
        self.service = PlaylistService()
        self.current_track = None
        self.setup_ui()

    def setup_ui(self):
        main_layout = QVBoxLayout()
        
        # Поиск
        search_layout = QHBoxLayout()
        self.search_input = QLineEdit()
        self.search_input.setPlaceholderText('Поиск')
        self.search_input.textChanged.connect(self.refresh_list)
        search_layout.addWidget(QLabel("Поиск:"))
        search_layout.addWidget(self.search_input)
        main_layout.addLayout(search_layout)

        # Фильтр по жанру
        filter_layout = QHBoxLayout()
        self.genre_filter = QComboBox()
        self.genre_filter.addItem('Все')
        self.genre_filter.addItems(['hip-hop','pop', 'rock', 'R&B'])        
        self.genre_filter.currentTextChanged.connect(self.refresh_list)
        filter_layout.addWidget(QLabel('Жанр:'))
        filter_layout.addWidget(self.genre_filter)
        main_layout.addLayout(filter_layout)
        
        # Список треков
        self.list_widget = QListWidget()
        self.list_widget.currentTextChanged.connect(self.show_track)
        main_layout.addWidget(self.list_widget)

        # Информация о треке
        self.detail_label = QLabel('Выберите трек')
        self.detail_label.setWordWrap(True)
        main_layout.addWidget(self.detail_label)

        # Кнопки управления
        buttons_layout = QHBoxLayout()
        self.delete_button = QPushButton('Удалить трек')
        self.delete_button.clicked.connect(self.delete_track)
        self.edit_button = QPushButton('Изменить трек')
        self.edit_button.clicked.connect(self.edit_track)
        buttons_layout.addWidget(self.delete_button)
        buttons_layout.addWidget(self.edit_button)
        main_layout.addLayout(buttons_layout)

        # Добавление нового трека
        add_layout = QVBoxLayout()
        self.new_name = QLineEdit()
        self.new_name.setPlaceholderText('Название трека')
        self.new_genre = QComboBox()
        self.new_genre.addItems(['hip-hop', 'pop', 'rock', 'R&B'])
        self.new_author = QLineEdit()
        self.new_author.setPlaceholderText('Автор трека')
        self.new_year_of_release = QLineEdit()
        self.new_year_of_release.setPlaceholderText('Год выпуска трека')
        self.add_button = QPushButton('Добавить трек')
        self.add_button.clicked.connect(self.add_track)
        add_layout.addWidget(QLabel("Добавить новый трек:"))
        add_layout.addWidget(self.new_name)
        add_layout.addWidget(self.new_genre)
        add_layout.addWidget(self.new_author)
        add_layout.addWidget(self.new_year_of_release)
        add_layout.addWidget(self.add_button)
        main_layout.addLayout(add_layout)

        self.setLayout(main_layout)
        self.refresh_list()

    def refresh_list(self):
        genre = self.genre_filter.currentText()
        if genre == 'Все':
            genre = None
        search = self.search_input.text()
        tracks = self.service.get_tracks(genre_filter=genre, search_filter=search)
        self.list_widget.clear()
        self.list_widget.addItems(tracks)
        self.detail_label.setText('Выберите трек')

    def show_track(self, name):
        if name:
            self.current_track = name
            info = self.service.tracks.get(name, {})
            details = f"Название: {name}\nЖанр: {info.get('genre', 'Нет данных')}\nАвтор: {info.get('author', 'Нет данных')}\nГод: {info.get('year_of_release', 'Нет данных')}"
            self.detail_label.setText(details)

    def add_track(self):
        name = self.new_name.text().strip()
        genre = self.new_genre.currentText()
        author = self.new_author.text().strip()
        year_of_release = self.new_year_of_release.text().strip()

        if not name or not genre:
            QMessageBox.warning(self, "Ошибка", "Введите название и жанр трека")
            return

        if self.service.add_track(name, genre, author, year_of_release):
            QMessageBox.information(self, "Выполнено", f"Трек '{name}' был добавлен")
            self.new_name.clear()
            self.new_author.clear()
            self.new_year_of_release.clear()
            self.refresh_list()
        else:
            QMessageBox.warning(self, 'Ошибка', f"Трек '{name}' уже существует")

    # Методы для удаления и изменения
    def delete_track(self):
        if not self.current_track:
            QMessageBox.warning(self, "Ошибка", "Выберите трек для удаления")
            return
            
        reply = QMessageBox.question(self, 'Подтвердите', f'Вы хотите удалить трек "{self.current_track}"?',
                                     QMessageBox.StandardButton.Yes | QMessageBox.StandardButton.No)
        
        if reply == QMessageBox.StandardButton.Yes:
            if self.service.delete_track(self.current_track):
                QMessageBox.information(self, "Выполнено", f"Трек '{self.current_track}' удален")
                self.current_track = None
                self.refresh_list()

    def edit_track(self):
        if not self.current_track:
            QMessageBox.warning(self, "Ошибка", "Выберите трек для изменения")
            return
            
        # Получаем текущие данные
        current_info = self.service.tracks.get(self.current_track, {})
        
        # Создаем диалоговое окно для редактирования
        dialog = QWidget()
        dialog.setWindowTitle(f'Изменение трека: {self.current_track}')
        dialog.setFixedSize(400, 300)
        
        layout = QVBoxLayout()
        
        name_input = QLineEdit(self.current_track)
        genre_input = QComboBox()
        genre_input.addItems(['hip-hop', 'pop', 'rock', 'R&B'])
        genre_input.setCurrentText(str(current_info.get('genre', '')))
        author_input = QLineEdit(str(current_info.get('author', '')))
        year_input = QLineEdit(str(current_info.get('year_of_release', '')))
        
        layout.addWidget(QLabel("Название:"))
        layout.addWidget(name_input)
        layout.addWidget(QLabel("Жанр:"))
        layout.addWidget(genre_input)
        layout.addWidget(QLabel("Автор:"))
        layout.addWidget(author_input)
        layout.addWidget(QLabel("Год:"))
        layout.addWidget(year_input)
        
        def save_changes():
            new_name = name_input.text().strip()
            new_genre = genre_input.currentText()
            new_author = author_input.text().strip()
            new_year = year_input.text().strip()
            
            if not new_name:
                QMessageBox.warning(dialog, "Ошибка", "Название не может быть пустым")
                return
                
            if self.service.update_track(self.current_track, new_name, new_genre, new_author, new_year):
                QMessageBox.information(dialog, "Выполнено", f"Трек обновлен")
                dialog.close()
                self.refresh_list()
            else:
                QMessageBox.warning(dialog, "Ошибка", f"Трек с названием '{new_name}' уже существует")
        
        save_button = QPushButton("Сохранить")
        save_button.clicked.connect(save_changes)
        layout.addWidget(save_button)
        
        dialog.setLayout(layout)
        dialog.show()

if __name__ == "__main__":
    app = QApplication(sys.argv)
    window = TrackWindow()
    window.show()
    sys.exit(app.exec())