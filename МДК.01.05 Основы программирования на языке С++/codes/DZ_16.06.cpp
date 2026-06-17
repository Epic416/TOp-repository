#include <iostream>
#include <thread>
#include <chrono>

using namespace std;

void printNumbers() {
    for (int i = 1; i <= 5; ++i) {
        cout << i << " ";
        this_thread::sleep_for(chrono::milliseconds(100));
    }
    cout << endl;
}

void printLetters() {
    for (char c = 'A'; c <= 'E'; ++c) {
        cout << c << " ";
        this_thread::sleep_for(chrono::milliseconds(100));
    }
    cout << endl;
}

int main() {
    setlocale(LC_ALL, "ru");

    cout << "Главный поток: запуск задач" << endl;

    thread t1(printNumbers); 
    thread t2(printLetters); 

    t1.join();
    t2.join();

    cout << "Главный поток: обе задачи завершены, программа заканчивает работу" << endl;
}