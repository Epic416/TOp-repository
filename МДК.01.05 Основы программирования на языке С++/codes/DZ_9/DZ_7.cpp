#include <iostream>
#include <string>

using namespace std;

class Student {
private:
    string name;
    static int count;

public:
    Student(string n) : name(n) {
        count++;
        cout << "Студент " << name << " создан." << endl;
    }

    static int getCount() {
        return count;
    }

    void showInfo() {
        cout << "Имя: " << name << endl;
    }
};

int Student::count = 0;

int main() {
    cout << Student::getCount() << endl;

    Student s1("Иван");
    Student s2("Мария");
    Student s3("Петр");

    cout << Student::getCount() << endl;
}