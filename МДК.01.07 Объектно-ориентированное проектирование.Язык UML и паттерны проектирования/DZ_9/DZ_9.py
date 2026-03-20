from datetime import date

class Room:
    def __init__(self, number, room_type="Standard"):
        self.number = number
        self.room_type = room_type

    def __str__(self):
        return f"Номер {self.number} ({self.room_type})"

class Booking:
    def __init__(self, client, room, booking_date):
        self.client = client
        self.room = room
        self.date = booking_date
        self.is_confirmed = False

    def confirm(self):
        self.is_confirmed = True
        return f"Бронирование подтверждено для {self.client.name} на {self.date}."

    def reject(self):
        self.is_confirmed = False
        return f"Бронирование отклонено. Номер {self.room.number} занят на {self.date}."

class Hotel:
    def __init__(self, name):
        self.name = name
        self.rooms = []
        self.bookings = []

    def add_room(self, room):
        self.rooms.append(room)

    def check_availability(self, booking_date, room_number):
        for booking in self.bookings:
            if booking.room.number == room_number and booking.date == booking_date:
                return False
        return True

    def make_booking(self, client, booking_date, room_number):
        target_room = None
        for room in self.rooms:
            if room.number == room_number:
                target_room = room
                break

        if not target_room:
            return "Ошибка: Такого номера не существует."

        if self.check_availability(booking_date, room_number):
            new_booking = Booking(client, target_room, booking_date)
            new_booking.confirm()
            self.bookings.append(new_booking)
            return new_booking.is_confirmed, f"Успех! {client.name}, ваш номер {room_number} забронирован на {booking_date}."
        else:
            temp_booking = Booking(client, target_room, booking_date)
            return False, temp_booking.reject()

class Client:
    def __init__(self, name):
        self.name = name

    def choose_room(self, hotel, booking_date, room_number):
        print(f"\n--- Клиент {self.name} пытается забронировать номер {room_number} на {booking_date} ---")
        success, message = hotel.make_booking(self, booking_date, room_number)
        print(message)
        return success

if __name__ == "__main__":
    my_hotel = Hotel("Grand Hotel")
    my_hotel.add_room(Room(101, "Lux"))
    my_hotel.add_room(Room(102, "Standard"))
    my_hotel.add_room(Room(103, "Standard"))

    client_ivan = Client("Иван")
    client_petr = Client("Петр")

    today = date.today()

    client_ivan.choose_room(my_hotel, today, 101)

    client_petr.choose_room(my_hotel, today, 101)

    client_petr.choose_room(my_hotel, today, 102)

    tomorrow = date.today().replace(day=today.day + 1)
    client_ivan.choose_room(my_hotel, tomorrow, 101)