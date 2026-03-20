from database.connection import get_connection

class NoteRepository:
    def get_all_notes(self):
        conn = get_connection()
        cursor = conn.cursor()
        cursor.execute("SELECT id, title, content, category_id, user_id, created_at FROM notes")
        rows = cursor.fetchall()
        cursor.close()
        conn.close()
        return rows

    def create_note(self, title, content, category_id, user_id=1):
        conn = get_connection()
        cursor = conn.cursor()
        cursor.execute(
            "INSERT INTO notes (title, content, category_id, user_id) VALUES (%s, %s, %s, %s)",
            (title, content, category_id, user_id)
        )
        conn.commit()
        cursor.close()
        conn.close()

    def update_note(self, note_id, title, content, category_id):
        conn = get_connection()
        cursor = conn.cursor()
        cursor.execute(
            "UPDATE notes SET title=%s, content=%s, category_id=%s WHERE id=%s",
            (title, content, category_id, note_id)
        )
        conn.commit()
        cursor.close()
        conn.close()

    def delete_note(self, note_id):
        conn = get_connection()
        cursor = conn.cursor()
        cursor.execute("DELETE FROM notes WHERE id=%s", (note_id,))
        conn.commit()
        cursor.close()
        conn.close()