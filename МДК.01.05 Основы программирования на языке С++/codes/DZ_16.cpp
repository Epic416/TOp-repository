#include <iostream>
#include <string>

using namespace std;

class Processor {
    string model;
public:
    Processor(string m) : model(m) {}
    void start() const { cout << "  CPU: " << model << " запущен.\n"; }
};

class RAM {
    int size;
public:
    RAM(int s) : size(s) {}
    void start() const { cout << "  RAM: " << size << "GB готова.\n"; }
};

class GPU {
    string model;
public:
    GPU(string m) : model(m) {}
    void start() const { cout << "  GPU: " << model << " активирована.\n"; }
};

class Computer {
    Processor cpu;
    RAM ram;
    GPU gpu;
    string name;
public:
    Computer(string n, string p, int r, string g)
        : cpu(p), ram(r), gpu(g), name(n) {
    }

    void start() const {
        cout << "Запуск ПК '" << name << "':\n";
        cpu.start();
        ram.start();
        gpu.start();
        cout << "ПК готов к работе.\n";
    }
};

int main() {
    Computer pc("StudyPC", "Intel i7", 32, "RTX 4060");
    pc.start();
}