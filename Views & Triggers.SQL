-- ==========================================
-- DATABASE CREATION
-- Tables:
-- Departments, Employees, Customers,
-- Products, Orders, Sales, MonthlySales, SalesTeam
-- ==========================================

CREATE DATABASE SQL_COMPANY_DB;
USE SQL_COMPANY_DB;


-- 1. DEPARTMENTS

CREATE TABLE Departments (
    dept_id INT PRIMARY KEY,
    dept_name VARCHAR(50)
);

INSERT INTO Departments VALUES
(1,'HR'),
(2,'IT'),
(3,'Finance'),
(4,'Sales'),
(5,'Marketing');


-- 2. EMPLOYEES

CREATE TABLE Employees (
    emp_id INT PRIMARY KEY,
    emp_name VARCHAR(50),
    dept_id INT,
    salary DECIMAL(10,2),
    city VARCHAR(50)
);

INSERT INTO Employees VALUES
(101,'Arun',2,55000,'Chennai'),
(102,'Bala',2,60000,'Madurai'),
(103,'Anitha',1,45000,'Trichy'),
(104,'David',3,NULL,'Coimbatore'),
(105,'Asha',4,70000,'Madurai'),
(106,'John',NULL,50000,'Salem'),
(107,'Kavin',4,80000,'Chennai'),
(108,'Meena',5,65000,'Madurai'),
(109,'Priya',2,60000,'Trichy'),
(110,'Ravi',4,80000,'Madurai');


-- 3. CUSTOMERS
-- Includes duplicates

CREATE TABLE Customers (
    customer_id INT PRIMARY KEY,
    customer_name VARCHAR(50),
    email VARCHAR(100),
    city VARCHAR(50)
);

INSERT INTO Customers VALUES
(1,'Raj','raj@gmail.com','Madurai'),
(2,'Kumar','kumar@gmail.com','Chennai'),
(3,'Divya','divya@gmail.com','Madurai'),
(4,'Raj','raj@gmail.com','Madurai'),
(5,'Sneha','sneha@gmail.com','Trichy'),
(6,'Vijay','vijay@gmail.com','Chennai'),
(7,'Rani','rani@gmail.com','Madurai'),
(8,'Arun','arun@gmail.com','Salem');

-- 4. PRODUCTS

CREATE TABLE Products (
    product_id INT PRIMARY KEY,
    product_name VARCHAR(50),
    category VARCHAR(50),
    price DECIMAL(10,2)
);

INSERT INTO Products VALUES
(201,'Laptop','Electronics',55000),
(202,'Mobile','Electronics',25000),
(203,'Shoes','Fashion',3000),
(204,'Watch','Accessories',5000),
(205,'Tablet','Electronics',35000);

-- 5. ORDERS

CREATE TABLE Orders (
    order_id INT PRIMARY KEY,
    customer_id INT,
    product_id INT,
    order_date DATE,
    quantity INT
);

INSERT INTO Orders VALUES
(1001,1,201,'2025-01-10',1),
(1002,2,202,'2025-01-15',2),
(1003,1,203,'2025-02-05',3),
(1004,3,204,'2025-02-12',1),
(1005,4,202,'2025-03-01',1),
(1006,5,201,'2025-03-10',1),
(1007,1,205,'2025-04-05',1),
(1008,6,202,'2025-04-15',2),
(1009,1,204,'2025-05-01',1),
(1010,7,203,'2025-05-12',2),
(1011,1,202,'2025-06-01',1),
(1012,1,203,'2025-06-15',1);


-- 6. SALES

CREATE TABLE Sales (
    sale_id INT PRIMARY KEY,
    order_date DATE,
    product_id INT,
    amount DECIMAL(10,2)
);

INSERT INTO Sales VALUES
(1,'2025-01-10',201,55000),
(2,'2025-01-15',202,50000),
(3,'2025-02-05',203,9000),
(4,'2025-02-12',204,5000),
(5,'2025-03-01',202,25000),
(6,'2025-03-10',201,55000),
(7,'2025-04-05',205,35000),
(8,'2025-04-15',202,50000),
(9,'2025-05-01',204,5000),
(10,'2025-05-12',203,6000),
(11,'2025-06-01',202,25000),
(12,'2025-06-15',203,3000);


-- 7. MONTHLY SALES

CREATE TABLE MonthlySales (
    month VARCHAR(20),
    sales DECIMAL(10,2)
);

INSERT INTO MonthlySales VALUES
('Jan',105000),
('Feb',14000),
('Mar',80000),
('Apr',85000),
('May',11000),
('Jun',28000);


-- 8. SALES TEAM

CREATE TABLE SalesTeam (
    emp_name VARCHAR(50),
    region VARCHAR(50),
    sales DECIMAL(10,2)
);

INSERT INTO SalesTeam VALUES
('Arun','South',80000),
('Bala','South',90000),
('Divya','North',70000),
('John','North',95000),
('Meena','East',60000),
('Priya','East',75000),
('Ravi','West',85000),
('Kavin','West',92000);

-- SIMPLE VIEW: EmployeeBasicView
CREATE VIEW EmployeeBasicView AS
SELECT 
    Emp_Name,
    Dept_id,
    Salary
FROM Employees; 

SELECT * FROM EmployeeBasicView; 
SELECT * FROM EmployeeDepartmentView; 

-- COMPLEX VIEW: EmployeeDepartmentView
CREATE VIEW EmployeeDepartmentView AS
SELECT 
    e.Emp_Name,
    d.Dept_Name,
    e.city,
    e.Salary
FROM Employees e
JOIN Departments d
    ON e.Dept_ID = d.Dept_ID; 
    
    -- COMPLEX VIEW with Aggregation: DeptSalaryStats 
    CREATE VIEW DeptSalaryStats AS
SELECT 
    d.Dept_Name,
    AVG(e.Salary) AS AvgSalary,
    COUNT(e.Emp_ID) AS TotalEmployees
FROM Employees e
JOIN Departments d
    ON e.Dept_ID = d.Dept_ID
GROUP BY d.Dept_Name; 

SET SQL_SAFE_UPDATES = 0; 

-- UPDATE Using VIEW
UPDATE EmployeeBasicView
SET Salary = Salary + 5000;  

SELECT * FROM EmployeebasicView; 

-- DROP VIEW (DeptSalaryStats) 
DROP VIEW DeptSalaryStats; 

DELIMITER $$

CREATE TRIGGER check_min_salary
BEFORE INSERT ON Employees
FOR EACH ROW
BEGIN
    IF NEW.Salary < 30000 THEN
        SET NEW.Salary = 30000;
    END IF;
END $$

DELIMITER ; 

SELECT * FROM Employees;

CREATE TABLE EmployeeAudit (
    Emp_ID INT,
    Emp_Name VARCHAR(100),
    Action VARCHAR(50),
    ActionDate DATETIME
); 
select * from EmployeeAudit; 

CREATE TABLE SalaryLog (
    EmpID INT,
    OldSalary DECIMAL(10,2),
    NewSalary DECIMAL(10,2),
    ChangeDate DATETIME
);

select * from SalaryLog;  

DELIMITER $$

CREATE TRIGGER prevent_it_delete
BEFORE DELETE ON Employees
FOR EACH ROW
BEGIN
    IF OLD.Dept_ID = 1 THEN   -- assume 1 = IT department
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Cannot delete employees from IT department';
    END IF;
END $$

DELIMITER ; 

CREATE TABLE EmployeeArchive (
    EmpID INT,
    EmpName VARCHAR(100),
    DeptID INT,
    Salary DECIMAL(10,2),
    ExitDate DATETIME
); 

Select * from EmployeeArchive;