# Список рецептов

from PyQt6.QtWidgets import QWidget, QVBoxLayout
from PyQt6.QtCore import pyqtSignal
from ui.recipe_card_widget import RecipeCardWidget #Импортируем карточку рецепта

class RecipeListWidget(QWidget):
        recipe_selected = pyqtSignal(str)

        def __init__(self):
                super().__init__()
                self.layout = QVBoxLayout()
                self.setLayout(self.layout)
        
        def add_recipe(self, name, category):
                card = RecipeCardWidget(name, category)
                card.selected.connect(self.recipe_selected.emit)
                self.layout.addWidget(card)

        # Очистка рецептов
        def clear_recipe(self):
                while self.layout.count():
                        item = self.layout.takeAt(0) # Берем карточку с индексом 0
                        if item.widget():
                                item.widget().deleteLater()