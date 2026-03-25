#include <iostream>
#include <string>

using namespace std;

//1
class Car {
private:
    string brand;
    int year;
    int speed;

public:
    void setData(string brand, int year, int speed) {
        this->brand = brand;
        this->year = year;
        if (speed >= 0) this->speed = speed;
    }

    void printInfo() {
        cout << "Автомобиль: " << brand << ", Год: " << year << ", Скорость: " << speed << " км/ч" << endl;
    }
};

//2
class BankAccount {
private:
    string number;
    string owner;
    double balance;

public:
    BankAccount(string num, string own, double bal) {
        number = num;
        owner = own;
        balance = bal;
    }

    void deposit(double amount) {
        if (amount > 0) {
            balance += amount;
            cout << "Пополнено на: " << amount << endl;
        }
    }

    void withdraw(double amount) {
        if (amount > 0 && amount <= balance) {
            balance -= amount;
            cout << "Снято: " << amount << endl;
        }
        else {
            cout << "Ошибка: недостаточно средств или неверная сумма" << endl;
        }
    }

    double getBalance() {
        return balance;
    }
};

//3
class Animal {
protected: 
    string name;

public:
    void setName(string n) {
        name = n;
    }
};

class Dog : public Animal {
public:
    void bark() {
        cout << "Собака " << name << " говорит: Гав!" << endl;
    }
};

int main() {
    //1
    Car myCar;
    myCar.setData("Toyota", 2020, 100);
    myCar.printInfo();

    //2
    BankAccount acc("12345", "Alex", 1000.0);
    acc.deposit(500);
    acc.withdraw(200);
    cout << "Текущий баланс: " << acc.getBalance() << endl;

    //3
    Dog dog;
    dog.setName("Рекс");
    dog.bark();
}