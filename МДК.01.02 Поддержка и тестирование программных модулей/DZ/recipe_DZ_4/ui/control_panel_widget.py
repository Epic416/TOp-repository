# Панель управления
from PyQt6.QtWidgets import QWidget, QHBoxLayout, QPushButton
from PyQt6.QtCore import pyqtSignal

class ControlPanelWidget(QWidget):
        add_clicked = pyqtSignal()
        def __init__(self):
                super().__init__()
                layout = QHBoxLayout()

                add_button = QPushButton('Добавить рецепт')
                add_button.clicked.connect(self.add_clicked.emit)

                layout.addWidget(add_button)
                self.setLayout(layout)   