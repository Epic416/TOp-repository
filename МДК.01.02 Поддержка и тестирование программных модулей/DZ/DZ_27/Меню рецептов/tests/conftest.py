'''
Файл с конфигурацией pytest и общими фикстурами

Мы добавим фикстуры для тестирования обоими подходами:
1. Mock-подход
2. Тестовая база банных recipes_test
'''

import pytest
from unittest.mock import MagicMock, patch
import psycopg2

# Фикстура для создания курсора Бд
@pytest.fixture
def mock_cursor():
        cursor = MagicMock()
        cursor.fetchall.return_value = []
        cursor.fetchone.return_value = None
        return cursor

# Mock-объект подключения к БД
@pytest.fixture
def mock_conn(mock_cursor):
        conn = MagicMock()
        conn.cursor.return_value = mock_cursor
        return conn

# Патчинг функций get_conn
@pytest.fixture
def mock_get_conn(mock_conn):
        with patch('db.db.get_conn', return_value=mock_conn):
                yield mock_conn

# Конфигурация подключения к БД
# def db_config():
        