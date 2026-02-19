using System;
using System.Collections.Generic;
using System.Linq;

class Program
{
    static Dictionary<string, int> shopItems = new Dictionary<string, int>()
    {
        {"Health Potion", 50},
        {"Mana Potion", 75},
        {"Sword", 200},
        {"Shield", 150}
    };

    static void Main()
    {
        while (true)
        {
            Console.WriteLine("1. Показать все товары");
            Console.WriteLine("2. Добавить товар");
            Console.WriteLine("3. Удалить товар");
            Console.WriteLine("4. Заменить товар");
            Console.WriteLine("5. Подсчитать стоимость");
            Console.WriteLine("6. Выход");
            Console.Write("Выберите действие: ");

            string choice = Console.ReadLine();

            switch (choice)
            {
                case "1": ShowItems(); break;
                case "2": AddItem(); break;
                case "3": RemoveItem(); break;
                case "4": ReplaceItem(); break;
                case "5": CalculateCost(); break;
                case "6": return;
                default: Console.WriteLine("Неверный выбор!"); break;
            }
        }
    }

    static void ShowItems()
    {
        Console.WriteLine("\nТовары в магазине:");
        foreach (var item in shopItems)
        {
            Console.WriteLine($"{item.Key} - {item.Value} монет");
        }
    }

    static void AddItem()
    {
        Console.Write("Введите название товара: ");
        string name = Console.ReadLine();
        Console.Write("Введите цену: ");

        if (int.TryParse(Console.ReadLine(), out int price))
        {
            shopItems[name] = price;
            Console.WriteLine("Товар добавлен");
        }
    }

    static void RemoveItem()
    {
        Console.Write("Введите название товара для удаления: ");
        string name = Console.ReadLine();

        if (shopItems.Remove(name))
            Console.WriteLine("Товар удален");
        else
            Console.WriteLine("Товар не найден");
    }

    static void ReplaceItem()
    {
        Console.Write("Введите название товара для замены: ");
        string oldName = Console.ReadLine();

        if (shopItems.ContainsKey(oldName))
        {
            Console.Write("Введите новое название: ");
            string newName = Console.ReadLine();
            Console.Write("Введите новую цену: ");

            if (int.TryParse(Console.ReadLine(), out int newPrice))
            {
                shopItems.Remove(oldName);
                shopItems[newName] = newPrice;
                Console.WriteLine("Товар заменен");
            }
        }
        else
        {
            Console.WriteLine("Товар не найден");
        }
    }

    static void CalculateCost()
    {
        Console.Write("Введите название товара: ");
        string name = Console.ReadLine();

        if (shopItems.TryGetValue(name, out int price))
        {
            Console.Write("Введите количество: ");
            if (int.TryParse(Console.ReadLine(), out int quantity) && quantity > 0)
            {
                Console.WriteLine($"Общая стоимость: {price * quantity} монет");
            }
        }
        else
        {
            Console.WriteLine("Товар не найден");
        }
    }
}