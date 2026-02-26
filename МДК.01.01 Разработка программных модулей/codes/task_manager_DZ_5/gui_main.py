import sys
from PyQt6.QtWidgets import *
from PyQt6.QtCore import Qt
from task_service import TaskService


class MainWindow(QMainWindow):
    def __init__(self):
        super().__init__()
        self.service = TaskService()
        self.setWindowTitle("Менеджер задач")
        self.setMinimumSize(700, 500)

        widget = QWidget()
        self.setCentralWidget(widget)
        layout = QVBoxLayout(widget)

        form = QFormLayout()
        self.title_input = QLineEdit()
        self.desc_input = QTextEdit()
        self.desc_input.setMaximumHeight(60)
        self.status_input = QLineEdit()
        self.status_input.setText("pending")
        self.priority_input = QSpinBox()
        self.priority_input.setRange(1, 5)

        form.addRow("Название:", self.title_input)
        form.addRow("Описание:", self.desc_input)
        form.addRow("Статус:", self.status_input)
        form.addRow("Приоритет:", self.priority_input)
        layout.addLayout(form)

        btn_layout = QHBoxLayout()
        self.add_btn = QPushButton("Добавить")
        self.del_btn = QPushButton("Удалить")
        self.refresh_btn = QPushButton("Обновить")
        self.filter_btn = QPushButton("Фильтр")

        btn_layout.addWidget(self.add_btn)
        btn_layout.addWidget(self.del_btn)
        btn_layout.addWidget(self.refresh_btn)
        btn_layout.addWidget(self.filter_btn)
        layout.addLayout(btn_layout)

        self.table = QTableWidget()
        self.table.setColumnCount(5)
        self.table.setHorizontalHeaderLabels(["ID", "Название", "Описание", "Статус", "Приоритет"])
        self.table.setSelectionBehavior(QTableWidget.SelectionBehavior.SelectRows)
        layout.addWidget(self.table)

        self.statusBar().showMessage("Готов")

        self.add_btn.clicked.connect(self.add_task)
        self.del_btn.clicked.connect(self.delete_task)
        self.refresh_btn.clicked.connect(self.load_tasks)
        self.filter_btn.clicked.connect(self.filter_tasks)

        self.load_tasks()

    def load_tasks(self):
        try:
            tasks = self.service.get_all_tasks()
            self.table.setRowCount(len(tasks))

            for row, task in enumerate(tasks):
                self.table.setItem(row, 0, QTableWidgetItem(str(task['id'])))
                self.table.setItem(row, 1, QTableWidgetItem(task['title']))
                self.table.setItem(row, 2, QTableWidgetItem(task['description']))
                self.table.setItem(row, 3, QTableWidgetItem(task['status']))
                self.table.setItem(row, 4, QTableWidgetItem(str(task['priority'])))

            self.statusBar().showMessage(f"Загружено задач: {len(tasks)}")
        except Exception as e:
            QMessageBox.critical(self, "Ошибка", f"Не удалось загрузить: {e}")

    def add_task(self):
        try:
            self.add_btn.setEnabled(False)
            self.service.add_task(
                self.title_input.text(),
                self.desc_input.toPlainText(),
                self.status_input.text(),
                self.priority_input.value()
            )
            self.load_tasks()
            self.title_input.clear()
            self.desc_input.clear()
            QMessageBox.information(self, "Успех", "Задача добавлена!")
        except ValueError as e:
            QMessageBox.warning(self, "Ошибка", str(e))
        except Exception as e:
            QMessageBox.critical(self, "Ошибка", f"Ошибка БД: {e}")
        finally:
            self.add_btn.setEnabled(True)

    def delete_task(self):
        row = self.table.currentRow()
        if row < 0:
            QMessageBox.warning(self, "Внимание", "Выберите задачу")
            return

        task_id = int(self.table.item(row, 0).text())
        reply = QMessageBox.question(self, "Подтверждение",
                                     f"Удалить задачу ID {task_id}?",
                                     QMessageBox.StandardButton.Yes |
                                     QMessageBox.StandardButton.No)

        if reply == QMessageBox.StandardButton.Yes:
            try:
                self.del_btn.setEnabled(False)
                self.service.delete_task(task_id)
                self.load_tasks()
                self.statusBar().showMessage(f"Задача {task_id} удалена")
            except Exception as e:
                QMessageBox.critical(self, "Ошибка", str(e))
            finally:
                self.del_btn.setEnabled(True)

    def filter_tasks(self):
        status, ok = QInputDialog.getText(self, "Фильтр", "Введите статус:")
        if ok and status:
            try:
                tasks = self.service.filter_by_status(status)
                self.table.setRowCount(len(tasks))
                for row, task in enumerate(tasks):
                    self.table.setItem(row, 0, QTableWidgetItem(str(task['id'])))
                    self.table.setItem(row, 1, QTableWidgetItem(task['title']))
                    self.table.setItem(row, 2, QTableWidgetItem(task['description']))
                    self.table.setItem(row, 3, QTableWidgetItem(task['status']))
                    self.table.setItem(row, 4, QTableWidgetItem(str(task['priority'])))
                self.statusBar().showMessage(f"Найдено по статусу '{status}': {len(tasks)}")
            except Exception as e:
                QMessageBox.critical(self, "Ошибка", str(e))


if __name__ == "__main__":
    app = QApplication(sys.argv)
    window = MainWindow()
    window.show()
    sys.exit(app.exec())