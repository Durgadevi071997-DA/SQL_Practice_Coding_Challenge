create database online_bookstore;
use online_bookstore;

create table books (
    BookID INTEGER  auto_increment primary key,
    Title VARCHAR(100) NOT NULL,
    Author VARCHAR(50) NOT NULL,
    ISBN VARCHAR(20) UNIQUE,
    Price DECIMAL(8,2) CHECK (Price > 0)
);

CREATE TABLE Orders (
    OrderID INTEGER PRIMARY KEY,
    BookID INTEGER,
    OrderDate DATE NOT NULL,
    Quantity INTEGER CHECK (Quantity > 0),
    FOREIGN KEY (BookID) REFERENCES Books(BookID)
); 

ALTER TABLE Books
ADD CONSTRAINT unique_isbn UNIQUE (ISBN);

insert into  books ( BookID, Title, Author, ISBN, Price)values
(1, 'SQL Basics', 'John Smith', 'ISBN001', 500.00),
(2, 'Data Analytics', 'Mary Jane', 'ISBN002', 650.50),
(3, 'Python Programming', 'David Lee', 'ISBN003', 700.00),
(4, 'Database Design', 'Chris Martin', 'ISBN004', 550.75),
(5, 'Machine Learning', 'Andrew Ng', 'ISBN005', 800.00);

select* from Books; 

UPDATE Books
SET Price = 750.00
WHERE BookID = 3;

DELETE FROM Orders
WHERE OrderID = 2; 

INSERT INTO Orders (OrderID, BookID, OrderDate, Quantity) VALUES
(1, 1, '2024-01-10', 2),
(2, 2, '2024-01-12', 1),
(3, 3, '2024-01-15', 3),
(4, 4, '2024-01-18', 2),
(5, 5, '2024-01-20', 1); 

select* from Orders; 


TRUNCATE TABLE Orders;