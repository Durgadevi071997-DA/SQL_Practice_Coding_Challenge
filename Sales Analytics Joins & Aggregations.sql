-- Sales Analytics SQL JOins & Aggregations

CREATE DATABASE Sales_Analytics;
USE Sales_Analytics;

-- 1. List all orders along with customer names
SELECT o.orderid,
       c.customerName,
       o.orderdate
FROM Orders o
INNER JOIN Customers c
ON o.customerid = c.customerid;
-- 2. Show all customers and their orders using LEFT JOIN
SELECT c.customerid,
       c.customerName,
       o.orderid,
       o.orderdate
FROM Customers c
LEFT JOIN Orders o
ON c.customerid = o.customerid;
-- 3. Show salesperson name and assigned orders using RIGHT JOIN
SELECT s.salespersonname,
       o.orderid,
       o.orderdate
FROM Orders o
RIGHT JOIN Salespersons s
ON o.salespersonid = s.salespersonid;
-- 4. List all orders with Customer Name, Product Name, Quantity, and Order Date
SELECT o.orderid,
       c.customerName,
       p.productname,
       o.quantity,
       o.orderdate
FROM Orders o
INNER JOIN Customers c
ON o.customerid = c.customerid
INNER JOIN Products p
ON o.productid = p.productid
ORDER BY o.orderid;

-- 5. Display all orders from Chennai customers with product details
SELECT c.customername,
       c.city,
       p.productname,
       o.quantity,
       o.orderdate
FROM Customers c
INNER JOIN Orders o
ON c.customerid = o.customerid
INNER JOIN Products p
ON o.productid = p.productid
WHERE c.city = 'Chennai';
-- 6. Display all customers who purchased Laptop
SELECT DISTINCT c.customerName
FROM Customers c
INNER JOIN Orders o
ON c.customerid = o.customerid
INNER JOIN Products p
ON o.productid = p.productid
WHERE p.productname = 'Laptop';


-- 7. Show total sales amount (Price × Quantity) for each order
SELECT 
    o.OrderID,
    SUM(p.Price * o.Quantity) AS Total_Sales_Amount
FROM Orders o
JOIN Products p
ON o.ProductID = p.ProductID
GROUP BY o.OrderID;
-- 8. Find the top 5 customers by total purchase amount
SELECT 
    c.CustomerName,
    SUM(p.Price * o.Quantity) AS Total_Purchase
FROM Orders o
JOIN Customers c
ON o.CustomerID = c.CustomerID
JOIN Products p
ON o.ProductID = p.ProductID
GROUP BY c.CustomerName
ORDER BY Total_Purchase DESC
LIMIT 5;
-- 9. Show each Salesperson’s region and the total sales value
SELECT 
    s.SalespersonName,
    s.Region,
    SUM(p.Price * o.Quantity) AS Total_Sales_Value
FROM Orders o
JOIN Salespersons s
ON o.SalespersonID = s.SalespersonID
JOIN Products p
ON o.ProductID = p.ProductID
GROUP BY s.SalespersonName, s.Region;

-- 10. Find the most sold product with total quantity
SELECT 
    p.ProductName,
    SUM(o.Quantity) AS Total_Quantity_Sold
FROM Orders o
JOIN Products p
ON o.ProductID = p.ProductID
GROUP BY p.ProductName
ORDER BY Total_Quantity_Sold DESC
LIMIT 1;

-- 11. Show the earliest (minimum) and latest (maximum) order date
SELECT 
    MIN(OrderDate) AS Earliest_Order_Date,
    MAX(OrderDate) AS Latest_Order_Date
FROM Orders;

SELECT *
FROM Orders
WHERE YEAR(OrderDate) = 2025
AND MONTH(OrderDate) = 1; 

-- 13. List orders week-wise (show week number and total orders)
SELECT 
    WEEK(OrderDate) AS Week_Number,
    COUNT(OrderID) AS Total_Orders
