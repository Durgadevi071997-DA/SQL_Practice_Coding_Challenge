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

-- 1. Find duplicate customer records

SELECT Customer_Name, COUNT(*) AS DuplicateCount
FROM Customers
GROUP BY Customer_Name
HAVING COUNT(*) > 1;  

SELECT Emp_ID,
       emp_name,
       IFNULL(Salary, 0) AS Salary
FROM Employees; 

SELECT *
FROM Employees
ORDER BY Salary DESC
LIMIT 5;  

SELECT *
FROM Employees
WHERE emp_name LIKE 'A%';  

SELECT *
FROM Orders
WHERE order_date BETWEEN '2025-01-01' AND '2025-03-31';  

SELECT E.emp_name,
       D.dept_name
FROM Employees E
JOIN Departments D
ON E.dept_id = D.dept_id;  

SELECT *
FROM Employees
WHERE dept_id IS NULL;  

SELECT D.dept_name,
       E.emp_name
FROM Departments D
LEFT JOIN Employees E
ON D.dept_id = E.dept_id; 

-- 9. Records present in one table but missing in another

SELECT *
FROM Customers C
LEFT JOIN Orders O
ON C.Customer_ID = O.Customer_ID
WHERE O.Customer_ID IS NULL; 

-- 10. Customers who placed and did not place orders

SELECT C.Customer_Name,
       O.Order_ID
FROM Customers C
LEFT JOIN Orders O
ON C.Customer_ID = O.Customer_ID; 

-- 11. Total sales month-wise

SELECT MONTH(order_date) AS MonthNo,
       SUM(Amount) AS TotalSales
FROM Sales
GROUP BY MONTH(order_date); 

SELECT * FROM Sales; 

-- 12. Average salary department-wise

SELECT dept_id,
       AVG(Salary) AS AverageSalary
FROM Employees
GROUP BY dept_id;  

-- 13. Department with maximum employees

SELECT dept_id,
       COUNT(*) AS EmployeeCount
FROM Employees
GROUP BY dept_id
ORDER BY EmployeeCount DESC
LIMIT 1; 

SELECT MAX(Salary) AS SecondHighestSalary
FROM Employees
WHERE Salary < (
    SELECT MAX(Salary)
    FROM Employees
); 

-- 15. Find duplicate emails

SELECT Email,
       COUNT(*) AS DuplicateCount
FROM Customers
GROUP BY Email
HAVING COUNT(*) > 1;

-- 16. Compare this month sales with last month

SELECT MONTH(order_date) AS MonthNo,
       SUM(Amount) AS CurrentMonthSales,
       LAG(SUM(Amount)) OVER (
           ORDER BY MONTH(order_Date)
       ) AS PreviousMonthSales
FROM Sales
GROUP BY MONTH(order_date);

-- 17. Top 3 products by revenue

SELECT Product_ID,
       SUM(amount) AS TotalRevenue
FROM Sales
GROUP BY Product_ID
ORDER BY TotalRevenue DESC
LIMIT 3;
-- 18. City with highest customers

SELECT City,
       COUNT(*) AS CustomerCount
FROM Customers
GROUP BY City
ORDER BY CustomerCount DESC 
LIMIT 1;

-- 19. Customers who purchased more than 5 times

SELECT Customer_ID,
       COUNT(Order_ID) AS TotalOrders
FROM Orders
GROUP BY Customer_ID
HAVING COUNT(Order_ID) > 5;
-- 20. Inactive customers for last 6 months

SELECT *
FROM Customers
WHERE Customer_ID NOT IN (
    SELECT Customer_ID
    FROM Orders
    WHERE Order_Date >= DATE_SUB(CURDATE(), INTERVAL 6 MONTH)
);
-- Window Function Scenarios
-- 21. Rank employees based on salary

SELECT emp_name,
       Salary,
       RANK() OVER (
           ORDER BY Salary DESC
       ) AS SalaryRank
