#include <iostream>
#include <stdexcept>
using namespace std;

//1
class Array {
private:
    int data[5];
public:
    Array() {
        for (int i = 0; i < 5; i++) data[i] = 0;
    }

    int& operator[](int index) {
        return data[index];
    }
};

//2
class ArraySafe {
private:
    int data[5];
public:
    ArraySafe() {
        for (int i = 0; i < 5; i++) data[i] = 0;
    }

    int& operator[](int index) {
        if (index < 0 || index >= 5) {
            throw out_of_range("Index out of bounds");
        }
        return data[index];
    }
};

//3
class Count {
private:
    int value;
public:
    Count(int v = 0) : value(v) {}

    Count& operator++() {
        ++value;
        return *this;
    }

    Count operator++(int) {
        Count temp = *this;
        ++value;
        return temp;
    }

    Count& operator--() {
        --value;
        return *this;
    }

    Count operator--(int) {
        Count temp = *this;
        --value;
        return temp;
    }

    int getValue() const { return value; }
};


int main() {
    ArraySafe arr;
    arr[0] = 10;
    arr[1] = 20;
    cout << arr[0] << endl;
    cout << arr[1] << endl;

    Count c(5);

    cout << (++c).getValue() << endl;      
    cout << c++.getValue() << endl;        
    cout << c.getValue() << endl;          

    cout << (--c).getValue() << endl;      
    cout << c--.getValue() << endl;        
    cout << c.getValue() << endl;          
}