import sys

sys.path.append('D:\\Python\\pythonProject8\\task_manager\\database')
from database.task_repository import TaskRepository


class TaskService:
    def __init__(self):
        self.repo = TaskRepository()

    def get_all_tasks(self):
        df = self.repo.get_all()
        return df.to_dict('records') if not df.empty else []

    def add_task(self, title, description, status, priority):
        if not title or not title.strip():
            raise ValueError("Название задачи не может быть пустым")
        self.repo.add(title, description, status, priority)
        return True

    def delete_task(self, task_id):
        self.repo.delete(task_id)
        return True

    def update_status(self, task_id, status):
        self.repo.update_status(task_id, status)
        return True

    def filter_by_status(self, status):
        df = self.repo.get_by_status(status)
        return df.to_dict('records') if not df.empty else []