USE CollegeDB;
GO

-- zadanie 1
CREATE TABLE college.student_changes (
    id INT IDENTITY(1,1) PRIMARY KEY,
    student_id INT,
    old_average_grade DECIMAL(3,2),
    new_average_grade DECIMAL(3,2),
    change_date DATETIME DEFAULT GETDATE()
);
GO

-- zadanie 2
CREATE TRIGGER college.trg_Students_AverageGradeAudit
ON college.students
AFTER UPDATE
AS
BEGIN
    SET NOCOUNT ON;
    
    INSERT INTO college.student_changes (student_id, old_average_grade, new_average_grade, change_date)
    SELECT d.id, d.average_grade, i.average_grade, GETDATE()
    FROM deleted d
    INNER JOIN inserted i ON d.id = i.id
    WHERE d.average_grade <> i.average_grade 
       OR (d.average_grade IS NULL AND i.average_grade IS NOT NULL)
       OR (d.average_grade IS NOT NULL AND i.average_grade IS NULL);
END;
GO

-- zadanie 3
UPDATE college.students SET average_grade = 4.8 WHERE id = 1;
SELECT * FROM college.student_changes;
GO

-- zadanie 4
UPDATE college.students SET average_grade = average_grade + 0.1 WHERE group_id = 1;
SELECT * FROM college.student_changes;
GO

-- zadanie 5
CREATE TRIGGER college.trg_Students_ValidateGrade
ON college.students
AFTER INSERT, UPDATE
AS
BEGIN
    SET NOCOUNT ON;
    
    IF EXISTS (SELECT 1 FROM inserted WHERE average_grade < 0 OR average_grade > 5)
    BEGIN
        THROW 50000, 'Средний балл должен находиться в диапазоне 0-5', 1;
    END
END;
GO

-- zadanie 6
UPDATE college.students SET average_grade = 4.5 WHERE id = 2;
UPDATE college.students SET average_grade = 6.0 WHERE id = 2;
SELECT * FROM college.students WHERE id = 2;
GO

-- final zadanie
ALTER TABLE college.student_changes ADD old_age INT, new_age INT;
GO

ALTER TRIGGER college.trg_Students_AverageGradeAudit
ON college.students
AFTER UPDATE
AS
BEGIN
    SET NOCOUNT ON;
    
    INSERT INTO college.student_changes (student_id, old_average_grade, new_average_grade, old_age, new_age, change_date)
    SELECT 
        d.id, 
        d.average_grade, 
        i.average_grade, 
        d.age, 
        i.age, 
        GETDATE()
    FROM deleted d
    INNER JOIN inserted i ON d.id = i.id
    WHERE d.average_grade <> i.average_grade 
       OR d.age <> i.age
       OR (d.average_grade IS NULL AND i.average_grade IS NOT NULL)
       OR (d.average_grade IS NOT NULL AND i.average_grade IS NULL)
       OR (d.age IS NULL AND i.age IS NOT NULL)
       OR (d.age IS NOT NULL AND i.age IS NULL);
END;
GO

UPDATE college.students 
SET age = age + 1, average_grade = average_grade + 0.1 
WHERE id = 3;

SELECT * FROM college.student_changes;
GO