USE CollegeDB;
GO

-- Zadanie 1
SELECT 
    s.name AS student_name,
    g.name AS group_name,
    s.average_grade,
    COUNT(gr.id) AS grades_count,
    AVG(CAST(gr.grade AS DECIMAL(3,2))) AS avg_grade_from_grades
FROM college.students s
JOIN college.groups g ON s.group_id = g.id
LEFT JOIN college.grades gr ON s.id = gr.student_id
GROUP BY 
    s.id, s.name, g.name, s.average_grade;
GO

-- Zadanie 2
WITH StudentStats AS (
    SELECT 
        id,
        name,
        group_id,
        average_grade
    FROM college.students
)
SELECT 
    name,
    average_grade,
    RANK() OVER (ORDER BY average_grade DESC) AS rating
FROM StudentStats;
GO

-- Zadanie 3
WITH StudentStats AS (
    SELECT 
        s.name AS student_name,
        g.name AS group_name,
        s.average_grade
    FROM college.students s
    JOIN college.groups g ON s.group_id = g.id
)
SELECT 
    student_name,
    group_name,
    average_grade,
    RANK() OVER (PARTITION BY group_name ORDER BY average_grade DESC) AS group_rating
FROM StudentStats;
GO

-- Zadanie 4
CREATE OR ALTER VIEW college.StudentRating AS
SELECT 
    s.id,
    s.name,
    g.name AS group_name,
    s.average_grade,
    RANK() OVER (PARTITION BY g.name ORDER BY s.average_grade DESC) AS group_rating
FROM college.students s
JOIN college.groups g ON s.group_id = g.id;
GO

SELECT * FROM college.StudentRating;
SELECT * FROM college.StudentRating WHERE group_name = N'ИС-31';
GO

-- Zadanie 5
CREATE OR ALTER PROCEDURE college.GetStudentsByMinGrade
    @min_grade DECIMAL(3,2)
AS
BEGIN
    SELECT 
        id,
        name,
        average_grade
    FROM college.students
    WHERE average_grade >= @min_grade
    ORDER BY average_grade DESC;
END;
GO

EXEC college.GetStudentsByMinGrade @min_grade = 4.5;
EXEC college.GetStudentsByMinGrade @min_grade = 3.5;
GO

-- Zadanie 6
CREATE OR ALTER FUNCTION college.GetStudentStatus(@average_grade DECIMAL(3,2))
RETURNS NVARCHAR(100)
AS
BEGIN
    DECLARE @status NVARCHAR(100);
    
    IF @average_grade >= 4.5
        SET @status = N'Отличник';
    ELSE IF @average_grade >= 3.5
        SET @status = N'Хорошист';
    ELSE
        SET @status = N'Требуется дополнительная подготовка';
        
    RETURN @status;
END;
GO

SELECT 
    name,
    average_grade,
    college.GetStudentStatus(average_grade) AS status
FROM college.students;
GO

-- Zadanie 7
CREATE OR ALTER FUNCTION college.GetStudentsByGroup(@group_id INT)
RETURNS TABLE
AS
RETURN 
(
    SELECT 
        id,
        name,
        age,
        average_grade
    FROM college.students
    WHERE group_id = @group_id
);
GO

SELECT * FROM college.GetStudentsByGroup(1);
SELECT * FROM college.GetStudentsByGroup(1) WHERE average_grade >= 4.5;
GO

-- Zadanie 8
DROP TABLE IF EXISTS college.student_changes;
GO

CREATE TABLE college.student_changes (
    id INT IDENTITY(1,1) PRIMARY KEY,
    student_id INT,
    old_average_grade DECIMAL(3,2),
    new_average_grade DECIMAL(3,2),
    change_date DATETIME DEFAULT GETDATE()
);
GO

CREATE OR ALTER TRIGGER college.trg_Students_AverageGradeAudit
ON college.students
AFTER UPDATE
AS
BEGIN
    IF UPDATE(average_grade)
    BEGIN
        INSERT INTO college.student_changes (student_id, old_average_grade, new_average_grade, change_date)
        SELECT 
            d.id,
            d.average_grade,
            i.average_grade,
            GETDATE()
        FROM deleted d
        INNER JOIN inserted i ON d.id = i.id
        WHERE d.average_grade <> i.average_grade; 
    END
END;
GO


IF EXISTS (SELECT * FROM sys.triggers WHERE name = 'trg_Students_ValidateGrade')
    DISABLE TRIGGER trg_Students_ValidateGrade ON college.students;
GO

UPDATE college.students
SET average_grade = average_grade + 0.1
WHERE id = 1;

SELECT * FROM college.student_changes;

UPDATE college.students
SET average_grade = average_grade + 0.1
WHERE group_id = 1;

SELECT * FROM college.student_changes;

IF EXISTS (SELECT * FROM sys.triggers WHERE name = 'trg_Students_ValidateGrade')
    ENABLE TRIGGER trg_Students_ValidateGrade ON college.students;
GO

-- final
SELECT 
    sr.name AS student_name,
    sr.group_name,
    sr.average_grade,
    college.GetStudentStatus(sr.average_grade) AS status,
    sr.group_rating,
    COUNT(gr.id) AS grades_count
FROM college.StudentRating sr
LEFT JOIN college.grades gr ON sr.id = gr.student_id
GROUP BY 
    sr.id, 
    sr.name, 
    sr.group_name, 
    sr.average_grade, 
    sr.group_rating
ORDER BY 
    sr.group_name, 
    sr.group_rating;
GO