from infrastructure.task_repository import TaskRepository

class TaskService:
    def __init__(self):
        self.repository = TaskRepository()

    def get_all_tasks(self):
        return self.repository.get_all()

    def create_task(self, title, description, status, priority):
        self.repository.add(title, description, status, priority)
        return self.get_all_tasks()

    def change_status(self, task_id, new_status):
        self.repository.update_status(task_id, new_status)
        return self.get_all_tasks()

    def remove_task(self, task_id):
        self.repository.delete(task_id)
        if self.repository.get_count() == 0:
            self.repository.reset_sequence()
        return self.get_all_tasks()

    def filter_by_status(self, status):
        return self.repository.get_by_status(status)