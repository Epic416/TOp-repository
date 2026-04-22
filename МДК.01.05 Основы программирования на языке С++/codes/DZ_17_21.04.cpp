#include <iostream>
#include <string>
using namespace std;

class Teacher {
    string name;
public:
    Teacher(string n) : name(n) {}
    string getName() const { return name; }
};

class Course {
    string title;
    const Teacher& teacher; 
public:
    Course(string t, const Teacher& tchr) : title(t), teacher(tchr) {}

    void printInfo() const {
        cout << "Курс: " << title << "\n";
        cout << "Преподаватель: " << teacher.getName() << "\n";
    }
};

int main() {
    Teacher prof("Андрей");
    Course cpp("C++", prof);

    cpp.printInfo();
}