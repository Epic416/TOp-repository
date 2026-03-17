#include <iostream>
using namespace std;

class DynamicBuffer {
private:
    int* arr;
    int size;

public:
    DynamicBuffer(int s) {
        size = s;
        arr = new int[size];
        cout << "Память выделена для " << size << " элементов." << endl;
    }

    void fillArray() {
        for (int i = 0; i < size; i++) {
            arr[i] = i * 10; 
        }
    }

    void printArray() {
        for (int i = 0; i < size; i++) {
            cout << arr[i] << " ";
        }
        cout << endl;
    }

    ~DynamicBuffer() {
        delete[] arr;
        cout << "Память освобождена." << endl;
    }
};

int main() {
    DynamicBuffer db(5);
    db.fillArray();
    db.printArray();
}