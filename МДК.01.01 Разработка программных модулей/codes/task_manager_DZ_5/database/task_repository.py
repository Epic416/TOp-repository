import sys
sys.path.append('D:\\Python\\pythonProject8\\task_manager\\database')
from D_connection import get_engine
import pandas as pd
from sqlalchemy import text

class TaskRepository:
    def get_all(self):
        engine = get_engine()
        query = "SELECT * FROM app.tasks"
        df = pd.read_sql(query, engine)
        return df

    def add(self, title, description, status, priority):
        engine = get_engine()
        with engine.connect() as conn:
            conn.execute(text("""INSERT INTO app.tasks (title, description, status, priority) VALUES (:title, :description, :status, :priority)"""), {"title": title, "description": description, "status": status, "priority": priority})
            conn.commit()
        print(f"Задача добавлена")
        return self.get_all()

    def get_by_status(self, status):
        engine = get_engine()
        query = "SELECT * FROM app.tasks WHERE status = :status"
        df = pd.read_sql(query, engine, params={"status": status})
        print(f"Задачи по статусу - {status}:")
        return df

    def update_status(self, task_id, new_status):
        engine = get_engine()
        with engine.connect() as conn:
            conn.execute(text("UPDATE app.tasks SET status = :new_status WHERE id = :task_id"), {"new_status": new_status, "task_id": task_id})
            conn.commit()
        print(f"Статус задача c id - {task_id} обновлена на: {new_status}")
        return self.get_all()

    def reset_sequence(self):
        engine = get_engine()
        with engine.connect() as conn:
            conn.execute(
                text("SELECT setval('app.tasks_id_seq', 1, false)")
            )
            conn.commit()
        print("Счётчик задач сброшен")

    def delete(self, task_id):
        engine = get_engine()
        with engine.connect() as conn:
            conn.execute(text("DELETE FROM app.tasks WHERE id = :task_id"),
                         {"task_id": task_id})
            conn.commit()
            print(f"Задача c id = {task_id} удалена")

        tasks_count = len(self.get_all())
        if tasks_count == 0:
            self.reset_sequence()

        return self.get_all()