FROM Orders
GROUP BY WEEK(OrderDate)
ORDER BY Week_Number; 

-- 14. Display orders along with the day name
SELECT 
    OrderID,
    OrderDate,
    DAYNAME(OrderDate) AS Day_Name
FROM Orders; 

-- 15. Extract day name and display total sales amount and quantity per day of week
SELECT 
    DAYNAME(OrderDate) AS Day_Name,
    SUM(Price * Quantity) AS Total_Sales_Amount,
    SUM(Quantity) AS Total_Quantity
FROM Orders
GROUP BY 
    DAYNAME(OrderDate),
    DAYOFWEEK(OrderDate)
ORDER BY 
    FIELD(
        DAYNAME(OrderDay),
        'Monday',
        'Tuesday',
        'Wednesday',
        'Thursday',
        'Friday',
        'Saturday',
        'Sunday'
    );

-- 1. Find customers who live in the same city as 'Arjun Kumar'

SELECT *
FROM Customers
WHERE City = (
    SELECT City
    FROM Customers
    WHERE CustomerName = 'Arjun Kumar'
); 

-- 2. Find products that are more expensive than the average product price

SELECT *
FROM Products
WHERE Price > (
    SELECT AVG(Price)
    FROM Products
); 

-- 3. Find products belonging to the same category as 'Laptop'

SELECT *
FROM Products
WHERE Category = (
    SELECT Category
    FROM Products
    WHERE ProductName = 'Laptop'
); 

-- 4. Find customers who have placed more orders than the customer with CustomerID = 5

SELECT CustomerID, COUNT(OrderID) AS TotalOrders
FROM Orders
GROUP BY CustomerID
HAVING COUNT(OrderID) > (
    SELECT COUNT(OrderID)
    FROM Orders
    WHERE CustomerID = 5
); 

-- 5. Find products that are priced higher than the product with ProductID = 3

SELECT *
FROM Products
WHERE Price > (
    SELECT Price
    FROM Products
    WHERE ProductID = 3
); 

-- 6. Find customers who placed an order on the same date as OrderID = 1

SELECT DISTINCT CustomerID
FROM Orders
WHERE OrderDate = (
    SELECT OrderDate
    FROM Orders
    WHERE OrderID = 1
); 

-- 7. Find the salesperson whose target amount is higher than the average target

SELECT *
FROM Salespersons
WHERE TargetAmount > (
    SELECT AVG(TargetAmount)
    FROM Salespersons
); 

-- 8. Find customers who have ordered any product in the 'Electronics' category

SELECT DISTINCT C.*
FROM Customers C
JOIN Orders O ON C.CustomerID = O.CustomerID
JOIN OrderDetails OD ON O.OrderID = OD.OrderID
WHERE OD.ProductID IN (
    SELECT ProductID
    FROM Products
    WHERE Category = 'Electronics'
);  

CREATE TABLE OrderDetails (
    OrderDetailID INT PRIMARY KEY,
    OrderID INT,
    ProductID INT,
    Quantity INT,
    FOREIGN KEY (OrderID) REFERENCES Orders(OrderID),
    FOREIGN KEY (ProductID) REFERENCES Products(ProductID)
); 

-- 9. Find products that were ordered by customers from Chennai

SELECT DISTINCT P.*
FROM Products P
WHERE P.ProductID IN (
    SELECT OD.ProductID
    FROM OrderDetails OD
    JOIN Orders O ON OD.OrderID = O.OrderID
    JOIN Customers C ON O.CustomerID = C.CustomerID
    WHERE C.City = 'Chennai'
); 

-- 10. Find salespersons who handled orders for customers from Bangalore

SELECT DISTINCT S.*
FROM Salespersons S
WHERE S.SalespersonID IN (
    SELECT O.SalespersonID
    FROM Orders O
    JOIN Customers C ON O.CustomerID = C.CustomerID
    WHERE C.City = 'Bangalore'
);  

