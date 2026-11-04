CREATE DATABASE OnlineBookStore;

-- Create Books Table
DROP TABLE IF EXISTS Books CASCADE;
CREATE TABLE Books (
	Book_ID SERIAL PRIMARY KEY,
	Title VARCHAR(100),
	Author VARCHAR(100),
	Genre VARCHAR(50),
	Published_Year INT,
	Price NUMERIC(10, 2),
	Stock INT
);

--Create Customers Table
DROP TABLE IF EXISTS Customers CASCADE;
CREATE TABLE Customers (
	Customer_ID SERIAL PRIMARY KEY,
	Name VARCHAR(100),
	Email VARCHAR(100),
	Phone VARCHAR(15),
	City VARCHAR(50),
	Country VARCHAR(150)
);

--Create Orders Table
DROP TABLE IF EXISTS Orders CASCADE;
CREATE TABLE Orders (
	Order_ID SERIAL PRIMARY KEY,
	Customer_ID INT REFERENCES Customers(Customer_ID),
	Book_ID INT REFERENCES Books(Book_ID),
	Order_Date DATE,
	Quantity INT,
	Total_Amount NUMERIC(10, 2)
);

--CSV Data Import
-- Books Data
COPY Books(
	Book_ID, Title, Author, Genre, Published_Year, Price, Stock
)
FROM 'E:\Linkdin\SQL Projects\SQL_Resume_Project-main\Books.csv'
CSV HEADER;

-- Customers Data
COPY Customers(
Customer_ID, Name, Email, Phone, City, Country
)
FROM 'E:\Linkdin\SQL Projects\SQL_Resume_Project-main\Customers.csv'
CSV HEADER;

-- Orders
COPY Orders(
Order_ID, Customer_ID, Book_ID, Order_Date, Quantity, Total_Amount
)
FROM 'E:\Linkdin\SQL Projects\SQL_Resume_Project-main\Orders.csv'
CSV HEADER;

-- Verify Data
SELECT * FROM Books;
SELECT * FROM Customers;
SELECT * FROM Orders;

-- Basic SQL Analysis

-- 1. Fiction Genre of Books
SELECT * FROM Books
WHERE Genre = 'Fiction';

--2. Publish Books after 1950
SELECT * FROM Books
Where Published_Year > 1950;

-- 3. Customers of Canada
SELECT * FROM Customers
WHERE Country = 'Canada';

-- 4. November 2023 Orders
SELECT * FROM ORDERS
WHERE Order_Date BETWEEN '2023-11-01' AND '2023-11-30';

--5. Total Available Stock
SELECT SUM(Stock) AS Total_Stocks FROM Books;

--6. Most Expensive Book
SELECT * FROM Books
ORDER BY Price DESC LIMIT 1;

--7. Orders with Quantity Greater than 1
SELECT * FROM Orders
Where Quantity > 1;

--8. Orders Greater than $20
SELECT * FROM Orders
WHERE Total_Amount > 20;

--9. Available Genre
SELECT DISTINCT Genre FROM Books;

--10. Books with Lowest Stock
SELECT * FROM Books
ORDER BY Stock ASC LIMIT 1;

--11. Total Revenue
SELECT SUM(Total_Amount) AS Revenue FROM Orders;

-- Advanced SQL Analysis

--1. Total Books Sold Per Genre
SELECT b.Genre, SUM(o.Quantity) AS Total_Books_Sold
FROM Orders AS o
JOIN Books as b
ON o.Book_ID = b.Book_ID
GROUP BY b.Genre
ORDER BY Total_Books_Sold DESC;

--2. Average Fantasy Book Price
SELECT AVG(Price) As Average_Price
FROM Books
WHERE Genre = 'Fantasy';

--3. Customers with at least 2 Orders
SELECT o.Customer_ID, c.Name,
COUNT(o.Order_ID) AS Order_Count
FROM Orders AS o
JOIN Customers AS C
ON o.Customer_ID = c.Customer_ID
GROUP BY o.Customer_ID, c.Name
HAVING COUNT(o.Order_ID) >= 2
ORDER BY Order_Count DESC;

--3. Most Frequently Orderd Book
SELECT o.Book_ID, b.Title,
COUNT(o.Order_ID) AS Order_Count
FROM Orders As o
JOIN Books AS b
ON o.Book_ID = b.Book_ID
GROUP BY o.Book_ID, b.Title
ORDER BY Order_Count DESC
LIMIT 1;

--4. Top 3 Most Expensive Fantasy Books
SELECT * FROM Books
WHERE Genre = 'Fantasy'
ORDER BY Price DESC
LIMIT 3;

--5. Total Quantity Sold by each Author
SELECT B.Author,
SUM(o.Quantity) AS Total_Books_Sold
FROM Orders as o
JOIN Books AS b
ON o.Book_ID = b.Book_ID
GROUP BY b.Author
ORDER BY Total_Books_Sold DESC;

--6. Cities of Customers who spent over $30
SELECT DISTINCT c.City, o.Total_Amount
FROM Orders  AS o
JOIN Customers AS c
ON o.Customer_ID = c.Customer_ID
WHERE o.Total_Amount > 30;

--7. Customer Who Spent the most
SELECT c.Customer_ID, c.Name,
SUM(o.Total_Amount) AS Total_Spent
FROM Orders AS o
JOIN Customers AS c
ON o.Customer_ID = c.Customer_ID
GROUP BY c.Customer_ID, c.Name
ORDER BY Total_Spent DESC
LIMIT 1;

--8. Remainig Stock after Orders
SELECT b.Book_ID, b.Title, b.Stock,
COALESCE(SUM(o.Quantity), 0) AS Order_Quantity,
b.Stock - COALESCE(SUM(o.Quantity), 0) AS Remaining_Quantity
FROM Books AS b
LEFT JOIN Orders AS o
ON b.Book_ID = o.Book_ID
GROUP BY b.Book_ID, b.Title, b.Stock
ORDER BY b.Book_ID;