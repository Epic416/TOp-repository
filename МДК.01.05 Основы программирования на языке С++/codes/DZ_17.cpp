#include <iostream>
#include <string>

using namespace std;

class Employee {
protected:
    string name;
public:
    Employee(string n) : name(n) {}

    void work() {
        cout << name << " выполняет работу сотрудника\n";
    }
};

class Manager : public Employee {
public:
    Manager(string n) : Employee(n) {}

    void work() {
        cout << name << "управляет командой и проектами\n";
    }

    void manage() {
        cout << name << "проводит совещание\n";
    }
};

class Developer : public Employee {
public:
    Developer(string n) : Employee(n) {}

    void work() {
        cout << name << "пишет и тестирует код\n";
    }

    void code() {
        cout << name << "реализует новый функционал\n";
    }
};

int main() {
    Manager m("Алексей");
    Developer d("Мария");

    m.work();
    m.manage();

    d.work();
    d.code();
}