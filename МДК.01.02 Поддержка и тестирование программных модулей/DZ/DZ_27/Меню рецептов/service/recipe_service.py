# Работа с таблицей "recipes"
import db.db as db
import sys
import os

sys.path.append(os.path.abspath('D:\Python\pythonProject10\Меню рецептов'))

class RecipeService:
    @staticmethod
    def get_all():
        try:
            conn = db.get_conn()
            cursor = conn.cursor()
            cursor.execute('''
                select r.id, r.name, r.description, r.level, c.name 
                from recipes.recipes r 
                join recipes.categories c on r.category_id = c.id;
            ''')
            result = cursor.fetchall()
            cursor.close()
            conn.close()
            return result
        except:
            print('Ошибка')
            raise

    @staticmethod
    def get_by_id(recipe_id):
        result = None
        try:
            conn = db.get_conn()
            cursor = conn.cursor()
            cursor.execute('''
                select r.id, r.name, r.description, r.level, c.name 
                from recipes.recipes r 
                join recipes.categories c on r.category_id = c.id 
                WHERE id = %s; 
            ''', (recipe_id, ))
            result = cursor.fetchall()
            cursor.close()
            conn.close()
        except:
            print('Ошибка в запросе')
        return result

    @staticmethod
    def add_recipe(name, category_id, level, description=None):
        result = None
        try:
            conn = db.get_conn()
            cursor = conn.cursor()
            cursor.execute('''
                INSERT INTO recipes.recipes (name, description, level, category_id) 
                VALUES(%s, %s, %s, %s) RETURNING id 
            ''', (name, description, level, category_id))
            result = cursor.fetchall()[0]
            print(type(result))
            conn.commit()
            cursor.close()
            conn.close()
        except:
            conn.rollback()
            print('Ошибка в запросе')
        return result