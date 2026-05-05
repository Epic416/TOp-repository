#include <iostream>
#include <string>


class Device {
protected:
    std::string name;
    bool isOn;

public:
    Device(const std::string& n) : name(n), isOn(false) {}

    virtual void turnOn() {
        isOn = true;
        std::cout << name << " включен" << std::endl;
    }

    virtual void turnOff() {
        isOn = false;
        std::cout << name << " выключен" << std::endl;
    }

    bool getStatus() const {
        return isOn;
    }
};

class Light : public Device {
public:
    Light(const std::string& n) : Device(n) {}

    void turnOn() override {
        Device::turnOn();
        std::cout << "Свет горит" << std::endl;
    }

    void turnOff() override {
        Device::turnOff();
    }

    void setBrightness(int level) {
        std::cout << "Яркость: " << level << "%" << std::endl;
    }
};

class Thermostat : private Device {
public:
    Thermostat(const std::string& n) : Device(n) {}

    void turnOn() override {
        Device::turnOn();
        std::cout << "Термостат активен" << std::endl;
    }

    void turnOff() override {
        Device::turnOff();
    }

    void setTemperature(int temp) {
        std::cout << "Температура: " << temp << "C" << std::endl;
    }

    bool isWorking() const {
        return getStatus();
    }
};

int main() {
    Light lamp("Лампа");
    lamp.turnOn();
    lamp.setBrightness(75);
    lamp.turnOff();
    std::cout << "Статус: " << (lamp.getStatus() ? "вкл" : "выкл") << std::endl;

    std::cout << "-----------" << std::endl;

    Thermostat thermo("Термостат");
    thermo.turnOn();
    thermo.setTemperature(22);
    thermo.turnOff();
    std::cout << "Статус: " << (thermo.isWorking() ? "вкл" : "выкл") << std::endl;
}