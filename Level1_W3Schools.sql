-- =====================================================================
-- LEVEL 1 - W3SCHOOLS SQL EXERCISES  (tables: Customers, Products, Orders, Suppliers)
-- Format:  Q = question, A = answer
-- =====================================================================

-- ======================= SQL SELECT =======================
-- Q1. Get all columns from the Customers table.
SELECT * FROM Customers;
-- Q2. Select only the City column from Customers.
SELECT City FROM Customers;
-- Q3. Select all the different (unique) values of the Country column.
SELECT DISTINCT Country FROM Customers;
-- Q4. Select CustomerName and City from Customers.
SELECT CustomerName, City FROM Customers;
-- Q5. Count how many distinct countries there are.
SELECT COUNT(DISTINCT Country) FROM Customers;

-- ======================= SQL WHERE =======================
-- Q1. All records where City is 'Berlin'.
SELECT * FROM Customers WHERE City = 'Berlin';
-- Q2. All records where City is NOT 'Berlin'.
SELECT * FROM Customers WHERE NOT City = 'Berlin';
-- Q3. All records where CustomerID is 32.
SELECT * FROM Customers WHERE CustomerID = 32;
-- Q4. City is 'Berlin' AND PostalCode is 12209.
SELECT * FROM Customers WHERE City = 'Berlin' AND PostalCode = 12209;
-- Q5. City is 'Berlin' OR 'London'.
SELECT * FROM Customers WHERE City = 'Berlin' OR City = 'London';

-- ======================= SQL ORDER BY =======================
-- Q1. Sort Customers alphabetically by City.
SELECT * FROM Customers ORDER BY City;
-- Q2. Sort Customers by City in descending order.
SELECT * FROM Customers ORDER BY City DESC;
-- Q3. Sort Customers by Country, then by City.
SELECT * FROM Customers ORDER BY Country, City;
-- Q4. Sort by Country ascending and City descending.
SELECT * FROM Customers ORDER BY Country ASC, City DESC;
-- Q5. Sort Products by Price, highest first.
SELECT * FROM Products ORDER BY Price DESC;

-- ======================= SQL INSERT =======================
-- Q1. Insert a new record in Customers (all listed columns).
INSERT INTO Customers (CustomerName, Address, City, PostalCode, Country)
VALUES ('Hekkan Burger', 'Gateveien 15', 'Sandnes', '4306', 'Norway');
-- Q2. Insert a record giving only CustomerName, City and Country.
INSERT INTO Customers (CustomerName, City, Country)
VALUES ('Hekkan Burger', 'Sandnes', 'Norway');
-- Q3. Insert a record without naming columns (values for every column, in order).
INSERT INTO Customers
VALUES (92, 'Hekkan Burger', 'Hekkan', 'Gateveien 15', 'Sandnes', '4306', 'Norway');
-- Q4. Insert several rows in a single statement.
INSERT INTO Customers (CustomerName, City, Country)
VALUES ('Cardinal', 'Stavanger', 'Norway'),
       ('Greasy Burger', 'Oslo', 'Norway');
-- Q5. Copy rows from Suppliers into Customers.
INSERT INTO Customers (CustomerName, City, Country)
SELECT SupplierName, City, Country FROM Suppliers;

-- ======================= SQL NULL =======================
-- Q1. Select records where PostalCode is NULL.
SELECT * FROM Customers WHERE PostalCode IS NULL;
-- Q2. Select records where PostalCode is NOT NULL.
SELECT * FROM Customers WHERE PostalCode IS NOT NULL;
-- Q3. Show 'Unknown' wherever Address is NULL.
SELECT CustomerName, COALESCE(Address, 'Unknown') AS Address FROM Customers;
-- Q4. Count customers with no PostalCode.
SELECT COUNT(*) FROM Customers WHERE PostalCode IS NULL;
-- Q5. Select customers where Country is NULL or empty.
SELECT * FROM Customers WHERE Country IS NULL OR Country = '';

