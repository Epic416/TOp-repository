#include <iostream>
#include <string>

class Character {
protected:
    std::string name;
public:
    Character(std::string n) : name(n) {}
    virtual void attack() const {
        std::cout << name << " attacks." << std::endl;
    }
    virtual ~Character() = default;
};

class Warrior : public Character {
public:
    Warrior(std::string n) : Character(n) {}
    void attack() const override {
        std::cout << name << " swings sword." << std::endl;
    }
    void slash() const {
        std::cout << name << " performs slash." << std::endl;
    }
};

class Mage : public Character {
public:
    Mage(std::string n) : Character(n) {}
    void attack() const override {
        std::cout << name << " casts magic." << std::endl;
    }
    void castSpell() const {
        std::cout << name << " casts powerful spell." << std::endl;
    }
};

int main() {
    Warrior w("Chad");
    Mage m("Monke");
    w.attack();
    w.slash();
    m.attack();
    m.castSpell();
}