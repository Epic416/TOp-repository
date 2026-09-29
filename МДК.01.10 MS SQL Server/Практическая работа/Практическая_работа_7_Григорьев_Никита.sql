USE CollegeDB;
GO

-- Zadanie 1
IF OBJECT_ID('college.GetStudentStatus', 'FN') IS NOT NULL
    DROP FUNCTION college.GetStudentStatus;
GO

CREATE FUNCTION college.GetStudentStatus(@average_grade DECIMAL(3,2))
RETURNS NVARCHAR(50)
AS
BEGIN
    DECLARE @status NVARCHAR(50);
    IF @average_grade >= 4.5
        SET @status = N'Отличник';
    ELSE IF @average_grade >= 3.5
        SET @status = N'Хорошист';
    ELSE
        SET @status = N'Требуется дополнительная подготовка';
    RETURN @status;
END;
GO

SELECT college.GetStudentStatus(5.0);
SELECT college.GetStudentStatus(4.2);
SELECT college.GetStudentStatus(3.1);
GO

-- Zadanie 2
IF OBJECT_ID('college.CalculateDiscount', 'FN') IS NOT NULL
    DROP FUNCTION college.CalculateDiscount;
GO

CREATE FUNCTION college.CalculateDiscount(@price DECIMAL(10,2), @discount INT)
RETURNS DECIMAL(10,2)
AS
BEGIN
    RETURN @price - (@price * @discount / 100.0);
END;
GO

SELECT college.CalculateDiscount(10000, 10);
SELECT college.CalculateDiscount(25000, 15);
GO

SELECT 
    name,
    average_grade,
    college.CalculateDiscount(10000, 10) AS discounted_price
FROM college.students;
GO

-- Zadanie 3
SELECT 
    s.name,
    g.name AS group_name,
    s.average_grade,
    college.GetStudentStatus(s.average_grade) AS status
FROM college.students s
JOIN college.groups g ON s.group_id = g.id;
GO

-- Zadanie 4
IF OBJECT_ID('college.GetStudentsByGroup', 'IF') IS NOT NULL
    DROP FUNCTION college.GetStudentsByGroup;
GO

CREATE FUNCTION college.GetStudentsByGroup(@group_id INT)
RETURNS TABLE
AS
RETURN 
(
    SELECT id, name, age, average_grade, group_id
    FROM college.students
    WHERE group_id = @group_id
);
GO

SELECT * FROM college.GetStudentsByGroup(1);
GO

-- Zadanie 5
SELECT
    s.name,
    g.name AS group_name,
    s.average_grade
FROM college.GetStudentsByGroup(1) s
JOIN college.groups g ON g.id = s.group_id;
GO

-- Zadanie 6
IF OBJECT_ID('college.GetAgeCategory', 'FN') IS NOT NULL
    DROP FUNCTION college.GetAgeCategory;
GO

CREATE FUNCTION college.GetAgeCategory(@age INT)
RETURNS NVARCHAR(50)
AS
BEGIN
    DECLARE @category NVARCHAR(50);
    IF @age < 18
        SET @category = N'Несовершеннолетний';
    ELSE IF @age <= 20
        SET @category = N'Студент';
    ELSE
        SET @category = N'Взрослый';
    RETURN @category;
END;
GO

SELECT college.GetAgeCategory(17);
SELECT college.GetAgeCategory(19);
SELECT college.GetAgeCategory(25);
GO

SELECT 
    name,
    age,
    college.GetAgeCategory(age) AS age_category
FROM college.students;
GO

-- Final Zadanie
SELECT
    s.name,
    g.name AS group_name,
    s.age,
    s.average_grade,
    college.GetStudentStatus(s.average_grade) AS student_status,
    college.GetAgeCategory(s.age) AS age_category
FROM college.students s
JOIN college.groups g ON s.group_id = g.id;
GO