USE Sales_Analytics;

-- 11. Create a CTE to find customers whose total purchase amount
-- is greater than the average purchase amount of all customers

WITH CustomerPurchase AS (
    SELECT O.CustomerID,
           SUM(P.Price * OD.Quantity) AS TotalPurchase
    FROM Orders O
    JOIN OrderDetails OD
        ON O.OrderID = OD.OrderID
    JOIN Products P
        ON OD.ProductID = P.ProductID
    GROUP BY O.CustomerID
)
SELECT *
FROM CustomerPurchase
WHERE TotalPurchase > (
    SELECT AVG(TotalPurchase)
    FROM CustomerPurchase
);  

-- 12. Create a CTE to calculate category-wise total sales amount

WITH CategorySales AS (
    SELECT P.Category,
           SUM(P.Price * OD.Quantity) AS TotalSales
    FROM Products P
    JOIN OrderDetails OD
        ON P.ProductID = OD.ProductID
    GROUP BY P.Category
)
SELECT *
FROM CategorySales; 

-- 13. Create a CTE to find products whose price is higher than
-- the average price of their category

WITH CategoryAverage AS (
    SELECT Category,
           AVG(Price) AS AvgPrice
    FROM Products
    GROUP BY Category
)
SELECT P.*
FROM Products P
JOIN CategoryAverage C
    ON P.Category = C.Category
WHERE P.Price > C.AvgPrice; 

-- 14. Create a CTE to display salesperson ranking
-- based on total sales amount

WITH SalesTotals AS (
    SELECT O.SalespersonID,
           SUM(P.Price * OD.Quantity) AS TotalSales
    FROM Orders O
    JOIN OrderDetails OD
        ON O.OrderID = OD.OrderID
    JOIN Products P
        ON OD.ProductID = P.ProductID
    GROUP BY O.SalespersonID
)
SELECT *,
       RANK() OVER (ORDER BY TotalSales DESC) AS SalesRank
FROM SalesTotals;  

-- 15. Create a CTE to find customers who purchased
-- more than one different product

WITH CustomerProducts AS (
    SELECT O.CustomerID,
           COUNT(DISTINCT OD.ProductID) AS ProductCount
    FROM Orders O
    JOIN OrderDetails OD
        ON O.OrderID = OD.OrderID
    GROUP BY O.CustomerID
)
SELECT *
FROM CustomerProducts
WHERE ProductCount > 1; 

-- 1. Display each order with the total number of orders
-- placed by that customer using a window function

SELECT OrderID,
       CustomerID,
       COUNT(OrderID) OVER (
           PARTITION BY CustomerID
       ) AS TotalOrders
FROM Orders;  

-- 2. Show each product with its price
-- and the average price of all products

SELECT ProductID,
       ProductName,
       Price,
       AVG(Price) OVER () AS AveragePrice
FROM Products; 

-- 3. Rank all products based on price
-- from highest to lowest

SELECT ProductID,
       ProductName,
       Price,
       RANK() OVER (
           ORDER BY Price DESC
       ) AS PriceRank
FROM Products; 

-- 4. Display each order with the total quantity
-- ordered by that salesperson

SELECT O.OrderID,
       O.SalespersonID,
       SUM(OD.Quantity) OVER (
           PARTITION BY O.SalespersonID
       ) AS TotalQuantity
FROM Orders O
JOIN OrderDetails OD
    ON O.OrderID = OD.OrderID;  
    
    -- 5. Rank salespersons based on the total sales amount generated

SELECT O.SalespersonID,
       SUM(P.Price * OD.Quantity) AS TotalSales,
       RANK() OVER (
           ORDER BY SUM(P.Price * OD.Quantity) DESC
       ) AS SalesRank
FROM Orders O
JOIN OrderDetails OD
    ON O.OrderID = OD.OrderID
JOIN Products P
    ON OD.ProductID = P.ProductID
GROUP BY O.SalespersonID;  

-- 5. Rank salespersons based on the total sales amount generated

SELECT O.SalespersonID,
       SUM(P.Price * OD.Quantity) AS TotalSales,
       RANK() OVER (
           ORDER BY SUM(P.Price * OD.Quantity) DESC
       ) AS SalesRank
FROM Orders O
JOIN OrderDetails OD
    ON O.OrderID = OD.OrderID
JOIN Products P
    ON OD.ProductID = P.ProductID
GROUP BY O.SalespersonID; 

-- 7. Display the previous order date for each customer
-- using LAG()

SELECT CustomerID,
       OrderID,
       OrderDate,
       LAG(OrderDate) OVER (
           PARTITION BY CustomerID
           ORDER BY OrderDate
       ) AS PreviousOrderDate
FROM Orders; 

-- 8. Display the next order date for each customer
-- using LEAD()

SELECT CustomerID,
       OrderID,
       OrderDate,
       LEAD(OrderDate) OVER (
           PARTITION BY CustomerID
           ORDER BY OrderDate
       ) AS NextOrderDate
FROM Orders;  
-- 9. Calculate the running total of sales amount by order date

SELECT O.OrderDate,
       SUM(P.Price * OD.Quantity) AS DailySales,
       SUM(SUM(P.Price * OD.Quantity)) OVER (
           ORDER BY O.OrderDate
       ) AS RunningTotal
FROM Orders O
JOIN OrderDetails OD
    ON O.OrderID = OD.OrderID
JOIN Products P
    ON OD.ProductID = P.ProductID
GROUP BY O.OrderDate;  

-- 10. Display the top 3 most expensive products
-- using DENSE_RANK()

SELECT *
FROM (
    SELECT ProductID,
           ProductName,
           Price,
           DENSE_RANK() OVER (
               ORDER BY Price DESC
           ) AS PriceRank
    FROM Products
) RankedProducts
WHERE PriceRank <= 3;
