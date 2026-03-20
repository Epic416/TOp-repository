from repositories.note_repository import NoteRepository
from repositories.category_repository import CategoryRepository

class NoteService:
    def __init__(self):
        self.note_repository = NoteRepository()
        self.category_repository = CategoryRepository()

    def get_notes(self):
        return self.note_repository.get_all_notes()

    def get_categories(self):
        return self.category_repository.get_all_categories()

    def add_note(self, title, content, category_id):
        self.note_repository.create_note(title, content, category_id)

    def update_note(self, note_id, title, content, category_id):
        self.note_repository.update_note(note_id, title, content, category_id)

    def delete_note(self, note_id):
        self.note_repository.delete_note(note_id)