-- ======================= SQL UPDATE =======================
-- Q1. Set City to 'Oslo' for ALL records.
UPDATE Customers SET City = 'Oslo';
-- Q2. Set City to 'Oslo' only where Country is 'Norway'.
UPDATE Customers SET City = 'Oslo' WHERE Country = 'Norway';
-- Q3. Set City = 'Oslo' and Country = 'Norway' where CustomerID is 32.
UPDATE Customers SET City = 'Oslo', Country = 'Norway' WHERE CustomerID = 32;
-- Q4. Increase every product price by 10%.
UPDATE Products SET Price = Price * 1.10;
-- Q5. Fill missing PostalCode with '00000'.
UPDATE Customers SET PostalCode = '00000' WHERE PostalCode IS NULL;

-- ======================= SQL DELETE =======================
-- Q1. Delete all customers from Norway.
DELETE FROM Customers WHERE Country = 'Norway';
-- Q2. Delete ALL records from Customers (table stays).
DELETE FROM Customers;
-- Q3. Delete the customer with CustomerID 32.
DELETE FROM Customers WHERE CustomerID = 32;
-- Q4. Delete customers whose City is 'Berlin'.
DELETE FROM Customers WHERE City = 'Berlin';
-- Q5. Remove the whole table including its structure.
DROP TABLE Customers;

-- ======================= SQL FUNCTIONS =======================
-- Q1. Smallest price in Products.
SELECT MIN(Price) FROM Products;
-- Q2. Largest price in Products.
SELECT MAX(Price) FROM Products;
-- Q3. Number of products whose price is 18.
SELECT COUNT(*) FROM Products WHERE Price = 18;
-- Q4. Average price of all products.
SELECT AVG(Price) FROM Products;
-- Q5. Sum of all product prices.
SELECT SUM(Price) FROM Products;

-- ======================= SQL LIKE =======================
-- Q1. City starts with 's'.
SELECT * FROM Customers WHERE City LIKE 's%';
-- Q2. City ends with 's'.
SELECT * FROM Customers WHERE City LIKE '%s';
-- Q3. City contains 's'.
SELECT * FROM Customers WHERE City LIKE '%s%';
-- Q4. City starts with 'a' and is exactly 5 characters long.
SELECT * FROM Customers WHERE City LIKE 'a____';
-- Q5. City does NOT start with 'a'.
SELECT * FROM Customers WHERE City NOT LIKE 'a%';

-- ======================= SQL WILDCARDS =======================
-- Q1. City starts with 'a'.
SELECT * FROM Customers WHERE City LIKE 'a%';
-- Q2. City ends with 'a'.
SELECT * FROM Customers WHERE City LIKE '%a';
-- Q3. City contains 'a'.
SELECT * FROM Customers WHERE City LIKE '%a%';
-- Q4. City starts with 'a' and ends with 'b'.
SELECT * FROM Customers WHERE City LIKE 'a%b';
-- Q5. City starts with a letter from a to c (MySQL: use REGEXP; SQL Server: [a-c]%).
SELECT * FROM Customers WHERE City REGEXP '^[a-c]';

-- ======================= SQL IN =======================
-- Q1. City is 'Paris' or 'London'.
SELECT * FROM Customers WHERE City IN ('Paris', 'London');
-- Q2. City is NOT 'Paris' or 'London'.
SELECT * FROM Customers WHERE City NOT IN ('Paris', 'London');
-- Q3. Customers whose Country appears in Suppliers.
SELECT * FROM Customers WHERE Country IN (SELECT Country FROM Suppliers);
-- Q4. Customers whose Country does NOT appear in Suppliers.
SELECT * FROM Customers WHERE Country NOT IN (SELECT Country FROM Suppliers);
-- Q5. Products in categories 1, 2 or 3.
SELECT * FROM Products WHERE CategoryID IN (1, 2, 3);

