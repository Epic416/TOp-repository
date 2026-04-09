import pytest
from unittest.mock import patch, MagicMock
import sys
import os

sys.path.append(os.path.abspath(
    r'D:\Python\pythonProject10\Меню рецептов'))

from service.recipe_service import RecipeService


class TestRecipeGetAll:
    def test_get_all_return_list(self, mock_conn, mock_cursor):
        mock_cursor.fetchall.return_value = [
            (1, "Том Ям", "Суп", "medium", "Основное блюдо"),
            (2, "Пельмени", "Сибирское блюдо", "easy", "Основное блюдо")
        ]
        with patch('db.db.get_conn', return_value=mock_conn):
            result = RecipeService.get_all()

        assert isinstance(result, list)
        assert len(result) == 2
        assert result[0][1] == 'Том Ям'

    def test_get_all_calls_correct_query(self, mock_conn, mock_cursor):
        with patch('db.db.get_conn', return_value=mock_conn):
            RecipeService.get_all()

        mock_cursor.execute.assert_called_once()
        call_args = mock_cursor.execute.call_args[0][0]
        assert 'SELECT' in call_args.upper()
        assert 'recipes.recipes' in call_args
        assert 'JOIN' in call_args.upper()

    def test_get_all_closes_resources(self, mock_conn, mock_cursor):
        mock_cursor.fetchall.return_value = []
        with patch('db.db.get_conn', return_value=mock_conn):
            RecipeService.get_all()

        mock_cursor.close.assert_called_once()
        mock_conn.close.assert_called_once()


class TestRecipeGetById:
    def test_get_by_id_returns_result(self, mock_conn, mock_cursor):
        mock_cursor.fetchall.return_value = [(1, "Паста", "Итальянское", "easy", "Основное")]

        with patch('db.db.get_conn', return_value=mock_conn):
            result = RecipeService.get_by_id(1)

        assert isinstance(result, list)
        assert len(result) == 1
        assert result[0][1] == 'Паста'

    def test_get_by_id_calls_correct_query_and_args(self, mock_conn, mock_cursor):
        with patch('db.db.get_conn', return_value=mock_conn):
            RecipeService.get_by_id(42)

        mock_cursor.execute.assert_called_once()
        call_args = mock_cursor.execute.call_args
        query = call_args[0][0]
        params = call_args[0][1]

        assert 'WHERE id = %s' in query
        assert params == (42,)

    def test_get_by_id_closes_resources(self, mock_conn, mock_cursor):
        with patch('db.db.get_conn', return_value=mock_conn):
            RecipeService.get_by_id(1)

        mock_cursor.close.assert_called_once()
        mock_conn.close.assert_called_once()



class TestRecipeAddRecipe:
    def test_add_recipe_returns_id_on_success(self, mock_conn, mock_cursor):
        mock_cursor.fetchall.return_value = [(101,)]

        with patch('db.db.get_conn', return_value=mock_conn):
            result = RecipeService.add_recipe('Торт', 2, 'hard', 'Шоколадный')

        assert result == (101,)

    def test_add_recipe_calls_correct_query_and_args(self, mock_conn, mock_cursor):
        with patch('db.db.get_conn', return_value=mock_conn):
            RecipeService.add_recipe('Борщ', 1, 'medium', 'Украинский борщ')

        mock_cursor.execute.assert_called_once()
        call_args = mock_cursor.execute.call_args
        query = call_args[0][0]
        params = call_args[0][1]

        assert 'INSERT INTO RECIPES.RECIPES' in query.upper()
        assert 'RETURNING ID' in query.upper()
        assert params == ('Борщ', 'Украинский борщ', 'medium', 1)

    def test_add_recipe_commits_on_success(self, mock_conn, mock_cursor):
        mock_cursor.fetchall.return_value = [(5,)]

        with patch('db.db.get_conn', return_value=mock_conn):
            RecipeService.add_recipe('Салат', 3, 'easy')

        mock_conn.commit.assert_called_once()
        mock_conn.rollback.assert_not_called()

    def test_add_recipe_rollback_on_error(self, mock_conn, mock_cursor):
        mock_cursor.fetchall.side_effect = Exception("DB Error")

        with patch('db.db.get_conn', return_value=mock_conn):
            RecipeService.add_recipe('Ошибка', 1, 'easy')

        mock_conn.rollback.assert_called_once()
        mock_conn.commit.assert_not_called()

    def test_add_recipe_closes_resources(self, mock_conn, mock_cursor):
        mock_cursor.fetchall.return_value = [(1,)]

        with patch('db.db.get_conn', return_value=mock_conn):
            RecipeService.add_recipe('Тест', 1, 'easy')

        mock_cursor.close.assert_called_once()
        mock_conn.close.assert_called_once()