FROM Employees;
-- 22. Running total of sales by date

SELECT order_Date,
       Amount,
       SUM(Amount) OVER (
           ORDER BY order_Date
       ) AS RunningTotal
FROM Sales;
-- 23. Previous month sales using LAG()

SELECT MONTH(order_Date) AS MonthNo,
       SUM(Amount) AS TotalSales,
       LAG(SUM(Amount)) OVER (
           ORDER BY MONTH(order_Date)
       ) AS PreviousMonthSales
FROM Sales
GROUP BY MONTH(order_Date);
-- 24. Top performer in each sales region

SELECT *
FROM (
    SELECT emp_name,
           Region,
           sales,
           RANK() OVER (
               PARTITION BY Region
               ORDER BY Sales DESC
           ) AS RegionRank
    FROM SalesTeam
) RankedData
WHERE RegionRank = 1;

SELECT * FROM SalesTeam;
-- 25. Assign row numbers to duplicate customers

SELECT Customer_Name,
       Email,
       ROW_NUMBER() OVER (
           PARTITION BY Email
           ORDER BY Customer_ID
       ) AS RowNum
FROM Customers;

-- 26. Create index on employee name

CREATE INDEX idx_emp_name
ON Employees(emp_name);

-- 27. Improve sales table performance using indexing
CREATE INDEX idx_order_date
ON Sales(order_Date);
-- 28. CTE for employees salary greater than 50000

WITH HighSalaryEmployees AS (
    SELECT *
    FROM Employees
    WHERE Salary > 50000
)
SELECT *
FROM HighSalaryEmployees;
-- 29. Create index on customer email

CREATE INDEX idx_customer_email
ON Customers(Email);

-- 30. Extract today's sales report automatically

SELECT *
FROM Sales
WHERE DATE(Order_Date) = CURDATE(); 

SELECT 
    SUM(Amount) AS TotalSales
FROM Sales; 

-- 32. Remove duplicate customer records keeping one record

DELETE C1
FROM Customers C1
JOIN Customers C2
ON C1.Email = C2.Email
AND C1.Customer_ID > C2.Customer_ID; 

-- 33. Join Customers, Orders, and Products tables

SELECT 
    C.Customer_Name,
    O.Order_ID,
    P.Product_Name,
    P.Price
FROM Customers C
JOIN Orders O
ON C.Customer_ID = O.Customer_ID
JOIN Products P
ON O.Product_ID = P.Product_ID; 

-- 34. Generate monthly sales report

SELECT 
    MONTH(Order_Date) AS MonthNo,
    SUM(Amount) AS MonthlySales
FROM Sales
GROUP BY MONTH(Order_Date)
ORDER BY MonthNo; 

-- 35. Find highest-selling product based on number of orders

SELECT 
    P.Product_Name,
    COUNT(O.Order_ID) AS TotalOrders
FROM Orders O
JOIN Products P
ON O.Product_ID = P.Product_ID
GROUP BY P.Product_Name
ORDER BY TotalOrders DESC
LIMIT 1; 

SELECT *
FROM Employees
WHERE Salary > (
    SELECT AVG(Salary)
    FROM Employees
); 

-- 2. Find employees who earn more than Ravi

SELECT *
FROM Employees
WHERE Salary > (
    SELECT Salary
    FROM Employees
    WHERE emp_name = 'Ravi'
); 

-- 3. Find employees who joined after Meena

SELECT *
FROM Employees
WHERE JoinDate > (
    SELECT JoinDate
    FROM Employees
    WHERE emp_name = 'Meena'
);

SELECT * FROM Employees; 
DESC Employees;

-- 4. Find employees whose salary is greater
-- than the average salary of the IT department
SELECT E.*
FROM Employees E
JOIN Departments D
ON E.dept_id = D.dept_id
WHERE E.Salary > (
    SELECT AVG(E2.Salary)
    FROM Employees E2
    JOIN Departments D2
    ON E2.dept_id = D2.dept_id
    WHERE D2.dept_name = 'IT'
);


