#include <iostream>
#include <vector>
#include <fstream>
#include <string>
#include <sstream>
#include <limits>


using namespace std;

struct Operation {
    int id;
    string type;
    string category;
    double amount;
    string date;
    string description;
};

vector<Operation> operations;
int nextId = 1;


void load() {
    ifstream file("finance.txt");
    if (!file) return;

    operations.clear();
    string line;
    while (getline(file, line)) {
        stringstream ss(line);
        Operation op;
        string amount;

        getline(ss, line, '|'); op.id = stoi(line);
        getline(ss, op.type, '|');
        getline(ss, op.category, '|');
        getline(ss, amount, '|'); op.amount = stod(amount);
        getline(ss, op.date, '|');
        getline(ss, op.description, '|');

        operations.push_back(op);
        if (op.id >= nextId) nextId = op.id + 1;
    }
    file.close();
}

void save() {
    ofstream file("finance.txt");
    for (const auto& op : operations) {file << op.id << "|" << op.type << "|" << op.category << "|" << op.amount << "|" << op.date << "|" << op.description << "\n";
    }
    file.close();
    cout << "Данные сохранены\n";
}

void add() {
    Operation op;
    op.id = nextId++;

    cout << "Тип доход/расход: "; cin >> op.type;
    cout << "Категория: "; cin >> op.category;
    cout << "Сумма: "; cin >> op.amount;
    cout << "Дата ГГГГ-ММ-ДД: "; cin >> op.date;
    cout << "Описание: "; cin >> op.description;

    operations.push_back(op);
    save();
    cout << "Запись добавлена\n";
}

void show() {
    if (operations.empty()) {
        cout << "Нет операций\n";
        return;
    }

    string filter;
    cout << "Фильтр все/доход/расход/период: ";
    cin >> filter;

    string startDate, endDate;
    if (filter == "период") {
        cout << "Начальная дата: "; cin >> startDate;
        cout << "Конечная дата: "; cin >> endDate;
    }

    cout << "\n--- Операции ---\n";
    for (const auto& op : operations) {
        if (filter == "доход" && op.type != "доход") continue;
        if (filter == "расход" && op.type != "расход") continue;
        if (filter == "период" && (op.date < startDate || op.date > endDate)) continue;

        cout << "ID: " << op.id << " | " << op.date << " | " << op.type
            << " | " << op.category << " | " << op.amount << " | " << op.description << "\n";
    }
}

void Delete() {
    int id;
    cout << "ID записи для удаления: "; cin >> id;

    for (auto it = operations.begin(); it != operations.end(); ++it) {
        if (it->id == id) {
            operations.erase(it);
            save();
            cout << "Запись удалена\n";
            return;
        }
    }
    cout << "Запись не найдена\n";
}

void showStats() {
    double totalIncome = 0, totalExpense = 0;

    for (const auto& op : operations) {
        if (op.type == "доход") totalIncome += op.amount;
        else if (op.type == "расход") totalExpense += op.amount;
    }

    cout << "\n--- Статистика ---\n";
    cout << "Доходы: " << totalIncome << "\n";
    cout << "Расходы: " << totalExpense << "\n";
    cout << "Баланс: " << totalIncome - totalExpense << "\n";

    cout << "\nПо категориям:\n";
    for (const auto& op1 : operations) {
        bool printed = false;
        for (const auto& op2 : operations) {
            if (&op1 == &op2) continue;
            if (op1.category == op2.category) {
                printed = true;
                break;
            }
        }
        if (!printed) {
            double sum = 0;
            for (const auto& op : operations) {
                if (op.category == op1.category) sum += op.amount;
            }
            cout << op1.category << ": " << sum << "\n";
        }
    }
}

int main() {
    setlocale(LC_ALL, "ru");
    load();

    int choice;
    do {
        cout << "Учет финансов:\n";
        cout << "1. Добавить операцию\n";
        cout << "2. Просмотреть операции\n";
        cout << "3. Удалить операцию\n";
        cout << "4. Статистика\n";
        cout << "0. Выход\n";
        cout << "Выбор: ";

        if (!(cin >> choice)) {
            cin.clear();
            cin.ignore(numeric_limits<streamsize>::max(), '\n');
            cout << "Ошибка ввода\n";
            continue;
        }

        switch (choice) {
        case 1: add(); break;
        case 2: show(); break;
        case 3: Delete(); break;
        case 4: showStats(); break;
        case 0: break;
        default: cout << "Неверный выбор\n";
        }
    } while (choice != 0);

    return 0;
}