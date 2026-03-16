#include <iostream>
#include <string>
using namespace std;

//1
class Student {
private:
    string name;
    int age;
    double grade;
public:
    Student(string n, int a, double g) : name(n), age(a), grade(g) {}
    ~Student() { 
        cout << "Student destroyed" << endl; 
    }

    void setData(string n, int a, double g) { 
        name = n; age = a; grade = g; 
    }
    void printInfo() { 
        cout << name << ", " << age << " years, grade: " << grade << endl; 
    }
};

//2
class Car {
public:
    string brand;
    Car(string b, int y, int s) : brand(b), year(y), speed(s) {}

    void setYear(int y) { 
        year = y; 
    }
    int getYear() { 
        return year; 
    }
    void setSpeed(int s) { 
        speed = s; 
    }
    int getSpeed() { 
        return speed; 
    }

    void printInfo() { cout << brand << ", " << year << " year, speed: " << speed << " km/h" << endl; }
private:
    int year;
protected:
    int speed;
};

//3
class Product {
private:
    string name;
    double price;
    int quantity;
public:
    Product(string n, double p, int q) : name(n), price(p), quantity(q) {}
    ~Product() { cout << "Product destroyed" << endl; }

    Product* setData(string n, double p, int q) {
        name = n; price = p; quantity = q;
        return this;
    }
    void printInfo() { 
        cout << name << ", price: $" << price << ", stock: " << quantity << endl; 
    }
    void buy(int amount) { 
        if (quantity >= amount) quantity -= amount; 
    }
};

int main() {
    //1
    Student s1("Alex", 20, 4.5);
    s1.printInfo();
    Student s2 = s1;
    s2.printInfo();

    //2
    Car c1("Toyota", 2020, 180);
    c1.printInfo();
    c1.setYear(2021);
    c1.setSpeed(200);
    c1.printInfo();

    //3
    Product p1("Laptop", 1500.0, 10);
    p1.printInfo();
    p1.buy(3);
    p1.printInfo();
    p1.setData("Phone", 800.0, 5)->printInfo();
}