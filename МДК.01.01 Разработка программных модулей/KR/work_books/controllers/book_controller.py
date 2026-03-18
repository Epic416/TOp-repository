from typing import List, Dict, Tuple


class BookController:
    CURRENT_YEAR = 2026

    def __init__(self, model):
        self.model = model

    def get_all_books(self) -> List[Dict]:
        return self.model.get_all()

    def get_available_books(self) -> List[Dict]:
        return self.model.get_available()

    def search_book(self, query, search_by):
        if not query or not query.strip():
            return []

        if search_by == 'author':
            return self.model.get_by_author(query)
        elif search_by == 'title':
            return self.model.get_by_title(query)
        else:
            return self.model.get_all()

    def add_book(self, title, author, year, genre: str = "") -> Tuple[bool, str]:
        if not title or not title.strip():
            return False, 'Название не может быть пустым'

        if len(title.strip()) > 200:
            return False, 'Название слишком длинное(Максимум 200 символов)'

        if not author or not author.strip():
            return False, 'Автор не может быть пустым'

        if len(author.strip()) > 100:
            return False, 'Имя слишком длинное(Максимум 100 символов)'

        if not isinstance(year, int):
            return False, 'Год должен быть целым числом'

        if year < 0 or year > self.CURRENT_YEAR:
            return False, 'Год должен быть целым числом'

        if genre and len(genre.strip()) > 50:
            return False, 'Жанр слишком длинный (макимум 50 символов)'

        try:
            book_id = self.model.create(
                title=title.strip(),
                author=author.strip(),
                year=year,
                genre=genre.strip() if genre else "",
                is_available=True
            )
            return True, f'Книга добавлена с ID: {book_id}'
        except Exception as e:
            return False, f'Ошибка при добавлении: {str(e)}'

    def update_book(self, book_id: int, title: str = None, author: str = None, year: int = None, genre: str = None) -> \
    Tuple[bool, str]:
        if not isinstance(book_id, int) or book_id <= 0:
            return False, "Неккоректный ID книги"

        book = self.model.get_by_id(book_id)
        if not book:
            return False, f'Книга с ID {book_id} не найдена'

        if title is not None:
            if not title.strip():
                return False, 'Название не может быть пустым'
            if len(title.strip()) > 200:
                return False, 'Название слишком длинное'

        if author is not None:
            if not author.strip():
                return False, 'Название не может быть пустым'
            if len(author.strip()) > 100:
                return False, 'Название слишком длинное'

        if year is not None:
            if not isinstance(year, int):
                return False, 'Год должен быть целым числом'
            if year < 0 or year > self.CURRENT_YEAR:
                return False, f'Год должен быть от 0 до {self.CURRENT_YEAR}'

        if genre is not None and len(genre.strip()) > 50:
            return False, 'Жанр слишком длинный'

        try:
            self.model.update(
                book_id=book_id,
                title=title,
                author=author,
                year=year,
                genre=genre
            )
            return True, 'Книга обновление'
        except Exception as e:
            return False, f'Ошибка при обновлении: {str(e)}'

    def delete_book(self, book_id) -> Tuple[bool, str]:
        if not isinstance(book_id, int) or book_id <= 0:
            return False, 'Некорректный ID книги'

        book = self.model.get_by_id(book_id)
        if not book:
            return False, f'Книга ID {book_id} не найдена'

        try:
            self.model.delete(book_id)
            return True, "Книга удалена"
        except Exception as e:
            return False, f'Ошибка при удалении: {str(e)}'

    def toggle_book_available(self, book_id: int) -> Tuple[bool, str]:
        if not isinstance(book_id, int) or book_id <= 0:
            return False, "Некорректный ID книги"

        book = self.model.get_by_id(book_id)
        if not book:
            return False, f'Книга с {book_id} не найдена'

        try:
            new_status = self.model.toggle_availability(book_id)
            status_test = 'доступна' if new_status else 'выдана'
            return True, f'Книга {status_test}'
        except Exception as e:
            return False, f'Ошибка: {str(e)}'

    def get_statistics(self) -> Dict[str, int]:
        return self.model.get_statistics()