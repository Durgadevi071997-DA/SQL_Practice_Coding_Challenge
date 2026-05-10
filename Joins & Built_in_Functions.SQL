
-- 1CREATE DATABASE

CREATE DATABASE StudentsDB;
USE StudentsDB;

-- CREATE TABLES

CREATE TABLE Students (
    StudentID INT PRIMARY KEY,
    StudentName VARCHAR(50),
    Age INT,
    City VARCHAR(50)
);

CREATE TABLE Courses (
    CourseID INT PRIMARY KEY,
    CourseName VARCHAR(50),
    Duration VARCHAR(20)
);

CREATE TABLE Enrollments (
    EnrollmentID INT PRIMARY KEY,
    StudentID INT,
    CourseID INT,
    EnrollmentDate DATE,
    FOREIGN KEY (StudentID) REFERENCES Students(StudentID),
    FOREIGN KEY (CourseID) REFERENCES Courses(CourseID)
);


-- INSERT SAMPLE DATA

INSERT INTO Students VALUES
(1, 'Aarav', 21, 'Chennai'),
(2, 'Meera', 22, 'Bangalore'),
(3, 'Karthik', 23, 'Hyderabad'),
(4, 'Divya', 21, 'Delhi');

INSERT INTO Courses VALUES
(101, 'Data Analytics', '3 Months'),
(102, 'Python Programming', '2 Months'),
(103, 'SQL Basics', '1 Month');

INSERT INTO Enrollments VALUES
(1001, 1, 101, '2025-05-10'),
(1002, 2, 102, '2025-06-01'),
(1003, 3, 103, '2025-06-15'); 

-- Question 1 – INNER JOIN
SELECT S.StudentID,
       S.StudentName,
       C.CourseName
FROM Enrollments E
INNER JOIN Students S
    ON E.StudentID = S.StudentID
INNER JOIN Courses C
    ON E.CourseID = C.CourseID;
    
SELECT S.StudentID,
       S.StudentName,
       C.CourseName
FROM Students S
LEFT JOIN Enrollments E
    ON S.StudentID = E.StudentID
LEFT JOIN Courses C
    ON E.CourseID = C.CourseID;  
    
SELECT S.StudentID,
       S.StudentName,
       C.CourseName
FROM Students S
RIGHT JOIN Enrollments E
    ON S.StudentID = E.StudentID
RIGHT JOIN Courses C
    ON E.CourseID = C.CourseID;  
    
    -- Question 3 – ROUND()

SELECT ROUND(123.4567, 2) AS Rounded_Value;
SELECT 
    ABS(-25) AS Absolute_Value,
    MOD(25, 4) AS Remainder_Value;  
    
    SELECT 
    StudentName,
    City,
    CONCAT(StudentName, ' from ', City) AS Full_Description
FROM Students;  

-- Question 6 – LENGTH()

SELECT 
    StudentName,
    LENGTH(StudentName) AS Name_Length
FROM Students;  

-- Question 7 – REPLACE()

SELECT 
    CourseName,
    REPLACE(CourseName, 'SQL', 'Database') AS Updated_CourseName
FROM Courses;  

-- Question 7 – REPLACE()

SELECT 
    CourseName,
    REPLACE(CourseName, 'SQL', 'Database') AS Updated_CourseName
FROM Courses; 

SELECT 
    StudentName,
    SUBSTRING(StudentName, 1, 3) AS Code_Prefix
FROM Students;  

-- Question 9 – UPPER() & LOWER()

SELECT 
    StudentName,
    UPPER(StudentName) AS UPPER_Name,
    LOWER(StudentName) AS LOWER_Name
FROM Students;  

SELECT 
    S.StudentName,
    E.EnrollmentDate,
    DATE_ADD(E.EnrollmentDate, INTERVAL 10 DAY) AS FollowUp_Date,
    DATEDIFF('2025-06-01', '2025-05-10') AS Days_Difference,
    NOW() AS Current_DateTime
FROM Students S
JOIN Enrollments E
    ON S.StudentID = E.StudentID;