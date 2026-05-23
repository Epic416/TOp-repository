#include <iostream>
#include <fstream>
#include <cstring>

//1
class FileWrapper {
private:
    std::fstream file;
public:
    FileWrapper(const char* filename, std::ios::openmode mode) {
        file.open(filename, mode);
    }
    ~FileWrapper() {
        if (file.is_open()) {
            file.close();
        }
    }
    std::fstream& get() { return file; }
};

//2
class DynamicArray {
private:
    int* data;
    size_t size;
public:
    DynamicArray(size_t sz) : size(sz) {
        data = new int[size]();
    }
    ~DynamicArray() {
        delete[] data;
    }
    int& operator[](size_t index) { return data[index]; }
    size_t getSize() const { return size; }
};

int main() {
    //1
    {
        FileWrapper fw("test.txt", std::ios::out);
        fw.get() << "LELE" << std::endl;
    }
    //2
    {
        DynamicArray arr(10);
        for (size_t i = 0; i < arr.getSize(); ++i) {
            arr[i] = static_cast<int>(i * 10);
        }
        std::cout << "DynamicArray[3] = " << arr[3] << std::endl;
    }
}