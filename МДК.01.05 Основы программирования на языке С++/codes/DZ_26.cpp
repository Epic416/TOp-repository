#include <iostream>
#include <fstream>
#include <string>

using namespace std;

// 1
double mydiv(double a, double b) {
    if (b == 0) throw "division by zero";
    return a / b;
}

// 2
void read(const string& name) {
    ifstream f(name);
    if (!f) throw "file not found";
    
    string s;
    while (getline(f, s)) {
        cout << s << endl;
    }
    f.close();
}

// 3
int find_elem(const int* arr, int n, int x) {
    if (!arr) throw "null array";
    if (n <= 0) throw "zero size";
    
    for (int i = 0; i < n; i++) {
        if (arr[i] == x) return i;
    }
    throw "not found";
}

// 4
void foo1() { throw "error in chain"; }
void foo2() { foo1(); }
void foo3() { foo2(); }

int main() {
    // 1
    try {
        cout << mydiv(10, 2) << endl;
        cout << mydiv(5, 0) << endl;
    }
    catch (const char* e) {
        cout << "1. " << e << endl;
    }
    
    // 2
    try {
        read("aboba.txt");
    }
    catch (const char* e) {
        cout << "2. " << e << endl;
    }
    
    // 3
    int arr[] = {1, 2, 3, 4, 5};
    try {
        cout << find_elem(arr, 5, 3) << endl;
        cout << find_elem(nullptr, 5, 1) << endl;
    }
    catch (const char* e) {
        cout << "3. " << e << endl;
    }
    
    // 4
    try {
        foo3();
    }
    catch (const char* e) {
        cout << "4. " << e << endl;
    }
}