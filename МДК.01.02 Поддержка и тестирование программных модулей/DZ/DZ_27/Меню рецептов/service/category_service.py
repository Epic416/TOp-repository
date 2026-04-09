# Работа с таблицей "categories"
import db.db as db
import sys
import os

sys.path.append(os.path.abspath('D:\Python\pythonProject10\Меню рецептов'))

class CategoryService:
        @staticmethod
        def get_all():
                try:
                        conn = db.get_conn()
                        cursor = conn.cursor()
                        cursor.execute('''
                        select id, name from recipes.categories order by name; 
                        ''')
                        result = cursor.fetchall() # Преобразуем данные в кортеж
                        cursor.close()
                        conn.close()
                except:
                        print('Ошибка')
                return result

        @staticmethod
        def add(name):
                try:
                        conn = db.get_conn()
                        cursor = conn.cursor()
                        cursor.execute('''
                        insert into recipes.categories (name) values(%s) returning id; 
                        ''', (name, ))
                        result = cursor.fetchall()[0] # Преобразуем данные в кортеж
                        conn.commit()
                        cursor.close()
                        conn.close()
                except:
                        print('Ошибка')
                return result

        @staticmethod
        def get_by_id(category_id):
                try:
                        conn = db.get_conn()
                        cursor = conn.cursor()
                        cursor.execute('''
                        select id, name from recipes.categories where id = %s; 
                        ''', (category_id, ))
                        result = cursor.fetchall() # Преобразуем данные в кортеж
                        cursor.close()
                        conn.close()
                except:
                        print('Ошибка')
                return result
        