SELECT *
FROM Employees
WHERE PerformanceRating > (
    SELECT AVG(PerformanceRating)
    FROM Employees
);

SELECT * FROM Employees; 

-- 1. Find employees who work in departments
-- located in Chennai or Bangalore

SELECT *
FROM Employees
WHERE dept_ID IN (
    SELECT Dept_ID
    FROM Departments
    WHERE city IN ('Chennai', 'Bangalore')
);    

-- 2. Find employees who work in departments located in Pune

SELECT *
FROM Employees
WHERE Dept_ID IN (
    SELECT Dept_ID
    FROM Departments
    WHERE city = 'Pune'
); 

-- 3. Find employees whose salary is greater than
-- any employee in the Marketing department

SELECT *
FROM Employees
WHERE Salary > ANY (
    SELECT E2.Salary
    FROM Employees E2
    JOIN Departments D
    ON E2.Dept_id = D.Dept_id
    WHERE D.dept_name = 'Marketing'
) 

-- 4. Find employees whose salary is greater than
-- all employees in the HR department

SELECT *
FROM Employees
WHERE Salary > ALL (
    SELECT E2.Salary
    FROM Employees E2
    JOIN Departments D
    ON E2.Dept_id = D.Dept_id
    WHERE D.dept_name = 'HR'
) 

-- 5. Find employees who belong to departments
-- that have employees with performance rating = 5

SELECT *
FROM Employees
WHERE Dept_id IN (
    SELECT Dept_id
    FROM Employees
    WHERE PerformanceRating = 5
);
ALTER TABLE Employees
ADD PerformanceRating INT;

-- Add Sample Values
UPDATE Employees
SET PerformanceRating = 5
WHERE Emp_ID = 1;



UPDATE Employees
SET PerformanceRating = 4
WHERE Emp_ID = 2;

SELECT *
FROM Employees e
WHERE Salary >
(
    SELECT AVG(Salary)
    FROM Employees
    WHERE Dept_id = e.Dept_id
);  

-- Highest salary in each department
SELECT *
FROM Employees e
WHERE Salary =
(
    SELECT MAX(Salary)
    FROM Employees
    WHERE Dept_id = e.Dept_id
); 

-- Performance > department average
SELECT *
FROM Employees e
WHERE PerformanceRating >
(
    SELECT AVG(PerformanceRating)
    FROM Employees
    WHERE Dept_id = e.Dept_id
); 

-- Joined after department average join date
SELECT *
FROM Employees e
WHERE JoinDate >
(
    SELECT AVG(JoinDate)
    FROM Employees
    WHERE Dept_id = e.Dept_id
); 

ALTER TABLE Employees
ADD JoinDate DATE;


UPDATE Employees
SET JoinDate = '2023-01-15'
WHERE Emp_ID = 1; 

SELECT *
FROM Employees e
WHERE Salary <
(
    SELECT MAX(Salary)
    FROM Employees
    WHERE Dept_id = e.Dept_id
); 

SELECT *
FROM Employees e
WHERE Salary =
(
    SELECT MIN(Salary)
    FROM Employees
    WHERE Dept_id = e.Dept_id
); 

SELECT DISTINCT Dept_id
FROM Employees e
WHERE EXISTS
(
    SELECT 1
    FROM Employees
    WHERE Dept_id = e.Dept_id
    AND Salary > 70000
); 

SELECT *
FROM Employees e
WHERE Salary >
(
    SELECT MIN(Salary)
    FROM Employees
    WHERE Dept_id = e.Dept_id
); 

SELECT *
FROM Employees e
WHERE 1 =
(
    SELECT COUNT(*)
    FROM Employees
    WHERE Dept_id = e.Dept_id
); 

SELECT *
FROM Employees e
WHERE Salary >
(
    SELECT AVG(Salary)
    FROM Employees
    WHERE JoinDate > e.JoinDate
);