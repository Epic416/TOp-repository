#include <iostream>
#include <string>

class Car {
private:
    std::string model;
    int fuelLevel; 

public:
    Car(std::string m, int fuel) {
        model = m;
        fuelLevel = fuel;
    }

    void drive(int distance) {
        std::cout << model << " проехала " << distance << " км" << std::endl;
        fuelLevel -= distance; 
        if (fuelLevel < 0) fuelLevel = 0;
    }

    void refuel(int amount) {
        fuelLevel += amount;
        std::cout << model << " заправлена на " << amount << "\nтоплива: " << fuelLevel << std::endl;
    }

    int getFuel() {
        return fuelLevel;
    }
};

int main() {
    Car car1("Toyota", 100);
    Car car2("BMW", 80);

    std::cout << "У " << "car1" << " топлива: " << car1.getFuel() << std::endl;
    std::cout << "У " << "car2" << " топлива: " << car2.getFuel() << std::endl;

    car1.drive(30);
    car2.drive(50);

    std::cout << "Остаток топлива car1: " << car1.getFuel() << std::endl;
    std::cout << "Остаток топлива car2: " << car2.getFuel() << std::endl;

    car1.refuel(20);

    std::cout << "Финальный уровень топлива car1: " << car1.getFuel() << std::endl;
    std::cout << "Финальный уровень топлива car2: " << car2.getFuel() << std::endl;
}