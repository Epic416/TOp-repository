from Infrastructure.task_repository import TaskRepository

class TaskService:
    def __init__(self):
        self.repo = TaskRepository()

    def show_all(self): return self.repo.get_all()
    def create(self, title, desc, status, priority): return self.repo.add(title, desc, status, priority)
    def change_status(self, task_id, status): return self.repo.update_status(task_id, status)
    def filter_by_status(self, status): return self.repo.get_by_status(status)
    def remove(self, task_id): return self.repo.delete(task_id)