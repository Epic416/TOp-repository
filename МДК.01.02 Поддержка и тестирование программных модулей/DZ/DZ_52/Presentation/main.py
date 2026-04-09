import sys
import os

sys.path.append(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))
from Application.service import TaskService


def main():
    service = TaskService()

    while True:
        print("\n1. Показать все\n2. Добавить\n3. Обновить статус\n4. Удалить\n5. Фильтр\n0. Выход")
        choice = input("Действие: ")

        if choice == "0":
            break
        elif choice == "1":
            print(service.show_all())
        elif choice == "2":
            service.create(input("Название: "), input("Описание: "), input("Статус: "), int(input("Приоритет: ")))
        elif choice == "3":
            service.change_status(int(input("ID: ")), input("Новый статус: "))
        elif choice == "4":
            service.remove(int(input("ID: ")))
        elif choice == "5":
            print(service.filter_by_status(input("Статус для поиска: ")))
        else:
            print("Неверный ввод")


if __name__ == "__main__":
    main()