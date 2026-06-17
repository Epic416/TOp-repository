#include <iostream>
#include <fstream>
#include <filesystem>
#include <string>

using namespace std;
namespace fs = filesystem;

class Command{
    public:
        virtual void execute() = 0;
        virtual string getName() = 0;
        virtual ~Command() = default;
    };

class ListCommand : public Command{
    public:
        void execute() override{
            for (const auto& entry : fs::directory_iterator("../LogManSon")) {
                cout << entry.path() << endl;
            }
        }

        string getName() override{
            return "LIST";
        }
};

class CreateCommand : public Command{
    public:
        string file_name;
        void execute() override{
            cout << "Enter the name of the file (name.txt): ";
            cin >> file_name;
            ofstream fout(file_name, ios::app);
        }

        string getName() override{
            return "CREATE";
        }
};

class DeleteCommand : public Command{
    public:
        string file_name;
        void execute() override{
            cout << "Enter the name of the file (name.txt): ";
            cin >> file_name;
            if(fs::exists(file_name)){
                fs::remove(file_name);
            }
            else{
                cout << "Error: file " << file_name << " is not exist" << endl;
            }
        }

        string getName() override{
            return "DELETE";
        }
};

class ReadCommand : public Command{
    public:
        string file_name;
        void execute() override{
            cout << "Enter the name of the file (name.txt): ";
            cin >> file_name;
            if(fs::exists(file_name)){
                ifstream fin(file_name, ios::in);
                string line;
                while(getline(fin, line)){
                    cout << line << endl;
                }
            }
            else{
                cout << "Error: file " << file_name << " is not exist" << endl;
            }
        }

        string getName() override{
            return "READ";
        }
};
class WriteCommand : public Command{
    public:
        string file_name;
        string line;
        void execute() override{
            cout << "Enter the name of the file (name.txt): ";
            cin >> file_name;
            if(fs::exists(file_name)){
                ofstream fout(file_name, ios::out);
                cout << "Enter the text to write in the " << file_name << ": ";
                cin >> line;
                fout << line << endl;
            }
            else{
                cout << "Error: file " << file_name << " is not exist" << endl;
            }
        }

        string getName() override{
            return "WRITE";
        }
};

class CopyCommand : public Command{
    public:
        string file_name;
        string file_name_in;

        void execute() override{
            cout << "Enter the name of the file for copy (name.txt): ";
            cin >> file_name;
            if(fs::exists(file_name)){
                ifstream fin(file_name, ios::in);
                cout << "Enter the name of the file to write copy data: ";
                cin >> file_name_in;
                if(fs::exists(file_name_in)){
                        ofstream fout(file_name_in, ios::out);
                        string line;
                        while(getline(fin, line)){
                            fout << line << endl;
                        }
                    }
                    else{
                        cout << "Error: file " << file_name_in << " is not exist" << endl;
                    }
            }
            else{
                cout << "Error: file " << file_name << " is not exist" << endl;
            }
        }

        string getName() override{
            return "COPY";
        }
};

int main(){
    fs::path log_file ="LogManSon/log.txt";
    ListCommand l_command;
    CreateCommand c_command;
    DeleteCommand d_command;
    ReadCommand r_command;
    WriteCommand w_command;
    CopyCommand copy_command;
    
    int choice;
    cout << "1. LIST\n2. CREATE\n3. DELETE\n4. READ\n5. WRITE\n6. COPY\n7. EXIT\nEnter the number of operation: ";
    cin >> choice
    while true{
        try{
            if(choice == 1){
                l_command;
            }
        }
    }
}