-- 11. Find products whose price is greater than ALL products in the Furniture category

SELECT *
FROM Products
WHERE Price > ALL (
    SELECT Price
    FROM Products
    WHERE Category = 'Furniture'
); 

-- 12. Find products whose price is greater than ANY Electronics product

SELECT *
FROM Products
WHERE Price > ANY (
    SELECT Price
    FROM Products
    WHERE Category = 'Electronics'
); 

-- 13. Find customers who purchased products costing more than 10000

SELECT DISTINCT C.*
FROM Customers C
WHERE C.CustomerID IN (
    SELECT O.CustomerID
    FROM Orders O
    JOIN OrderDetails OD ON O.OrderID = OD.OrderID
    JOIN Products P ON OD.ProductID = P.ProductID
    WHERE P.Price > 10000
);  

-- 14. Find customers who have placed at least one order

SELECT *
FROM Customers C
WHERE EXISTS (
    SELECT 1
    FROM Orders O
    WHERE O.CustomerID = C.CustomerID
);  

-- 15. Find customers who have placed more than 2 orders

SELECT *
FROM Customers C
WHERE (
    SELECT COUNT(*)
    FROM Orders O
    WHERE O.CustomerID = C.CustomerID
) > 2; 

-- 16. Find products that have been ordered more than once

SELECT *
FROM Products P
WHERE (
    SELECT COUNT(*)
    FROM OrderDetails OD
    WHERE OD.ProductID = P.ProductID
) > 1; 

-- 17. Find salespersons who have handled more than 3 orders

SELECT *
FROM Salespersons S
WHERE (
    SELECT COUNT(*)
    FROM Orders O
    WHERE O.SalespersonID = S.SalespersonID
) > 3;  

-- 18. Find customers who have purchased products more expensive than 
-- the average product price in that category

SELECT DISTINCT C.*
FROM Customers C
WHERE EXISTS (
    SELECT 1
    FROM Orders O
    JOIN OrderDetails OD ON O.OrderID = OD.OrderID
    JOIN Products P ON OD.ProductID = P.ProductID
    WHERE O.CustomerID = C.CustomerID
    AND P.Price > (
        SELECT AVG(P2.Price)
        FROM Products P2
        WHERE P2.Category = P.Category
    )
); 

-- 19. Find products whose price is greater than the average price of their category

SELECT *
FROM Products P
WHERE Price > (
    SELECT AVG(P2.Price)
    FROM Products P2
    WHERE P2.Category = P.Category
); 

-- 20. Find customers whose total orders are greater than 
-- the average number of orders placed by customers

SELECT *
FROM Customers C
WHERE (
    SELECT COUNT(*)
    FROM Orders O
    WHERE O.CustomerID = C.CustomerID
) > (SELECT AVG(OrderCount)
    FROM (
        SELECT COUNT(*) AS OrderCount
        FROM Orders
        GROUP BY CustomerID
    ) AS AvgOrders
);  

-- 1. Create a CTE to calculate the total order quantity for each customer
-- and display customers with quantity greater than 3

WITH CustomerQuantity AS (
    SELECT O.CustomerID,
           SUM(OD.Quantity) AS TotalQuantity
    FROM Orders O
    JOIN OrderDetails OD
        ON O.OrderID = OD.OrderID
    GROUP BY O.CustomerID
)


SELECT *
FROM CustomerQuantity
WHERE TotalQuantity > 3;  

-- 1. Create a CTE to calculate the total order quantity for each customer
-- and display customers with quantity greater than 3

WITH CustomerQuantity AS (
    SELECT O.CustomerID,
           SUM(OD.Quantity) AS TotalQuantity
    FROM Orders O
    JOIN OrderDetails OD
        ON O.OrderID = OD.OrderID
    GROUP BY O.CustomerID
)
SELECT *
FROM CustomerQuantity
WHERE TotalQuantity > 3; 
