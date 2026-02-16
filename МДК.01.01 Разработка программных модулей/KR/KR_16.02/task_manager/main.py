import sys
sys.path.append('D:\\Python\\pythonProject8\\task_manager\\database')
from database.task_repository import TaskRepository

repo = TaskRepository()
tasks_df = repo.get_all()


def refresh_tasks():
    global tasks_df
    tasks_df = repo.get_all()
    print(tasks_df, "\n")


try:
    while True:
        print("1. Показать все задачи\n" 
              "2. Добавить задачу\n" 
              "3. Обновить статус\n" 
              "4. Удалить задачу\n" 
              "5. Фильтр по статусу\n" 
              "0. Выход")
        action = int(input("Введите номер действия: "))

        try:
            if action == 1:
                print("Список задач:")
                refresh_tasks()

            if action == 2:
                title = input("Введите название задачи: ")
                description = input("Введите описание задачи: ")
                status = input("Введите статус задачи: ")
                priority = int(input("Введите приоритет задачи: "))

                repo.add(title, description, status, priority)
                refresh_tasks()

            if action == 3:
                id = int(input("Введите id задачи для обновления статуса: "))
                status = input("Введите новый статус: ")

                repo.update_status(id, status)
                refresh_tasks()

            if action == 4:
                id = int(input("Введите id задачи для удаления: "))

                repo.delete(id)
                refresh_tasks()

            if action == 5:
                status = input("Введите статус для фильтрации: ")
                repo.get_by_status(status)
                refresh_tasks()

            if action == 0:
                break

        except Exception as e:
            print("ошибка")

except Exception as e:
    print("ошибка")

