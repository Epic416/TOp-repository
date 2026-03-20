from sqlalchemy import create_engine
import mysql.connector

def get_engine():
    engine = create_engine('mysql+mysqlconnector://root:@localhost:3306/task_manager_db')
    return engine

def get_connection():
    connection = mysql.connector.connect(
        host='localhost',
        user='root',
        password='',
        database='task_manager_db'
    )
    return connection

if __name__ == "__main__":
    try:
        engine = get_engine()
        connection = get_connection()
        print("Подключение к MySQL успешно установлено")
        connection.close()
    except Exception as e:
        print(f"Ошибка подключения: {e}")