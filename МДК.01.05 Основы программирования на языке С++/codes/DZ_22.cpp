#include <iostream>
#include <vector>
#include <numeric>
using namespace std;

int main() {
    setlocale(LC_ALL, "ru");
    vector<int> numbers = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10 };
    //1
    int sum = accumulate(numbers.begin(), numbers.end(), 0);
    cout << sum << endl;
    int product = accumulate(numbers.begin(), numbers.end(), 1, [](int a, int b) {
        return a * b;
    });
    cout << product << endl;

    //2
    vector<int> iota_vec(15);
    iota(iota_vec.begin(), iota_vec.end(), 5);
    for (int n : iota_vec) cout << n << " ";
    cout << endl;

    //3
    vector<int> prefix_sums(iota_vec.size());
    partial_sum(iota_vec.begin(), iota_vec.end(), prefix_sums.begin());
    for (int n : prefix_sums) cout << n << " ";
    cout << endl;

}