class Task:
    def __init__(self, id, title, description, status, priority):
        self.id = id
        self.title = title
        self.description = description
        self.status = status
        self.priority = priority

    def __repr__(self):
        return f"Task(id={self.id}, title='{self.title}', status='{self.status}')"