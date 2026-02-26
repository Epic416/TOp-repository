# Карточка рецепта

from PyQt6.QtWidgets import QWidget, QVBoxLayout, QLabel, QPushButton
from PyQt6.QtCore import pyqtSignal

class RecipeCardWidget(QWidget):
        selected = pyqtSignal(str)
        
        def __init__(self, name, category):
                super().__init__()
                self.name = name
                self.category = category
                self.setup_ui()
        
        def setup_ui(self):
                layout = QVBoxLayout()
                name_label = QLabel(self.name)
                name_label.setStyleSheet('font-weight: bold;')
                category_label = QLabel(f'Категория: {self.category}')

                button = QPushButton('Выбрать')
                button.clicked.connect(self.emit_selected)
                
                layout.addWidget(name_label)
                layout.addWidget(category_label)
                layout.addWidget(button)

                self.setLayout(layout)

        def emit_selected(self):
                self.selected.emit(self.name)