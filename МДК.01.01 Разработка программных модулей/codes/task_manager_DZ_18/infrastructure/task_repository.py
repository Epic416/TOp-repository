from sqlalchemy import text
from infrastructure.D_connection import get_engine
import pandas as pd

class TaskRepository:
    def get_all(self):
        engine = get_engine()
        query = "SELECT * FROM app.tasks"
        return pd.read_sql(query, engine)

    def add(self, title, description, status, priority):
        engine = get_engine()
        with engine.connect() as conn:
            conn.execute(text("""
                INSERT INTO app.tasks (title, description, status, priority) 
                VALUES (:title, :description, :status, :priority)
            """), {
                "title": title,
                "description": description,
                "status": status,
                "priority": priority
            })
            conn.commit()

    def get_by_status(self, status):
        engine = get_engine()
        query = "SELECT * FROM app.tasks WHERE status = :status"
        return pd.read_sql(query, engine, params={"status": status})

    def update_status(self, task_id, new_status):
        engine = get_engine()
        with engine.connect() as conn:
            conn.execute(text("""
                UPDATE app.tasks SET status = :new_status WHERE id = :task_id
            """), {"new_status": new_status, "task_id": task_id})
            conn.commit()

    def delete(self, task_id):
        engine = get_engine()
        with engine.connect() as conn:
            conn.execute(text("""
                DELETE FROM app.tasks WHERE id = :task_id
            """), {"task_id": task_id})
            conn.commit()

    def get_count(self):
        engine = get_engine()
        query = "SELECT COUNT(*) as count FROM app.tasks"
        result = pd.read_sql(query, engine)
        return result['count'].iloc[0]

    def reset_sequence(self):
        engine = get_engine()
        with engine.connect() as conn:
            conn.execute(text("SELECT setval('app.tasks_id_seq', 1, false)"))
            conn.commit()