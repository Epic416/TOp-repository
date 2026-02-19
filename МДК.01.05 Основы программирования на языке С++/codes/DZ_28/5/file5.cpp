#include <iostream>

int calculate_sum(int n) {
    int sum = 0;
    for (int i = 1; i < n; ++i) {
        sum += i;
    }
    return sum;
}

int main() {
    int n = 5;
    int result = calculate_sum(n);
    std::cout << "Сумма от 1 до " << n << " = " << result << std::endl;
}