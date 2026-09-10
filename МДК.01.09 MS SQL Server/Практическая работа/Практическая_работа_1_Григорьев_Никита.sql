USE CollegeDB;
-- Block 1
-- Zadanie 1
DECLARE @age INT = 18;
SELECT @age AS T1_Age;

-- Zadanie 2
DECLARE @age2 INT = 18;
SET @age2 = 19;
SELECT @age2 AS T2_Age;

-- Zadanie 3
DECLARE @name NVARCHAR(50) = N'Nigga';
DECLARE @age3 INT = 18;
DECLARE @averageGrade DECIMAL(3,2) = 2.70;
SELECT @name AS name, @age3 AS age, @averageGrade AS average_grade;
GO
-- Block 2

-- Zadanie 4
DECLARE @studentName NVARCHAR(50);
SELECT @studentName = name FROM college.students WHERE id = 1;
SELECT @studentName AS Task4_StudentName;

-- Zadanie 5
DECLARE @sName NVARCHAR(50), @sAge INT, @sGrade DECIMAL(3,2);
SELECT @sName = name, @sAge = age, @sGrade = average_grade 
FROM college.students WHERE id = 1;
SELECT @sName AS name, @sAge AS age, @sGrade AS average_grade;

-- Zadanie 6
DECLARE @studentCount INT;
SELECT @studentCount = COUNT(*) FROM college.students;
SELECT @studentCount AS Task6_StudentCount;
GO

-- Block 3
-- Zadanie 7
DECLARE @age7 INT = 18;
SELECT @age7 AS current_age, (@age7 + 5) AS future_age;

-- Zadanie 8
DECLARE @grade1 DECIMAL(3,2) = 4.5;
DECLARE @grade2 DECIMAL(3,2) = 5.0;
DECLARE @grade3 DECIMAL(3,2) = 4.0;
SELECT (@grade1 + @grade2 + @grade3) / 3.0 AS Task8_AverageGrade; 

-- Zadanie 9
DECLARE @price DECIMAL(10,2) = 1500;
DECLARE @discount DECIMAL(5,2) = 10;
DECLARE @finalPrice DECIMAL(10,2) = @price - (@price * @discount / 100);
SELECT @price AS Цена, @discount AS Скидка, @finalPrice AS Итоговая_цена;
GO

-- Block 4
-- Zadanie 10
DECLARE @age10 INT = 18;
IF @age10 >= 18
    PRINT 'Совершеннолетний';
ELSE
    PRINT 'Несовершеннолетний';

-- Zadanie 11
DECLARE @grade11 DECIMAL(3,2) = 3.5;
IF @grade11 >= 3.0
    PRINT 'Студент успевает';
ELSE
    PRINT 'Есть задолженность';

-- Zadanie 12
DECLARE @price12 DECIMAL(10,2) = 6000;
IF @price12 >= 5000
    PRINT 'Большая покупка';
ELSE
    PRINT 'Обычная покупка';
GO

-- Block 5
-- Zadanie 13
DECLARE @age13 INT = 19;
IF @age13 < 18
    PRINT 'Несовершеннолетний';
ELSE IF @age13 BETWEEN 18 AND 19
    PRINT '18-19 лет';
ELSE
    PRINT '20+';

-- Zadanie 14
DECLARE @averageGrade14 DECIMAL(3,2) = 4.2;
IF @averageGrade14 >= 4.5
    PRINT 'Отличник';
ELSE IF @averageGrade14 >= 3.5
    PRINT 'Хорошист';
ELSE IF @averageGrade14 >= 3.0
    PRINT 'Успевает';
ELSE
    PRINT 'Есть задолженность';
GO


-- Block 5
-- Zadanie 15
SELECT name, age,
CASE 
    WHEN age < 18 THEN 'Младше 18'
    WHEN age BETWEEN 18 AND 19 THEN '18-19 лет'
    ELSE '20+'
END AS age_group
FROM college.students;

-- Zadanie 16
SELECT name, average_grade,
CASE 
    WHEN average_grade >= 4.5 THEN 'Отличник'
    WHEN average_grade >= 3.5 THEN 'Хорошист'
    WHEN average_grade >= 3.0 THEN 'Успевает'
    ELSE 'Есть задолженность'
END AS result
FROM college.students;

-- Zadanie  17
SELECT name, age,
CASE 
    WHEN age >= 18 THEN 'Совершеннолетний'
    ELSE 'Несовершеннолетний'
END AS age_status
FROM college.students;
GO
-- Block 6
-- Zadanie 18
DECLARE @averageGroupGrade DECIMAL(3,2);
SELECT @averageGroupGrade = AVG(average_grade) FROM college.students;
SELECT @averageGroupGrade AS Task18_AverageGroupGrade;

-- Zadanie 19
DECLARE @avgGrade19 DECIMAL(3,2);
SELECT @avgGrade19 = AVG(average_grade) FROM college.students;

IF @avgGrade19 >= 4.5
    PRINT 'Группа показывает отличный результат';
ELSE IF @avgGrade19 >= 3.5
    PRINT 'Группа показывает хороший результат';
ELSE IF @avgGrade19 >= 3.0
    PRINT 'Группа успевает';
ELSE
    PRINT 'Группе необходимо улучшить результаты';
GO
-- Block 7
-- Zadanie 20
DECLARE @studentId INT = 1;
DECLARE @t20_Name NVARCHAR(50);
DECLARE @t20_Age INT;
DECLARE @t20_Grade DECIMAL(3,2);
DECLARE @ageCategory NVARCHAR(50);
DECLARE @eduResult NVARCHAR(50);

SELECT @t20_Name = name, @t20_Age = age, @t20_Grade = average_grade 
FROM college.students WHERE id = @studentId;

SET @ageCategory = CASE 
    WHEN @t20_Age < 18 THEN 'Младше 18'
    WHEN @t20_Age BETWEEN 18 AND 19 THEN '18-19 лет'
    ELSE '20+'
END;

SET @eduResult = CASE 
    WHEN @t20_Grade >= 4.5 THEN 'Отличник'
    WHEN @t20_Grade >= 3.5 THEN 'Хорошист'
    WHEN @t20_Grade >= 3.0 THEN 'Успевает'
    ELSE 'Есть задолженность'
END;

PRINT 'Информация о студенте:';
PRINT 'Имя: ' + @t20_Name;
PRINT 'Возраст: ' + CAST(@t20_Age AS NVARCHAR(10));
PRINT 'Возрастная группа: ' + @ageCategory;
PRINT 'Средний балл: ' + CAST(@t20_Grade AS NVARCHAR(10));
PRINT 'Результат: ' + @eduResult;