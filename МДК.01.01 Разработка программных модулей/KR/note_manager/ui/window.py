from PyQt6.QtWidgets import (QMainWindow, QWidget, QVBoxLayout, QHBoxLayout,
                             QTableWidget, QTableWidgetItem, QLineEdit,
                             QTextEdit, QComboBox, QPushButton, QMessageBox, QHeaderView)
from services.note_service import NoteService


class MainWindow(QMainWindow):
    def __init__(self):
        super().__init__()
        self.service = NoteService()
        self.selected_id = None

        self.init_ui()
        self.load_categories()
        self.refresh_notes()

    def init_ui(self):
        self.setWindowTitle("Note Manager")
        self.setGeometry(100, 100, 800, 600)

        central_widget = QWidget()
        self.setCentralWidget(central_widget)
        layout = QVBoxLayout(central_widget)

        input_layout = QHBoxLayout()

        self.title_input = QLineEdit()
        self.title_input.setPlaceholderText("Заголовок")

        self.category_box = QComboBox()

        input_layout.addWidget(self.title_input)
        input_layout.addWidget(self.category_box)

        self.content_input = QTextEdit()
        self.content_input.setMaximumHeight(100)
        self.content_input.setPlaceholderText("Текст заметки")

        btn_layout = QHBoxLayout()
        self.btn_add = QPushButton("Добавить")
        self.btn_update = QPushButton("Обновить")
        self.btn_delete = QPushButton("Удалить")
        self.btn_refresh = QPushButton("Обновить список")

        self.btn_add.clicked.connect(self.add_note)
        self.btn_update.clicked.connect(self.update_note)
        self.btn_delete.clicked.connect(self.delete_note)
        self.btn_refresh.clicked.connect(self.refresh_notes)

        btn_layout.addWidget(self.btn_add)
        btn_layout.addWidget(self.btn_update)
        btn_layout.addWidget(self.btn_delete)
        btn_layout.addWidget(self.btn_refresh)

        self.table = QTableWidget()
        self.table.setColumnCount(5)
        self.table.setHorizontalHeaderLabels(["ID", "Заголовок", "Категория", "Дата", "User ID"])
        self.table.horizontalHeader().setSectionResizeMode(QHeaderView.ResizeMode.Stretch)
        self.table.cellClicked.connect(self.on_cell_clicked)

        layout.addLayout(input_layout)
        layout.addWidget(self.content_input)
        layout.addLayout(btn_layout)
        layout.addWidget(self.table)

    def load_categories(self):
        categories = self.service.get_categories()
        self.category_box.clear()
        self.category_box.addItem("Выберите категорию", 0)
        for cat in categories:
            self.category_box.addItem(cat[1], cat[0])

    def refresh_notes(self):
        self.table.setRowCount(0)
        notes = self.service.get_notes()
        for row_idx, note in enumerate(notes):
            self.table.insertRow(row_idx)
            self.table.setItem(row_idx, 0, QTableWidgetItem(str(note[0])))
            self.table.setItem(row_idx, 1, QTableWidgetItem(note[1]))

            # Получаем имя категории
            cat_name = ""
            for cat in self.service.get_categories():
                if cat[0] == note[3]:
                    cat_name = cat[1]
                    break
            self.table.setItem(row_idx, 2, QTableWidgetItem(cat_name))

            self.table.setItem(row_idx, 3, QTableWidgetItem(str(note[5])))
            self.table.setItem(row_idx, 4, QTableWidgetItem(str(note[4])))

    def on_cell_clicked(self, row, column):
        self.selected_id = int(self.table.item(row, 0).text())
        title = self.table.item(row, 1).text()
        self.title_input.setText(title)

    def add_note(self):
        title = self.title_input.text()
        content = self.content_input.toPlainText()
        cat_id = self.category_box.currentData()

        if title and cat_id:
            self.service.add_note(title, content, cat_id)
            self.refresh_notes()
            self.title_input.clear()
            self.content_input.clear()
        else:
            QMessageBox.warning(self, "Ошибка", "Заполните заголовок и категорию")

    def update_note(self):
        if self.selected_id:
            title = self.title_input.text()
            content = self.content_input.toPlainText()
            cat_id = self.category_box.currentData()
            if title and cat_id:
                self.service.update_note(self.selected_id, title, content, cat_id)
                self.refresh_notes()
                self.selected_id = None
                self.title_input.clear()
                self.content_input.clear()

    def delete_note(self):
        if self.selected_id:
            reply = QMessageBox.question(self, 'Подтверждение', 'Удалить заметку?',
                                         QMessageBox.StandardButton.Yes | QMessageBox.StandardButton.No)
            if reply == QMessageBox.StandardButton.Yes:
                self.service.delete_note(self.selected_id)
                self.refresh_notes()
                self.selected_id = None
                self.title_input.clear()
                self.content_input.clear()