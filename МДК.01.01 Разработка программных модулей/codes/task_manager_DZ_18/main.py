from service.task_service import TaskService


def main():
    service = TaskService()

    while True:
        print("\n1. Показать все задачи")
        print("2. Добавить задачу")
        print("3. Обновить статус")
        print("4. Удалить задачу")
        print("5. Фильтр по статусу")
        print("0. Выход")

        try:
            action = int(input("Введите номер действия: "))

            if action == 1:
                print("\nСписок задач:")
                print(service.get_all_tasks())

            elif action == 2:
                title = input("Название задачи: ")
                description = input("Описание: ")
                status = input("Статус: ")
                priority = int(input("Приоритет: "))
                service.create_task(title, description, status, priority)
                print("Задача добавлена!")

            elif action == 3:
                task_id = int(input("ID задачи: "))
                new_status = input("Новый статус: ")
                service.change_status(task_id, new_status)
                print("Статус обновлен!")

            elif action == 4:
                task_id = int(input("ID задачи для удаления: "))
                service.remove_task(task_id)
                print("Задача удалена!")

            elif action == 5:
                status = input("Статус для фильтра: ")
                print(service.filter_by_status(status))

            elif action == 0:
                print("Выход из программы.")
                break
            else:
                print("Неверный номер действия!")

        except Exception as e:
            print(f"Ошибка: {e}")


if __name__ == "__main__":
    main()