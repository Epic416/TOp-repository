# Шапка приложения
from PyQt6.QtWidgets import QWidget, QVBoxLayout, QLabel

class HeaderWidget(QWidget):
        def __init__(self, title:str):
                super().__init__()
                layout = QVBoxLayout()
                label = QLabel(title)
                label.setStyleSheet('font-size: 18px; font-weight: bold;')
                layout.addWidget(label)
                self.setLayout(layout)