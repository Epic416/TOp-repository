#include <iostream>
#include <vector>
#include <algorithm>
#include <chrono>
#include <random>

using namespace std;
using namespace std::chrono;

int main() {
    const size_t SIZE = 1'000'000;
    vector<int> data(SIZE);

    random_device rd;
    mt19937 gen(rd());
    uniform_int_distribution<> dist(1, 1'000'000);

    for (auto& val : data) {
        val = dist(gen);
    }

    cout << "Вектор из " << SIZE << " элементов создан.\n" << endl;

    //1
    vector<int> data_reverse = data; 

    auto start_rev = high_resolution_clock::now();
    reverse(data_reverse.begin(), data_reverse.end());
    auto end_rev = high_resolution_clock::now();

    duration<double, milli> time_rev = end_rev - start_rev;
    cout << "[reverse] Время выполнения: " << time_rev.count() << " мс" << endl;

    //2
    vector<int> data_sort = data; 

    auto start_sort = high_resolution_clock::now();
    sort(data_sort.begin(), data_sort.end());
    auto end_sort = high_resolution_clock::now();

    duration<double, milli> time_sort = end_sort - start_sort;
    cout << "[sort] Время выполнения: " << time_sort.count() << " мс" << endl;

    if (time_rev < time_sort) {
        cout << "Операция reverse быстрее." << endl;
    }
    else {
        cout << "Операция sort быстрее." << endl;
    }

    //Причины:
    //reverse имеет сложность O(n) — просто меняет элементы местами
    //sort имеет сложность O(n log n) — требует сравнений и перестановок
    //reverse работает с двумя указателями, sort использует алгоритм интросортировки

}
