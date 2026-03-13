import pytest
import mysql.connector
from db.db import get_conn
from services.category_service import CategoryService
from services.recipe_service import RecipeService


@pytest.fixture
def db_conn():
    conn = get_conn()
    conn.start_transaction()
    yield conn
    conn.rollback()
    conn.close()


class TestCategoryService:
    def test_get_by_id_success(self, db_conn):
        cursor = db_conn.cursor()
        cursor.execute("INSERT INTO categories (name) VALUES ('Тестовая категория')")
        category_id = cursor.lastrowid

        service = CategoryService(db_conn)
        result = service.get_by_id(category_id)

        assert len(result) == 1
        assert result[0][1] == 'Тестовая категория'

    def test_create_category_success(self, db_conn):
        service = CategoryService(db_conn)
        result = service.add('Новая тестовая категория')

        cursor = db_conn.cursor()
        cursor.execute("SELECT name FROM categories WHERE id = %s", (result[0],))
        name = cursor.fetchone()[0]
        assert name == 'Новая тестовая категория'

    def test_negative_enum_value(self, db_conn):
        service = RecipeService(db_conn)

        cursor = db_conn.cursor()
        cursor.execute("INSERT INTO categories (name) VALUES ('Категория для теста')")
        category_id = cursor.lastrowid

        with pytest.raises(mysql.connector.Error):
            service.add_recipe('Тестовый рецепт', category_id, 'НЕСУЩЕСТВУЮЩИЙ_УРОВЕНЬ')

    def test_negative_foreign_key(self, db_conn):
        service = RecipeService(db_conn)

        with pytest.raises(mysql.connector.Error):
            service.add_recipe('Тестовый рецепт', 99999, 'легкий')

    def test_record_not_found(self, db_conn):
        service = CategoryService(db_conn)
        result = service.get_by_id(99999)
        assert len(result) == 0