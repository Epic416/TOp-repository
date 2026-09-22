-- 1
IF DB_ID('RealtyDB') IS NOT NULL
    DROP DATABASE RealtyDB;
GO

CREATE DATABASE RealtyDB;
GO

USE RealtyDB;
GO

-- 2
CREATE SCHEMA realty;
GO

-- 3
CREATE TABLE realty.agents
(
    id INT PRIMARY KEY,
    name NVARCHAR(100) NOT NULL
);

CREATE TABLE realty.clients
(
    id INT PRIMARY KEY,
    name NVARCHAR(100) NOT NULL,
    phone NVARCHAR(30) NOT NULL
);

CREATE TABLE realty.properties
(
    id INT PRIMARY KEY,
    address NVARCHAR(200) NOT NULL,
    property_type NVARCHAR(50) NOT NULL,
    price DECIMAL(12, 2) NOT NULL,
    rooms INT NOT NULL,
    agent_id INT NOT NULL,
    CONSTRAINT FK_properties_agents
        FOREIGN KEY (agent_id) REFERENCES realty.agents(id)
);

CREATE TABLE realty.deals
(
    id INT PRIMARY KEY,
    client_id INT NOT NULL,
    property_id INT NOT NULL,
    agent_id INT NOT NULL,
    deal_date DATE NOT NULL,
    deal_price DECIMAL(12, 2) NOT NULL,
    CONSTRAINT FK_deals_clients
        FOREIGN KEY (client_id) REFERENCES realty.clients(id),
    CONSTRAINT FK_deals_properties
        FOREIGN KEY (property_id) REFERENCES realty.properties(id),
    CONSTRAINT FK_deals_agents
        FOREIGN KEY (agent_id) REFERENCES realty.agents(id)
);
GO

-- 4
INSERT INTO realty.agents (id, name) VALUES
    (1, N'Анна Смирнова'),
    (2, N'Иван Петров'),
    (3, N'Мария Орлова');

INSERT INTO realty.clients (id, name, phone) VALUES
    (1, N'Алексей Иванов', N'+7-900-111-11-11'),
    (2, N'Ольга Соколова', N'+7-900-222-22-22'),
    (3, N'Дмитрий Волков', N'+7-900-333-33-33'),
    (4, N'Елена Морозова', N'+7-900-444-44-44');

INSERT INTO realty.properties (id, address, property_type, price, rooms, agent_id) VALUES
    (1, N'ул. Центральная, 10', N'Квартира', 5200000, 2, 1),
    (2, N'ул. Лесная, 25', N'Квартира', 6800000, 3, 1),
    (3, N'ул. Садовая, 7', N'Дом', 9500000, 4, 2),
    (4, N'ул. Молодёжная, 18', N'Квартира', 4300000, 3, 2),
    (5, N'ул. Речная, 4', N'Дом', 12500000, 5, 3),
    (6, N'ул. Школьная, 31', N'Квартира', 3900000, 1, 3);
GO

-- 5
CREATE PROCEDURE realty.FindProperties
    @max_price DECIMAL(12, 2),
    @rooms INT
AS
BEGIN
    SELECT
        p.address,
        p.property_type,
        p.price,
        p.rooms,
        a.name AS agent_name
    FROM realty.properties p
    JOIN realty.agents a ON a.id = p.agent_id
    WHERE p.price <= @max_price
      AND p.rooms = @rooms;
END;
GO

EXEC realty.FindProperties @max_price = 7000000, @rooms = 3;
GO

-- 6
CREATE PROCEDURE realty.GetClient
    @client_id INT
AS
BEGIN
    IF NOT EXISTS (SELECT 1 FROM realty.clients WHERE id = @client_id)
    BEGIN
        PRINT N'Клиент с указанным ID не найден.';
        RETURN;
    END;

    SELECT id, name, phone
    FROM realty.clients
    WHERE id = @client_id;
END;
GO

EXEC realty.GetClient @client_id = 2;
EXEC realty.GetClient @client_id = 999;
GO

-- 7
CREATE PROCEDURE realty.CreateDeal
    @client_id INT,
    @property_id INT,
    @agent_id INT,
    @deal_price DECIMAL(12, 2),
    @deal_id INT OUTPUT
AS
BEGIN
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM realty.clients WHERE id = @client_id)
            THROW 50001, N'Клиент не найден.', 1;

        IF NOT EXISTS (SELECT 1 FROM realty.properties WHERE id = @property_id)
            THROW 50002, N'Объект недвижимости не найден.', 1;

        IF NOT EXISTS (SELECT 1 FROM realty.agents WHERE id = @agent_id)
            THROW 50003, N'Риелтор не найден.', 1;

        IF @deal_price <= 0
            THROW 50004, N'Цена сделки должна быть положительной.', 1;

        SET @deal_id = (SELECT ISNULL(MAX(id), 0) + 1 FROM realty.deals);

        INSERT INTO realty.deals (id, client_id, property_id, agent_id, deal_date, deal_price)
        VALUES (@deal_id, @client_id, @property_id, @agent_id, CAST(GETDATE() AS DATE), @deal_price);
    END TRY
    BEGIN CATCH
        SELECT
            ERROR_NUMBER() AS error_number,
            ERROR_MESSAGE() AS error_message;
    END CATCH;
END;
GO

-- 8
-- 8.1
DECLARE @new_deal_id INT;
EXEC realty.CreateDeal
    @client_id = 1,
    @property_id = 2,
    @agent_id = 1,
    @deal_price = 6500000,
    @deal_id = @new_deal_id OUTPUT;
SELECT @new_deal_id AS new_deal_id;
GO

-- 8.2
DECLARE @new_deal_id2 INT;
EXEC realty.CreateDeal
    @client_id = 999,
    @property_id = 2,
    @agent_id = 1,
    @deal_price = 6500000,
    @deal_id = @new_deal_id2 OUTPUT;
GO

-- 8.3
DECLARE @new_deal_id3 INT;
EXEC realty.CreateDeal
    @client_id = 1,
    @property_id = 2,
    @agent_id = 1,
    @deal_price = -1000,
    @deal_id = @new_deal_id3 OUTPUT;
GO

-- 9
CREATE PROCEDURE realty.GetAgentStatistics
    @agent_id INT
AS
BEGIN
    SELECT
        a.name AS agent_name,
        COUNT(DISTINCT p.id) AS properties_count,
        COUNT(DISTINCT d.id) AS deals_count,
        ISNULL(SUM(d.deal_price), 0) AS total_deals_price
    FROM realty.agents a
    LEFT JOIN realty.properties p ON p.agent_id = a.id
    LEFT JOIN realty.deals d ON d.agent_id = a.id
    WHERE a.id = @agent_id
    GROUP BY a.name;
END;
GO

EXEC realty.GetAgentStatistics @agent_id = 1;
GO

-- 10
SELECT
    d.id,
    c.name AS client_name,
    p.address,
    a.name AS agent_name,
    d.deal_date,
    d.deal_price
FROM realty.deals d
JOIN realty.clients c ON c.id = d.client_id
JOIN realty.properties p ON p.id = d.property_id
JOIN realty.agents a ON a.id = d.agent_id;