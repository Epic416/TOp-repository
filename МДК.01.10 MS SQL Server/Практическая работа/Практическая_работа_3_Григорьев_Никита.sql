USE CollegeDB;
GO

IF OBJECT_ID('game.locations', 'U') IS NOT NULL
  DROP TABLE game.locations;
GO

IF EXISTS (SELECT * FROM sys.schemas WHERE name = 'game')
  DROP SCHEMA game;
GO

CREATE SCHEMA game;
GO

CREATE TABLE game.locations (
  id INT PRIMARY KEY,
  name NVARCHAR(100) NOT NULL,
  parent_id INT NULL,
  location_type NVARCHAR(50) NOT NULL,
  difficulty INT NOT NULL,
  reward INT NOT NULL
);

INSERT INTO game.locations (id, name, parent_id, location_type, difficulty, reward)
VALUES
  (1,  N'Королевство',    NULL, N'Мир',        1,  0),
  (2,  N'Северные земли',  1,   N'Регион',     2,  0),
  (3,  N'Южные земли',     1,   N'Регион',     2,  0),
  (4,  N'Лес',             2,   N'Локация',    3,  100),
  (5,  N'Горная крепость', 2,   N'Локация',    5,  300),
  (6,  N'Древние руины',   4,   N'Подземелье', 6,  500),
  (7,  N'Логово волков',   4,   N'Подземелье', 4,  250),
  (8,  N'Пещера дракона',  5,   N'Подземелье', 10, 1000),
  (9,  N'Пустыня',         3,   N'Локация',    3,  100),
  (10, N'Город',           3,   N'Локация',    2,  50),
  (11, N'Храм песков',     9,   N'Подземелье', 7,  600),
  (12, N'Таверна',         10,  N'Здание',     1,  20),
  (13, N'Рынок',           10,  N'Здание',     1,  30);

-- Block 1
WITH DangerousLocations AS (
  SELECT id, name, difficulty, reward
  FROM game.locations
  WHERE difficulty >= 5
)
SELECT * FROM DangerousLocations;

-- Block 2
WITH LocationStatistics AS (
  SELECT parent_id,
  COUNT(*) AS child_count,
  AVG(difficulty) AS avg_difficulty,
  MAX(reward) AS max_reward
  FROM game.locations
  WHERE parent_id IS NOT NULL
  GROUP BY parent_id
)
SELECT l.name AS location_name, s.child_count, s.avg_difficulty, s.max_reward
FROM LocationStatistics s
JOIN game.locations l ON l.id = s.parent_id;

-- Block 3
WITH DangerousRegions AS (
  SELECT p.name AS region_name, p.difficulty AS region_difficulty,
  MAX(c.difficulty) AS max_child_difficulty
  FROM game.locations p
  JOIN game.locations c ON c.parent_id = p.id
  WHERE p.location_type = N'Регион'
  GROUP BY p.name, p.difficulty
  HAVING MAX(c.difficulty) >= 7
)
SELECT * FROM DangerousRegions;

-- Block 4
WITH LocationTree AS (
  SELECT id, name, parent_id
  FROM game.locations
  WHERE name = N'Северные земли'
  UNION ALL  
  SELECT c.id, c.name, c.parent_id
  FROM game.locations c
  JOIN LocationTree p ON c.parent_id = p.id
)
SELECT * FROM LocationTree;

-- Block 5
WITH LocationTree AS (
  SELECT id, name, parent_id, 0 AS level
  FROM game.locations
  WHERE name = N'Северные земли'
  UNION ALL
  SELECT c.id, c.name, c.parent_id, p.level + 1
  FROM game.locations c
  JOIN LocationTree p ON c.parent_id = p.id
)
SELECT name AS location_name, level FROM LocationTree;

-- Block 6
WITH LocationTree AS (
  SELECT id, name, parent_id, location_type, difficulty, reward, 0 AS level
  FROM game.locations
  WHERE name = N'Северные земли'
  UNION ALL
  SELECT c.id, c.name, c.parent_id, c.location_type, c.difficulty, c.reward, p.level + 1
  FROM game.locations c
  JOIN LocationTree p ON c.parent_id = p.id
)
SELECT name AS location_name, level, location_type, difficulty, reward
FROM LocationTree;

-- Block 7
WITH LocationTree AS (
  SELECT id, name, difficulty, reward
  FROM game.locations
  WHERE name = N'Северные земли'
  
  UNION ALL
  
  SELECT c.id, c.name, c.difficulty, c.reward
  FROM game.locations c
  JOIN LocationTree p ON c.parent_id = p.id
)
SELECT TOP 1 name, reward, difficulty
FROM LocationTree
ORDER BY reward DESC;

-- Block 8
WITH LocationTree AS (
  SELECT id, name, parent_id, 0 AS level
  FROM game.locations
  WHERE name = N'Северные земли'
  UNION ALL
  SELECT c.id, c.name, c.parent_id, p.level + 1
  FROM game.locations c
  JOIN LocationTree p ON c.parent_id = p.id
)
SELECT REPLICATE(N'    ', level) + name AS display_name
FROM LocationTree;

-- Final Block
WITH LocationTree AS (
  SELECT id, name, parent_id, location_type, difficulty, reward, 0 AS level
  FROM game.locations
  WHERE name = N'Королевство'
  UNION ALL
  SELECT c.id, c.name, c.parent_id, c.location_type, c.difficulty, c.reward, p.level + 1
  FROM game.locations c
  JOIN LocationTree p ON c.parent_id = p.id
)
SELECT
  REPLICATE(N'    ', level) + name AS display_name, location_type, level, difficulty, reward,
  CASE
  WHEN difficulty BETWEEN 1 AND 3 THEN N'Безопасная'
  WHEN difficulty BETWEEN 4 AND 6 THEN N'Опасная'
  WHEN difficulty BETWEEN 7 AND 9 THEN N'Очень опасная'
  WHEN difficulty = 10 THEN N'Босс'
  END AS danger_level
FROM LocationTree;

-- Bonus Mission
WITH AncestorDescendant AS (
  SELECT parent_id AS ancestor_id, id AS descendant_id, reward
  FROM game.locations
  WHERE parent_id IS NOT NULL
  
  UNION ALL
  
  SELECT ad.ancestor_id, l.id, l.reward
  FROM AncestorDescendant ad
  JOIN game.locations l ON l.parent_id = ad.descendant_id
)
SELECT
  l.name,
  l.reward AS own_reward,
  ISNULL(SUM(ad.reward), 0) AS total_children_reward
FROM game.locations l
LEFT JOIN AncestorDescendant ad ON ad.ancestor_id = l.id
GROUP BY l.id, l.name, l.reward
ORDER BY l.id;