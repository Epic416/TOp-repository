from database.connection import get_connection

class CategoryRepository:
    def get_all_categories(self):
        conn = get_connection()
        cursor = conn.cursor()
        cursor.execute("SELECT id, name FROM categories")
        rows = cursor.fetchall()
        cursor.close()
        conn.close()
        return rows