#include <iostream>
#include <vector>
#include <algorithm>
using namespace std;

int main() {
    setlocale(LC_ALL, "ru");

    vector<int> nums = { 5, 15, 8, 25, 3, 12, -5, 18, -2 };
    for (int n : nums) cout << n << " ";
    cout << endl;
    //1
    int count_greater_than_10 = count_if(nums.begin(), nums.end(), [](int n) {
        return n > 10;
    });
    cout << count_greater_than_10 << endl;

    //2
    auto first_negative = find_if(nums.begin(), nums.end(), [](int n) {
        return n < 0;
    });
    if (first_negative != nums.end()) {
        cout << "Первое отрицательное: " << *first_negative << endl;
    }
    else {
        cout << "Отрицательных нет" << endl;
    }

    //3
    sort(nums.begin(), nums.end(), [](int a, int b) {
        return a > b;
    });
    for (int n : nums) cout << n << " ";
    cout << endl;
}