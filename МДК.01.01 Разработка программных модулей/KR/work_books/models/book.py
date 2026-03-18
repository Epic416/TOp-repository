import psycopg2
from psycopg2.extras import RealDictCursor
from typing import List, Optional, Dict
from contextlib import contextmanager


class BookModel:
    DEFAULT_CONFIG = {
        'host': 'localhost',
        'port': 5432,
        'database': 'library_db',
        'user': 'postgres',
        'password': 'password'
    }

    def __init__(self, config: Optional[Dict[str, any]] = None):
        self.config = {**self.DEFAULT_CONFIG, **(config or {})}
        self.connection = None

    def connect(self):
        try:
            self.connection = psycopg2.connect(
                host=self.config['host'],
                port=self.config['port'],
                database=self.config['database'],
                user=self.config['user'],
                password=self.config['password']
            )
            return self.connection
        except psycopg2.Error as e:
            print('Ошибка подключение к БД', e)
            raise

    def close(self):
        if self.connection:
            self.connection.close()
            self.connection = None

    @contextmanager
    def cursor(self, dict_cursor=True):
        if not self.connection:
            self.connect()

        cursor_type = RealDictCursor if dict_cursor else psycopg2.cursor
        cursor = self.connection.cursor(cursor_factory=cursor_type)
        try:
            yield cursor
        finally:
            cursor.close()

    def get_all(self) -> List[Dict]:
        with self.cursor() as cur:
            cur.execute('''
                select id, title, author, year, genre, is_available from books order by title;
            ''')
            return cur.fetchall()

    def get_by_id(self, book_id: int) -> Optional[Dict]:
        with self.cursor() as cur:
            cur.execute('''
            select id, title, author, year, genre, is_available from books where id = %s
            ''', (book_id,))
            return cur.fetchone()

    def get_by_author(self, author: str) -> List[Dict]:
        with self.cursor() as cur:
            cur.execute(
                '''
                select id, title, author, year, genre, is_available
                from books
                where author like %s
                order by title
                ''', (f'%{author}%',)
            )
            return cur.fetchall()

    def get_by_title(self, title: str) -> List[Dict]:
        with self.cursor() as cur:
            cur.execute(
                '''
                select id, title, author, year, genre, is_available
                from books
                where title like %s
                order by title
                ''', (f"%{title}%",)
            )
            return cur.fetchall()

    def get_available(self) -> List[Dict]:
        with self.cursor() as cur:
            cur.execute(
                '''
                    select id, title, author, year, genre, is_available
                    from books
                    where is_available = TRUE
                    order by title
                '''
            )
            return cur.fetchall()

    def create(self, title: str, author: str, year: int, genre: str = "", is_available: bool = True) -> int:
        with self.cursor() as cur:
            cur.execute(
                '''
                    insert into books(title, author, year, genre, is_available)
                    values(%s, %s, %s, %s, %s)
                    returning id
                ''', (title, author, year, genre, is_available)
            )
            self.connection.commit()
            return cur.fetchone()['id']

    def update(self, book_id: int, title: str = None, author: str = None, year: int = None, genre: str = None,
               is_available: bool = None) -> bool:
        book = self.get_by_id(book_id)
        if not book:
            return False

        title = title if title is not None else book['title']
        author = author if author is not None else book['author']
        year = year if year is not None else book['year']
        genre = genre if genre is not None else (book['genre'] or '')
        is_available = is_available if is_available is not None else book['is_available']

        with self.cursor() as cur:
            cur.execute(
                '''
                    update books
                    set title = %s, author = %s, year = %s, genre = %s, is_available = %s
                    where id = %s
                ''', (title, author, year, genre, is_available, book_id)
            )
            self.connection.commit()
            return cur.rowcount > 0

    def delete(self, book_id: int) -> bool:
        with self.cursor() as cur:
            cur.execute('delete from books where id = %s', (book_id,))
            self.connection.commit()
            return cur.rowcount > 0

    def toggle_availability(self, book_id: int) -> Optional[bool]:
        book = self.get_by_id(book_id)
        if not book:
            return None

        new_status = not book['is_available']
        with self.cursor() as cur:
            cur.execute('''
                            update books
                            set is_available = %s, updated_at = current_timestamp
                            where id = %s
                        ''', (new_status, book_id))
            self.connection.commit()
            return new_status

    def get_statistics(self) -> Dict[str, int]:
        with self.cursor() as cur:
            cur.execute(
                '''
                select
                    count(*) as total,
                    sum(case when is_available then 1 else 0 end) as available
                from books
                ''')
            result = cur.fetchone()
            return {
                'total': result['total'],
                'unavailable': result['total'] - result['available']
            }

    def seed_sample_data(self):
        books = self.get_all()
        if books:
            return

        sample_books = [
            ("Война и мир", "Лев Толстой", 1869, "Роман", True),
            ("Преступление и наказание", "Федор Достоевский", 1866, "Роман", True),
            ("Мастер и Маргарита", "Михаил Булгаков", 1967, "Роман", False)
        ]

        for title, author, year, genre, available in sample_books:
            self.create(title, author, year, genre, available)

        print('Данные загружены')