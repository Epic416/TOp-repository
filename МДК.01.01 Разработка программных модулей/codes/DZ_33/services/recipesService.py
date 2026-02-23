import sys
import os

sys.path.append('D:\Python\pythonProject7\DZ_3')
from ui.db import get_connection
from sqlalchemy import text


class RecipeDataHandler:
    def fetch_all(self):
        db_engine = get_connection()
        with db_engine.connect() as connection:
            query_result = connection.execute(text('SELECT * FROM recipes'))
            records = query_result.fetchall()
        return records

    def insert_new(self, title, category_name, difficulty, instructions):
        db_engine = get_connection()
        with db_engine.connect() as connection:
            try:
                category_check = connection.execute(
                    text('SELECT id FROM categories WHERE name = :category_name'),
                    {'category_name': category_name}
                )
                category_entry = category_check.fetchone()

                if not category_entry:
                    raise ValueError(f"Категория '{category_name}' не найдена")

                category_id = category_entry[0]

                connection.execute(
                    text('''
                        INSERT INTO recipes (name, category_id, level, description) 
                        VALUES (:title, :category_id, :difficulty, :instructions)
                    '''),
                    {'title': title, 'category_id': category_id, 'difficulty': difficulty, 'instructions': instructions}
                )
                connection.commit()
            except Exception as error:
                connection.rollback()
                print(f"Произошла ошибка: {error}")
                raise

    def modify(self, record_id, title, category_name, difficulty, instructions):
        db_engine = get_connection()
        with db_engine.connect() as connection:
            try:
                category_check = connection.execute(
                    text('SELECT id FROM categories WHERE name = :category_name'),
                    {'category_name': category_name}
                )
                category_entry = category_check.fetchone()

                if not category_entry:
                    raise ValueError(f"Категория '{category_name}' не найдена")

                category_id = category_entry[0]

                connection.execute(
                    text('''
                        UPDATE recipes 
                        SET name = :title, category_id = :category_id, level = :difficulty, description = :instructions 
                        WHERE id = :record_id
                    '''),
                    {'title': title, 'category_id': category_id, 'difficulty': difficulty,
                     'instructions': instructions, 'record_id': record_id}
                )
                connection.commit()
            except Exception as error:
                connection.rollback()
                print(f"Произошла ошибка: {error}")
                raise

    def delete(self, record_id):
        db_engine = get_connection()
        with db_engine.connect() as connection:
            try:
                connection.execute(
                    text('DELETE FROM recipes WHERE id = :record_id'),
                    {'record_id': record_id}
                )
                connection.commit()
            except Exception as error:
                connection.rollback()
                print(f"Произошла ошибка: {error}")
                raise

    def filter_by_category(self, category_name):
        db_engine = get_connection()
        with db_engine.connect() as connection:
            query_result = connection.execute(
                text('''
                    SELECT r.* FROM recipes r
                    JOIN categories c ON r.category_id = c.id
                    WHERE c.name = :category_name
                '''),
                {'category_name': category_name}
            )
            records = query_result.fetchall()
            return records