#include <iostream>

class Point {
private:
    double x, y;

public:
    Point(double x = 0.0, double y = 0.0) : x(x), y(y) {}

    //1
    Point operator+(const Point& other) const {
        return Point(x + other.x, y + other.y);
    }

    Point operator-(const Point& other) const {
        return Point(x - other.x, y - other.y);
    }

    //2
    bool operator==(const Point& other) const {
        return (x == other.x && y == other.y);
    }

    //3
    friend std::ostream& operator<<(std::ostream& os, const Point& p);
};

std::ostream& operator<<(std::ostream& os, const Point& p) {
    os << "(" << p.x << ", " << p.y << ")";
    return os;
}

int main() {
    Point p1(2.5, 4.0);
    Point p2(1.5, 2.0);

    Point pSum = p1 + p2;
    Point pDiff = p1 - p2;

    std::cout << p1 << std::endl;
    std::cout << p2 << std::endl;
    std::cout << pSum << std::endl;
    std::cout << pDiff << std::endl;

    Point p3(2.5, 4.0);

    std::cout << "p1 == p3: ";
    if (p1 == p3) {
        std::cout << "+" << std::endl;
    }
    else {
        std::cout << "-" << std::endl;
    }

    std::cout << "p1 == p2: ";
    if (p1 == p2) {
        std::cout << "+" << std::endl;
    }
    else {
        std::cout << "-" << std::endl;
    }
}