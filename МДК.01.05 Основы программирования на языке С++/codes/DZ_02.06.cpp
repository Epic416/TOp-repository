#include <iostream>
#include <fstream>
#include <string>

int main() {
    std::ifstream inFile("data.txt");
    if (!inFile.is_open()) {
        return 1;
    }

    std::ofstream outFile("result.txt");
    if (!outFile.is_open()) {
        return 1;
    }

    std::string line;
    int lineCount = 0;
    int charCount = 0;

    while (std::getline(inFile, line)) {
        lineCount++;
        charCount += line.length();
    }

    outFile << "Lines: " << lineCount << std::endl;
    outFile << "Characters: " << charCount << std::endl;

    inFile.close();
    outFile.close();
}