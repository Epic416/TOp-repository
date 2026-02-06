import sys
import json
from PyQt6.QtWidgets import QApplication, QDialog, QMessageBox
from PyQt6.uic import loadUi

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
                "Lucid Dreams": {"genre": "emo-rap", "author": "Juice WRLD", "year_of_release": 2017},
                "Falling Down": {"genre": ["emo-pop", "pop-rock"], "author": ["Lil Peep", "XXXTentacion"],
                                 "year_of_release": 2018}
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

    def add_track(self, name, genre, author, year_of_release):
        if name in self.tracks:
            return False
        self.tracks[name] = {"genre": genre, "author": author, "year_of_release": year_of_release}
        self.save_tracks()
        return True

    def delete_track(self, name):
        if name in self.tracks:
            del self.tracks[name]
            self.save_tracks()
            return True
        return False


class MusicPlayer(QDialog):
    def __init__(self):
        super().__init__()
        loadUi("Desgin.ui", self)

        self.service = PlaylistService()
        self.current_track = None

        self.Search.setPlaceholderText("Поиск")
        self.InputName.setPlaceholderText("Введите название")
        self.InputAuthor.setPlaceholderText("Введите автора")
        self.InputYear.setPlaceholderText("Введите год")

        genres = ["hip-hop", "emo-rap", "emo-pop", "pop-rock"]
        for genre in genres:
            self.ChooseGenretToAdd.addItem(genre)
            self.SelectGenre.addItem(genre)

        self.refresh_list()

        self.Search.textChanged.connect(self.refresh_list)
        self.SelectGenre.currentTextChanged.connect(self.refresh_list)
        self.MusicList.itemClicked.connect(self.on_item_clicked)
        self.DeleteButton.clicked.connect(self.delete_track)
        self.pushButton_3.clicked.connect(self.add_track)

    def refresh_list(self):
        search = self.Search.text()
        genre = self.SelectGenre.currentText()

        if genre == "Все":
            genre = None

        tracks = self.service.get_tracks(genre_filter=genre, search_filter=search)
        self.MusicList.clear()
        self.MusicList.addItems(tracks)

    def on_item_clicked(self, item):
        name = item.text()
        self.current_track = name
        info = self.service.tracks.get(name, {})

        self.ChoosedName.setText(name)

        genre = info.get('genre', '')
        if isinstance(genre, list):
            genre = ', '.join(genre)
        self.ChoosedGenre.setText(genre)

        author = info.get('author', '')
        if isinstance(author, list):
            author = ', '.join(author)
        self.ChoosedAuthor.setText(author)

        year = info.get('year_of_release', '')
        self.ChoosedYear.setText(str(year))

    def add_track(self):
        name = self.InputName.text().strip()
        genre = self.ChooseGenretToAdd.currentText()
        author = self.InputAuthor.text().strip()
        year = self.InputYear.text().strip()

        if not name:
            QMessageBox.warning(self, "Ошибка", "Введите название")
            return

        if self.service.add_track(name, genre, author, year):
            QMessageBox.information(self, "Успех", "Трек добавлен")
            self.InputName.clear()
            self.InputAuthor.clear()
            self.InputYear.clear()
            self.refresh_list()
        else:
            QMessageBox.warning(self, "Ошибка", "Трек уже существует")

    def delete_track(self):
        if not self.current_track:
            QMessageBox.warning(self, "Ошибка", "Выберите трек")
            return

        if self.service.delete_track(self.current_track):
            QMessageBox.information(self, "Успех", "Трек удален")
            self.current_track = None
            self.ChoosedName.setText("Название")
            self.ChoosedGenre.setText("Название")
            self.ChoosedAuthor.setText("Название")
            self.ChoosedYear.setText("Название")
            self.refresh_list()


if __name__ == "__main__":
    app = QApplication(sys.argv)
    window = MusicPlayer()
    window.show()
    sys.exit(app.exec())