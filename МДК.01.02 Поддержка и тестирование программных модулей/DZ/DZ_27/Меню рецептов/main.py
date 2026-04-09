import sys
import os

sys.path.append(os.path.abspath('D:\Python\pythonProject10\Меню рецептов'))

# Подлючаем модули для работы с БД
from service.category_service import CategoryService
from service.recipe_service import RecipeService
# Подключаем виджеты
from ui.control_panel_widget import ControlPanelWidget
from ui.header_widget import HeaderWidget
from ui.recipe_list_widget import RecipeListWidget

from PyQt6.QtWidgets import (
    QApplication, QWidget, QLabel, QListWidget, QLineEdit,
    QVBoxLayout, QHBoxLayout, QComboBox, QPushButton, QMessageBox, QDialog,
    QDialogButtonBox
)

class AddRecipeDialog(QDialog):
        def __init__(self, parent=None):
                super().__init__(parent)
                self.setWindowTitle('Добавление рецепта')
                self.resize(400, 300)
                self.setup_ui()
                self.load_categories()

        def setup_ui(self):
                layout = QVBoxLayout()

                # Название рецепта
                name_layout = QHBoxLayout()
                name_layout.addWidget(QLabel('Название: '))
                self.name_input = QLineEdit()
                name_layout.addWidget(self.name_input)
                layout.addLayout(name_layout)

                # Описание
                desc_layout = QHBoxLayout()
                desc_layout.addWidget(QLabel('Описание: '))
                self.desc_input = QLineEdit()
                desc_layout.addWidget(self.desc_input)
                layout.addLayout(desc_layout)

                # Уровень сложности
                level_layout = QHBoxLayout()
                level_layout.addWidget(QLabel('Сложность: '))
                self.level_combo = QComboBox()
                self.level_combo.addItems(['enum', 'medium', 'hard', 'unreal'])
                level_layout.addWidget(self.level_combo)
                layout.addLayout(level_layout)

                # Категория
                cat_layout = QHBoxLayout()
                cat_layout.addWidget(QLabel('Категория: '))
                self.category_combo = QComboBox()
                cat_layout.addWidget(self.category_combo)
                layout.addLayout(cat_layout)

                # Кнопки
                buttons = QDialogButtonBox(
                        QDialogButtonBox.StandardButton.Ok | QDialogButtonBox.StandardButton.Cancel
                )
                buttons.accepted.connect(self.accept)
                buttons.rejected.connect(self.reject)
                layout.addWidget(buttons)

                self.setLayout(layout)
        
        def load_categories(self):
                categories = CategoryService.get_all()
                for cat in categories:
                        self.category_combo.addItem(cat[1], cat[0])

        def get_recipe_data(self):
                category_id = self.category_combo.currentData()
                return{
                        'name': self.name_input.text().strip(),
                        'description': self.desc_input.text().strip() or None,
                        'level': self.level_combo.currentText(),
                        'category_id': category_id if category_id else None
                }

class MainWindow(QWidget):
        def __init__(self, parent=None):
               super().__init__(parent)
               self.setWindowTitle('Кулинарное меню')
               self.resize(500, 400)
               self.setup_ui()
               self.load_recipes()
        
        def setup_ui(self):
                main_layout = QVBoxLayout()
                self.header = HeaderWidget('Меню виджетов')
                self.recipe_list = RecipeListWidget()
                self.controls = ControlPanelWidget()

                self.recipe_list.recipe_selected.connect(self.on_recipe_selected)
                self.controls.add_clicked.connect(self.on_add_recipe)

                main_layout.addWidget(self.header)
                main_layout.addWidget(self.recipe_list)
                main_layout.addWidget(self.controls)

                self.setLayout(main_layout)
        
        def load_recipes(self):
                self.recipe_list.clear_recipe() # Чистим
                recipes = RecipeService.get_all() # Получаем список рецептов
                
                if not recipes:
                        # Если БД пуста, то добавим тестовые данные
                        self.add_sample_data()
                        recipes = RecipeService.get_all()
                
                for recipe in recipes:
                        category_name = recipe[4] if recipe[4] else 'Без категории'
                        self.recipe_list.add_recipe(recipe[1], category_name)

        # Добавление тестовых данных
        def add_sample_data(self):
                cat_id_1 = CategoryService.add('Супы')
                cat_id_2 = CategoryService.add('Сладости')
                cat_id_3 = CategoryService.add('Мясное')

                # Создание рецептов
                RecipeService.add_recipe('Борщ', cat_id_1, 'medium', 'Украинский борщ')
                RecipeService.add_recipe('Торт \"Наполеон\"', cat_id_2, 'hard', 'Торт с заварным кремом')
                RecipeService.add_recipe('Индейка', cat_id_3, 'enum', 'Запеченная индейка с овощами')

        def on_recipe_selected(self, name):
                QMessageBox.information(self, 'Рецепт Выбран', f'Вы выбрали: {name}')

        def on_add_recipe(self):
                dialog = AddRecipeDialog(self)
                if dialog.exec() == QDialog.DialogCode.Accepted:
                        data = dialog.get_recipe_data()
                        if not data['name']:
                                QMessageBox.warning(self, 'Ошибка', 'Введите название рецепта')
                                return
                        recipe_id = RecipeService.add_recipe(
                                name=data['name'],
                                category_id=data['category_id'],
                                level=data['level'],
                                description=data['description']
                        )

                        if recipe_id > 0:
                                category_name = 'Без категории'
                                if data['category_id']:
                                        cat = CategoryService.get_by_id(data['category_id'])
                                        category_name = cat[1] if cat else 'Без категории'

                                self.recipe_list.add_recipe(data['name'], category_name)
                                QMessageBox.information(self, 'Успех', 'Рецепт добавлен!')
                        else:
                                QMessageBox.critical(self, 'Ошибка', 'Не удалось добавить рецепт')


if __name__ == '__main__':
        app = QApplication(sys.argv)
        window = MainWindow()
        window.show()
        sys.exit(app.exec())
