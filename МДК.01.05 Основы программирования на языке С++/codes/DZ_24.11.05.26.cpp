#include <iostream>
#include <vector>

class Notification {
public:
    virtual ~Notification() = default; 
    virtual void send() = 0;           
};

class EmailNotification : public Notification {
public:
    void send() override {
        std::cout << "Уведомление отправлено на электронную почту.\n";
    }
};

class SMSNotification : public Notification {
public:
    void send() override {
        std::cout << "Уведомление отправлено в виде SMS.\n";
    }
};

class PushNotification : public Notification {
public:
    void send() override {
        std::cout << "Уведомление отправлено как Push-сообщение.\n";
    }
};

int main() {
    std::vector<Notification*> notifications;
    notifications.push_back(new EmailNotification());
    notifications.push_back(new SMSNotification());
    notifications.push_back(new PushNotification());

    for (Notification* notif : notifications) {
        notif->send(); 
        delete notif;  
    }
}