-- ======================= SQL BETWEEN =======================
-- Q1. Products priced between 10 and 20.
SELECT * FROM Products WHERE Price BETWEEN 10 AND 20;
-- Q2. Products NOT priced between 10 and 20.
SELECT * FROM Products WHERE Price NOT BETWEEN 10 AND 20;
-- Q3. Products whose name is alphabetically between 'Geitost' and 'Pavlova'.
SELECT * FROM Products WHERE ProductName BETWEEN 'Geitost' AND 'Pavlova';
-- Q4. Orders placed between two dates.
SELECT * FROM Orders WHERE OrderDate BETWEEN '1996-07-01' AND '1996-07-31';
-- Q5. Price between 10 and 20 AND CategoryID not in 1,2,3.
SELECT * FROM Products WHERE Price BETWEEN 10 AND 20 AND CategoryID NOT IN (1, 2, 3);

-- ======================= SQL ALIAS =======================
-- Q1. Show CustomerID as ID.
SELECT CustomerID AS ID FROM Customers;
-- Q2. Show PostalCode as Pno.
SELECT CustomerName, Address, PostalCode AS Pno FROM Customers;
-- Q3. Give the Customers table the alias 'Consumers'.
SELECT * FROM Customers AS Consumers;
-- Q4. Combine Address, PostalCode, City, Country into one column called Address_Full.
SELECT CustomerName, CONCAT(Address, ', ', PostalCode, ', ', City, ', ', Country) AS Address_Full FROM Customers;
-- Q5. Use table aliases in a join.
SELECT o.OrderID, c.CustomerName FROM Customers AS c JOIN Orders AS o ON c.CustomerID = o.CustomerID;

-- ======================= SQL JOIN =======================
-- Q1. Orders with matching customer info (every order).
SELECT * FROM Orders LEFT JOIN Customers ON Orders.CustomerID = Customers.CustomerID;
-- Q2. Only orders that have a matching customer.
SELECT * FROM Orders INNER JOIN Customers ON Orders.CustomerID = Customers.CustomerID;
-- Q3. All customers, and their orders if any.
SELECT * FROM Orders RIGHT JOIN Customers ON Orders.CustomerID = Customers.CustomerID;
-- Q4. Customers who have never placed an order.
SELECT c.* FROM Customers c LEFT JOIN Orders o ON c.CustomerID = o.CustomerID WHERE o.OrderID IS NULL;
-- Q5. All rows from both tables (full outer join, MySQL style).
SELECT * FROM Customers c LEFT JOIN Orders o ON c.CustomerID = o.CustomerID
UNION
SELECT * FROM Customers c RIGHT JOIN Orders o ON c.CustomerID = o.CustomerID;

-- ======================= SQL GROUP BY =======================
-- Q1. Number of customers in each country.
SELECT COUNT(CustomerID), Country FROM Customers GROUP BY Country;
-- Q2. Same, highest count first.
SELECT COUNT(CustomerID), Country FROM Customers GROUP BY Country ORDER BY COUNT(CustomerID) DESC;
-- Q3. Only countries with more than 5 customers.
SELECT COUNT(*), Country FROM Customers GROUP BY Country HAVING COUNT(*) > 5;
-- Q4. Average product price per category.
SELECT CategoryID, AVG(Price) FROM Products GROUP BY CategoryID;
-- Q5. Number of orders per customer.
SELECT CustomerID, COUNT(OrderID) AS Orders FROM Orders GROUP BY CustomerID;

-- ======================= SQL DATABASE =======================
-- Q1. Create a database called testDB.
CREATE DATABASE testDB;
-- Q2. Delete the database testDB.
DROP DATABASE testDB;
-- Q3. Create a table Persons.
CREATE TABLE Persons (PersonID int, LastName varchar(255), FirstName varchar(255), Address varchar(255), City varchar(255));
-- Q4. Add a column Age (integer) to Persons.
ALTER TABLE Persons ADD Age int;
-- Q5. Delete all data in Persons but keep the table.
TRUNCATE TABLE Persons;
-- Q6. Delete the Persons table completely.
DROP TABLE Persons;
