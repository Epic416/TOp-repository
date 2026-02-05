from PyQt6.QtWidgets import QApplication, QWidget, QVBoxLayout, QLabel, QPushButton, QHBoxLayout
from PyQt6.QtCore import pyqtSignal


class TrackWidget(QWidget):
    track_selected = pyqtSignal(str, str, str)

    def __init__(self, title="", artist="", genre=""):
        super().__init__()
        self.title = title
        self.artist = artist
        self.genre = genre
        self.setup_ui()

    def setup_ui(self):
        layout = QVBoxLayout()

        title_label = QLabel(f"Название: {self.title}")
        artist_label = QLabel(f"Исполнитель: {self.artist}")
        genre_label = QLabel(f"Жанр: {self.genre}")

        layout.addWidget(title_label)
        layout.addWidget(artist_label)
        layout.addWidget(genre_label)

        select_button = QPushButton("Выбрать")
        select_button.clicked.connect(self.on_select_clicked)
        layout.addWidget(select_button)

        self.setLayout(layout)

    def on_select_clicked(self):
        self.track_selected.emit(self.title, self.artist, self.genre)

    def update_track(self, title, artist, genre):
        self.title = title
        self.artist = artist
        self.genre = genre


class MainWindow(QWidget):
    def __init__(self):
        super().__init__()
        self.setup_ui()

    def setup_ui(self):
        self.setWindowTitle("Музыкальная библиотека")
        self.resize(400, 300)

        layout = QVBoxLayout()

        track1 = TrackWidget("Monster", "Skillet", "Rock")
        track2 = TrackWidget("Awake and Alive", "Skillet", "Rock")
        track3 = TrackWidget("Numb", "Linkin Park", "Alternative")
        track4 = TrackWidget("In the End", "Linkin Park", "Alternative")

        track1.track_selected.connect(self.on_track_selected)
        track2.track_selected.connect(self.on_track_selected)
        track3.track_selected.connect(self.on_track_selected)
        track4.track_selected.connect(self.on_track_selected)

        layout.addWidget(track1)
        layout.addWidget(track2)
        layout.addWidget(track3)
        layout.addWidget(track4)

        self.selected_label = QLabel("Выберите трек...")
        layout.addWidget(self.selected_label)

        self.setLayout(layout)

    def on_track_selected(self, title, artist, genre):
        self.selected_label.setText(f"Выбран: {title} - {artist} ({genre})")


if __name__ == "__main__":
    app = QApplication([])
    window = MainWindow()
    window.show()
    app.exec()