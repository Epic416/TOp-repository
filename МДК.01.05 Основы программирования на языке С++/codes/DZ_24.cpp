#include <iostream>
#include <fstream>
#include <string>

using namespace std;

// 1
double z1(const string& f) {
    ifstream in(f);
    double s = 0;
    int c = 0;
    double x;
    while (in >> x) {
        s += x;
        c++;
    }
    in.close();
    return c > 0 ? s / c : 0;
}

// 2
int z2(const string& f) {
    ifstream in(f);
    int l = 0;
    string t;
    while (getline(in, t)) l++;
    in.close();
    return l;
}

// 3
string z3(const string& f) {
    ifstream in(f);
    string r, t;
    while (getline(in, t)) {
        if (t.length() > r.length()) r = t;
    }
    in.close();
    return r;
}

// 4
bool z4(const string& s, const string& d) {
    ifstream src(s);
    ofstream dst(d);
    if (!src || !dst) return false;
    dst << src.rdbuf();
    src.close();
    dst.close();
    return true;
}

// 5
void z5(const string& s, const string& d) {
    ifstream src(s);
    ofstream dst(d);
    string t;
    while (getline(src, t)) {
        for (char& c : t) {
            if (c == ' ') c = '_';
        }
        dst << t << endl;
    }
    src.close();
    dst.close();
}

int main() {
    {
        ofstream f1("shmopka.txt");
        f1 << "12 33 77 88 100";
        f1.close();

        ofstream f2("bubliki.txt");
        f2 << "ABOBA OBAMA asddasa\n";
        f2 << "ssss asddsasad kuku\n";
        f2 << "pupupu lalala bimbim\n";
        f2 << "last line blablabla";
        f2.close();
    }

    cout << z1("shmopka.txt") << endl;
    cout << z2("bubliki.txt") << endl;
    cout << z3("bubliki.txt") << endl;
    if (z4("bubliki.txt", "kopiya.txt")) cout << "vse ok" << endl;
    z5("bubliki.txt", "menyaem.txt");

    remove("shmopka.txt");
    remove("bubliki.txt");
    remove("kopiya.txt");
    remove("menyaem.txt");
}