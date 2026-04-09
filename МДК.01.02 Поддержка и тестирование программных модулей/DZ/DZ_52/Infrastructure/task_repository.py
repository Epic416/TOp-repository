from Infrastructure.D_connection import get_engine
from sqlalchemy import text
import pandas as pd

class TaskRepository:
    def get_all(self):
        return pd.read_sql("SELECT * FROM app.tasks", get_engine())

    def add(self, title, description, status, priority):
        with get_engine().connect() as conn:
            conn.execute(text(
                "INSERT INTO app.tasks (title, description, status, priority) VALUES (:t, :d, :s, :p)"
            ), {"t": title, "d": description, "s": status, "p": priority})
            conn.commit()
        return self.get_all()

    def update_status(self, task_id, new_status):
        with get_engine().connect() as conn:
            conn.execute(text("UPDATE app.tasks SET status = :s WHERE id = :id"),
                         {"s": new_status, "id": task_id})
            conn.commit()
        return self.get_all()

    def get_by_status(self, status):
        return pd.read_sql("SELECT * FROM app.tasks WHERE status = :s",
                           get_engine(), params={"s": status})

    def delete(self, task_id):
        with get_engine().connect() as conn:
            conn.execute(text("DELETE FROM app.tasks WHERE id = :id"), {"id": task_id})
            conn.commit()
        return self.get_all()