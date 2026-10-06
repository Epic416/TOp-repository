CREATE DATABASE CoffeeShop;
GO
USE CoffeeShop;
GO
CREATE TABLE Products (
    Id INT PRIMARY KEY IDENTITY,
    Name NVARCHAR(100),
    Price DECIMAL(10, 2)
);
GO
INSERT INTO Products (Name, Price) VALUES 
('Эспрессо', 150.00),
('Капучино', 200.00),
('Латте', 220.00),
('Чай черный', 120.00),
('Круассан', 180.00);