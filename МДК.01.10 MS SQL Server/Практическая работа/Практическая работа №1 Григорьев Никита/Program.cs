using Microsoft.Data.SqlClient;

// zadanie 3
string connectionString = "Server=localhost;Database=CoffeeShop;Trusted_Connection=True;TrustServerCertificate=True;";

// zadanie 4
using var connection = new SqlConnection(connectionString);
connection.Open();

// zadanie 5
using var cmdDb = new SqlCommand("SELECT DB_NAME();", connection);
var dbName = cmdDb.ExecuteScalar();

// zadanie 6
using var cmdServer = new SqlCommand("SELECT @@SERVERNAME;", connection);
var serverName = cmdServer.ExecuteScalar();

// zadanie 7
using var cmdDate = new SqlCommand("SELECT GETDATE();", connection);
var serverDate = cmdDate.ExecuteScalar();

// zadanie 8
using var cmdCount = new SqlCommand("SELECT COUNT(*) FROM Products;", connection);
var productCount = cmdCount.ExecuteScalar();

// zadanie 9
using var cmdMaxPrice = new SqlCommand("SELECT MAX(price) FROM Products;", connection);
var maxPrice = cmdMaxPrice.ExecuteScalar();

// samostoyatelnaya chast
using var cmdMinPrice = new SqlCommand("SELECT MIN(price) FROM Products;", connection);
var minPrice = cmdMinPrice.ExecuteScalar();

Console.WriteLine("=== Информация о базе данных ===");
Console.WriteLine($"База данных: {dbName}");
Console.WriteLine($"SQL Server: {serverName}");
Console.WriteLine($"Количество товаров: {productCount}");
Console.WriteLine($"Минимальная цена: {minPrice}");
Console.WriteLine($"Максимальная цена: {maxPrice}");
Console.WriteLine($"Дата и время сервера: {serverDate}");