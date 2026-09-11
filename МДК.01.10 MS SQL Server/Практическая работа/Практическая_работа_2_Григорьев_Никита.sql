USE CollegeDB;
GO

IF OBJECT_ID('college.students', 'U') IS NOT NULL
    DROP TABLE college.students;
GO

IF OBJECT_ID('college.groups', 'U') IS NOT NULL
    DROP TABLE college.groups;
GO

CREATE TABLE college.groups (
    id INT IDENTITY(1,1) PRIMARY KEY,
    name NVARCHAR(50) NOT NULL
);
GO

CREATE TABLE college.students (
    id INT IDENTITY(1,1) PRIMARY KEY,
    name NVARCHAR(100) NOT NULL,
    age INT NOT NULL,
    average_grade DECIMAL(3,2) NOT NULL,
    group_id INT NOT NULL,
    CONSTRAINT FK_students_groups FOREIGN KEY (group_id) REFERENCES college.groups(id)
);
GO

INSERT INTO college.groups (name)
VALUES
(N'ИС-21'),
(N'ПР-21'),
(N'СА-21');
GO

INSERT INTO college.students (name, age, average_grade, group_id)
VALUES
(N'Иван', 18, 4.7, 1),
(N'Мария', 17, 4.2, 1),
(N'Алексей', 18, 3.6, 1),
(N'Анна', 19, 4.9, 2),
(N'Дмитрий', 17, 2.8, 2),
(N'Елена', 18, 4.5, 3),
(N'Максим', 19, 3.9, 3);
GO

-- Block 1.

-- Zadanie 1
SELECT name, average_grade
FROM college.students
WHERE average_grade > (
    SELECT AVG(average_grade)
    FROM college.students
);

-- Zadanie 2
SELECT name, age
FROM college.students
WHERE age > (
    SELECT AVG(age * 1.0)
    FROM college.students
);

-- Zadanie 3
SELECT name, average_grade
FROM college.students
WHERE average_grade = (
    SELECT MAX(average_grade)
    FROM college.students
);

-- Block 2.

-- Zadanie 4
SELECT name, group_id
FROM college.students
WHERE group_id IN (
    SELECT id
    FROM college.groups
    WHERE name LIKE N'%ИС%'
);

-- Zadanie 5
SELECT name, group_id
FROM college.students
WHERE group_id IN (
    SELECT id
    FROM college.groups
    WHERE name LIKE N'%21'
);

-- Zadanie 6
SELECT name
FROM college.groups
WHERE id IN (
    SELECT group_id
    FROM college.students
    WHERE average_grade > 4.5
);

-- Block 3.

-- Zadanie 7
SELECT name
FROM college.groups AS g
WHERE EXISTS (
    SELECT 1
    FROM college.students AS s
    WHERE s.group_id = g.id
      AND s.average_grade > 4.5
);

-- Zadanie 8
SELECT name
FROM college.groups AS g
WHERE EXISTS (
    SELECT 1
    FROM college.students AS s
    WHERE s.group_id = g.id
      AND s.age < 18
);

-- Zadanie 9
SELECT name
FROM college.groups AS g
WHERE NOT EXISTS (
    SELECT 1
    FROM college.students AS s
    WHERE s.group_id = g.id
      AND s.average_grade < 3.0
);

-- Block 4.

-- Zadanie 10
SELECT s.name, s.average_grade, s.group_id
FROM college.students AS s
WHERE s.average_grade > (
    SELECT AVG(s2.average_grade)
    FROM college.students AS s2
    WHERE s2.group_id = s.group_id
);

-- Zadanie 11
SELECT s.name, s.age, s.group_id
FROM college.students AS s
WHERE s.age > (
    SELECT AVG(s2.age * 1.0)
    FROM college.students AS s2
    WHERE s2.group_id = s.group_id
);

-- Zadanie 12
SELECT s.name, s.average_grade, s.group_id
FROM college.students AS s
WHERE s.average_grade < (
    SELECT AVG(s2.average_grade)
    FROM college.students AS s2
    WHERE s2.group_id = s.group_id
);

-- Block 5.

-- Zadanie 13
SELECT name
FROM college.groups
WHERE id IN (
    SELECT group_id
    FROM college.students
    WHERE average_grade >= 4.5
);

SELECT g.name
FROM college.groups AS g
WHERE EXISTS (
    SELECT 1
    FROM college.students AS s
    WHERE s.group_id = g.id
      AND s.average_grade >= 4.5
);

-- Block 6.

-- Zadanie 14
SELECT s.name, s.average_grade, s.group_id
FROM college.students AS s
WHERE s.group_id IN (
    SELECT id
    FROM college.groups
    WHERE name = N'ПР-21'
)
AND s.average_grade > (
    SELECT AVG(s2.average_grade)
    FROM college.students AS s2
    WHERE s2.group_id = s.group_id
);

-- Zadanie 15
SELECT s.name, s.age, s.average_grade, s.group_id
FROM college.students AS s
WHERE s.age < (
    SELECT AVG(s2.age * 1.0)
    FROM college.students AS s2
    WHERE s2.group_id = s.group_id
)
AND s.average_grade > 4.0;

-- Block 7.

-- Zadanie 16
SELECT 
    s.name AS [Студент],
    s.average_grade AS [Средний балл],
    g.name AS [Группа],
    (SELECT AVG(s2.average_grade) 
     FROM college.students AS s2 
     WHERE s2.group_id = s.group_id) AS [Средний балл группы]
FROM college.students AS s
JOIN college.groups AS g ON s.group_id = g.id
WHERE s.average_grade > (
    SELECT AVG(s3.average_grade)
    FROM college.students AS s3
    WHERE s3.group_id = s.group_id
);