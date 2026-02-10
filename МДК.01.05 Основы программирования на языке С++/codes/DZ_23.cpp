#include <iostream>
#include <string>
#include <vector>
#include <cctype>

using namespace std;

// 1
size_t count_words(const string& text) {
    size_t count = 0;
    bool in_word = false;
    for (char c : text) {
        if (isspace(c)) {
            in_word = false;
        }
        else if (!in_word) {
            in_word = true;
            ++count;
        }
    }
    return count;
}

// 2
vector<string> split(const string& text) {
    vector<string> words;
    size_t start = 0;
    while (start < text.size()) {
        while (start < text.size() && isspace(text[start])) ++start;
        size_t end = start;
        while (end < text.size() && !isspace(text[end])) ++end;
        if (start < end) {
            words.push_back(text.substr(start, end - start));
        }
        start = end;
    }
    return words;
}

// 3
bool is_palindrome(const string& s) {
    if (s.empty()) return true;
    for (size_t i = 0; i < s.size() / 2; i++) {
        if (tolower(s[i]) != tolower(s[s.size() - 1 - i])) return false;
    }
    return true;
}

// 4
int sum_values(const string& str) {
    int sum = 0;
    size_t pos = 0;
    while (pos < str.size()) {
        size_t eq_pos = str.find('=', pos);
        if (eq_pos == string::npos) break;
        size_t semicolon_pos = str.find(';', eq_pos);
        if (semicolon_pos == string::npos) semicolon_pos = str.size();
        string num_str = str.substr(eq_pos + 1, semicolon_pos - eq_pos - 1);
        sum += stoi(num_str);
        pos = semicolon_pos + 1;
    }
    return sum;
}

// 5
string longest_word(const string& text) {
    auto words = split(text);
    string longest;
    for (const auto& w : words) {
        if (w.size() > longest.size()) longest = w;
    }
    return longest;
}

int main() {
    setlocale(LC_ALL, "ru");
    string text = "ABOBA OBAMA";

    cout << count_words(text) << endl;

    auto words = split(text);
    for (const auto& w : words) cout << "[" << w << "] ";
    cout << endl;

    cout << (is_palindrome("ABOBA") ? "да" : "нет") << endl;
    cout << (is_palindrome("hello") ? "да" : "нет") << endl;

    string vals = "x=10;y=20;z=30";
    cout << sum_values(vals) << endl;

    cout << longest_word(text) << endl;
}