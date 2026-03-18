import sys
from pathlib import Path

project_root = Path(__file__).parent
sys.path.insert(0, str(project_root))

DB_CONFIG = {
    'host': 'localhost',
    'port': 5432,
    'database': 'library_db',
    'user': 'postgres',
    'password': ''
}

from models.book import BookModel
from controllers.book_controller import BookController
from views.book_view import BookView


def main():
    model = BookModel(DB_CONFIG)

    try:
        model.connect()
        print("Подключение успешно!")

        books = model.get_all()
        if not books:
            print("\nДобавление тестовых книг...")
            model.seed_sample_data()

        controller = BookController(model)
        view = BookView(controller)

        view.run()

    except Exception as e:
        print(f"\nОшибка: {e}")
        raise
    finally:
        model.close()


if __name__ == '__main__':
    main()


if __name__ == '__main__':
    main()