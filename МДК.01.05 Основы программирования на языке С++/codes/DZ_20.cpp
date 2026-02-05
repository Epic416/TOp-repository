#include <iostream>
#include <vector>
#include <algorithm>
#include <string>
using namespace std;

int main() {
    setlocale(LC_ALL, "ru");
    vector<int> nums = { 5, -2, 10, -8, 3, -1, 7, -4, 0 };

    //1 
    int negative_count = 0;
    for (int n : nums) {
        if (n < 0) {
            negative_count++;
        }
    }
    cout << negative_count << endl;

    //2 
    vector<int> odd_numbers;
    for (int n : nums) {
        if (n % 2 != 0) {
            odd_numbers.push_back(n);
        }
    }
    nums = odd_numbers;

    cout << "Без четных чисел: ";
    for (int n : nums) {
        cout << n << " ";
    }
    cout << endl;

    //3
    vector<int> positive_nums = { 1, 5, 8, 3, 7 };
    bool all_positive = true;
    for (int n : positive_nums) {
        if (n <= 0) {
            all_positive = false;
            break;
        }
    }
    cout << "Все положительные: ";
    if (all_positive) {
        cout << "да" << endl;
    }
    else {
        cout << "нет" << endl;
    }

    //4
    vector<int> numbers = { 10, 5, 8, 12, 3, 15 };
    auto min_it = min_element(numbers.begin(), numbers.end());
    if (min_it != numbers.end()) {
        *min_it = 0;
    }
    cout << "После: ";
    for (int n : numbers) {
        cout << n << " ";
    }
    cout << endl;

    //5
    string text = "programming";
    sort(text.begin(), text.end(), greater<char>());
    cout << text << endl;
}