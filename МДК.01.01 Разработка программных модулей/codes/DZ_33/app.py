import sys
sys.path.append('D:\Python\pythonProject7\DZ_3')
from services.recipesService import RecipeDataHandler

data_manager = RecipeDataHandler()

def update_recipe_list():
    global current_recipes
    current_recipes = data_manager.fetch_all()
    print(current_recipes, "\n")


try:
    while True:
        print("===МЕНЮ ДЛЯ РАБОТЫ С БАЗОЙ ДАННЫХ RECIPE_MANAGER===")
        print("1 - Показать все рецепты\n"
        "2 - Добавить рецепт\n"
        "3 - Изменить рецепт\n"
        "4 - Удалить рецепт\n"
        "5 - Получить рецепты по категории\n"
        "0 - Выход")
        user_choice = int(input("Введите номер действия: "))

        try:
            if user_choice == 1:
                print("\nСписок рецептов:")
                update_recipe_list()

            if user_choice == 2:
                recipe_title = input("\nВведите название рецепта: ")
                category_name = input("Введите название категории рецепта: ")
                difficulty_level = input("Введите уровень сложности рецепта: ")
                recipe_description = input("Введите описание рецепта: ")

                data_manager.insert_new(recipe_title, category_name, difficulty_level, recipe_description)
                update_recipe_list()

            if user_choice == 3:
                category_name = input("\nВведите название категории рецепта для изменения: ")
                record_id = int(input("Введите id рецепта из категории: "))
                new_title = input("Введите новое название рецепта: ")
                new_difficulty = input("Введите новый уровень сложности рецепта: ")
                new_description = input("Введите новое описание рецепта: ")

                data_manager.modify(record_id, new_title, category_name, new_difficulty, new_description)
                update_recipe_list()

            if user_choice == 4:
                record_id = int(input("\nВведите id рецепта для удаления: "))
                data_manager.delete(record_id)
                update_recipe_list()

            if user_choice == 5:
                category_name = input("\nВведите название категории для получения рецептов: ")
                print(data_manager.filter_by_category(category_name))
                update_recipe_list()

            if user_choice == 0:
                break

        except Exception as error:
            print("Неизвестная ошибка внутри выбора задач\n")

except Exception as error:
    print("Неизвестная ошибка внутри меню\n")