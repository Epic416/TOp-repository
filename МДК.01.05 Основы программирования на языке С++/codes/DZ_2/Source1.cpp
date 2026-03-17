#include <iostream>
#include <string>
using namespace std;

class Book {
private:
    string title;
    int pages;

public:
    Book() {
        title = "Неизвестно";
        pages = 0;
    }

    Book(string t, int p) {
        title = t;
        pages = p;
    }

    void display() {
        cout << "Название: " << title << ", Страниц: " << pages << endl;
    }
};

int main() {
    Book book1;                    
    Book book2("Война и мир", 2000); 

    book1.display();
    book2.display();
}