import psycopg2 # Подключение к БД

# Создание подключения
def get_conn():
        return psycopg2.connect(
                host='localhost', 
                port=5432,
                user='postgres',
                password='123',
                database='postgres'
        )