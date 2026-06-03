#include <iostream>
#include <fstream>
#include <string>
#include <vector>

bool isInfo(const std::string& line) {
    return line.find("INFO:") != std::string::npos;
}

bool isWarning(const std::string& line) {
    return line.find("WARNING:") != std::string::npos;
}

bool isError(const std::string& line) {
    return line.find("ERROR:") != std::string::npos;
}

int main() {
    std::ifstream file("log.txt");

    if (!file.is_open()) {
        std::cerr << "Ошибка: не удалось открыть файл log.txt" << std::endl;
        return 1;
    }

    int infoCount = 0;
    int warningCount = 0;
    int errorCount = 0;
    std::vector<std::string> errorMessages;

    std::string line;

    while (std::getline(file, line)) {
        if (isInfo(line)) {
            infoCount++;
        }
        else if (isWarning(line)) {
            warningCount++;
        }
        else if (isError(line)) {
            errorCount++;
            errorMessages.push_back(line); 
        }
    }

    file.close();

    std::cout << "Статистика:" << std::endl;
    std::cout << "INFO: " << infoCount << std::endl;
    std::cout << "WARNING: " << warningCount << std::endl;
    std::cout << "ERROR: " << errorCount << std::endl;

    std::cout << "Ошибки:" << std::endl;
    for (const auto& errorMsg : errorMessages) {
        std::cout << errorMsg << std::endl;
    }

}