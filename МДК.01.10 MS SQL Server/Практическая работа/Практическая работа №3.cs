// zadanie 1
using System;
using System.Data;
using Microsoft.Data.SqlClient;

namespace AdoNetPractice03
{
    class Program
    {
        static string connectionString = "Server=localhost;Database=coffee_shop;Trusted_Connection=True;TrustServerCertificate=True;";

        static void Main(string[] args)
        {
            // zadanie 2 
            using var connection = new SqlConnection(connectionString);
            try
            {
                connection.Open();
                Console.WriteLine("Подключение установлено.\n");
            }
            catch (Exception ex)
            {
                Console.WriteLine($"Ошибка подключения: {ex.Message}");
                return;
            }

            bool exit = false;
            while (!exit)
            {
                Console.WriteLine("=== УПРАВЛЕНИЕ ТОВАРАМИ ===");
                Console.WriteLine("1. Найти товар по ID");
                Console.WriteLine("2. Найти товар по названию");
                Console.WriteLine("3. Добавить товар");
                Console.WriteLine("4. Изменить цену");
                Console.WriteLine("5. Удалить товар");
                Console.WriteLine("6. Найти товары дороже указанной цены");
                Console.WriteLine("7. Поиск клиентов по имени");
                Console.WriteLine("0. Выход");
                Console.Write("Выберите пункт меню: ");

                string? choice = Console.ReadLine();
                Console.WriteLine(new string('-', 30));

                switch (choice)
                {
                    case "1": SearchProductById(connection); break;
                    case "2": SearchProductByName(connection); break;
                    case "3": AddProduct(connection); break;
                    case "4": UpdatePrice(connection); break;
                    case "5": DeleteProduct(connection); break;
                    case "6": FindExpensiveProducts(connection); break;
                    case "7": SearchCustomers(connection); break;
                    case "0": exit = true; break;
                    default: Console.WriteLine("Неверный ввод.\n"); break;
                }
            }
        }

        // zadanie 2
        static void SearchProductById(SqlConnection connection)
        {
            Console.Write("Введите ID товара: ");
            if (!int.TryParse(Console.ReadLine(), out int productId))
            {
                Console.WriteLine("Неверный ID.\n");
                return;
            }

            string sql = "SELECT id, name, price FROM products WHERE id = @id;";
            using var command = new SqlCommand(sql, connection);
            command.Parameters.AddWithValue("@id", productId);

            using var reader = command.ExecuteReader();
            bool found = false;
            while (reader.Read())
            {
                found = true;
                Console.WriteLine($"{reader["id"]}: {reader["name"]} - {reader["price"]} руб.");
            }
            if (!found) Console.WriteLine("Товар не найден.");
            Console.WriteLine();
        }

        // zadanie 3 
        static void SearchProductByName(SqlConnection connection)
        {
            Console.Write("Введите название товара: ");
            string? name = Console.ReadLine();
            if (string.IsNullOrWhiteSpace(name))
            {
                Console.WriteLine("Название не может быть пустым.\n");
                return;
            }

            string sql = "SELECT id, name, price FROM products WHERE name = @name;";
            using var command = new SqlCommand(sql, connection);
            command.Parameters.AddWithValue("@name", name);

            using var reader = command.ExecuteReader();
            bool found = false;
            while (reader.Read())
            {
                found = true;
                Console.WriteLine($"{reader["id"]}: {reader["name"]} - {reader["price"]} руб.");
            }
            if (!found) Console.WriteLine("Товар не найден.");
            Console.WriteLine();
        }

        // zadanie 4 
        static void AddProduct(SqlConnection connection)
        {
            Console.Write("Название товара: ");
            string? name = Console.ReadLine();
            Console.Write("ID категории: ");
            if (!int.TryParse(Console.ReadLine(), out int categoryId))
            {
                Console.WriteLine("Неверный ID категории.\n");
                return;
            }
            Console.Write("Цена: ");
            if (!decimal.TryParse(Console.ReadLine(), out decimal price))
            {
                Console.WriteLine("Неверная цена.\n");
                return;
            }

            string sql = "INSERT INTO products (name, category_id, price) VALUES (@name, @category_id, @price);";
            using var command = new SqlCommand(sql, connection);

            // dopolnitelnoe zadanie - явное указание типов через Parameters.Add
            command.Parameters.Add("@name", SqlDbType.NVarChar, 150).Value = name;
            command.Parameters.Add("@category_id", SqlDbType.Int).Value = categoryId;
            command.Parameters.Add("@price", SqlDbType.Decimal).Value = price;

            int rowsAffected = command.ExecuteNonQuery();
            Console.WriteLine($"Добавлено строк: {rowsAffected}\n");
        }

        // zadanie 5 
        static void UpdatePrice(SqlConnection connection)
        {
            Console.Write("ID товара: ");
            if (!int.TryParse(Console.ReadLine(), out int productId))
            {
                Console.WriteLine("Неверный ID.\n");
                return;
            }
            Console.Write("Новая цена: ");
            if (!decimal.TryParse(Console.ReadLine(), out decimal price))
            {
                Console.WriteLine("Неверная цена.\n");
                return;
            }

            string sql = "UPDATE products SET price = @price WHERE id = @id;";
            using var command = new SqlCommand(sql, connection);
            command.Parameters.AddWithValue("@price", price);
            command.Parameters.AddWithValue("@id", productId);

            int rowsAffected = command.ExecuteNonQuery();
            Console.WriteLine($"Изменено строк: {rowsAffected}\n");
        }

        // zadanie 6 
        static void DeleteProduct(SqlConnection connection)
        {
            Console.Write("ID товара для удаления: ");
            if (!int.TryParse(Console.ReadLine(), out int productId))
            {
                Console.WriteLine("Неверный ID.\n");
                return;
            }

            string sql = "DELETE FROM products WHERE id = @id;";
            using var command = new SqlCommand(sql, connection);
            command.Parameters.AddWithValue("@id", productId);

            int rowsAffected = command.ExecuteNonQuery();
            Console.WriteLine($"Удалено строк: {rowsAffected}\n");
        }

        // zadanie 7 
        static void FindExpensiveProducts(SqlConnection connection)
        {
            Console.Write("Введите минимальную цену: ");
            if (!decimal.TryParse(Console.ReadLine(), out decimal minPrice))
            {
                Console.WriteLine("Неверная цена.\n");
                return;
            }

            string sql = "SELECT COUNT(*) FROM products WHERE price >= @min_price;";
            using var command = new SqlCommand(sql, connection);
            command.Parameters.AddWithValue("@min_price", minPrice);

            int count = Convert.ToInt32(command.ExecuteScalar());
            Console.WriteLine($"Товаров с ценой от {minPrice}: {count}\n");
        }

        // zadanie 8 
        static void SearchCustomers(SqlConnection connection)
        {
            Console.Write("Введите имя или фамилию: ");
            string? search = Console.ReadLine();
            if (string.IsNullOrWhiteSpace(search))
            {
                Console.WriteLine("Поиск не может быть пустым.\n");
                return;
            }

            string sql = "SELECT id, name, phone FROM customers WHERE name LIKE @search;";
            using var command = new SqlCommand(sql, connection);
            command.Parameters.AddWithValue("@search", $"%{search}%");

            using var reader = command.ExecuteReader();
            bool found = false;
            while (reader.Read())
            {
                found = true;
                Console.WriteLine($"{reader["id"]}. {reader["name"]} - {reader["phone"]}");
            }
            if (!found) Console.WriteLine("Клиенты не найдены.");
            Console.WriteLine();
        }
    }
}