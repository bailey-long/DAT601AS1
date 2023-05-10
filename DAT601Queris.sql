USE Assign1_SQL_23;
go

--1 List all product names in alphebeticl order
SELECT ProductName 
FROM Product 
ORDER BY ProductName ASC;
--2 List the productID, name and price of all products in price and alphabetical name order
SELECT ProductID, ProductName, ProductPrice
FROM Product
ORDER BY ProductPrice, ProductName;
--3 List the product ID, name and price of all products from the highest to lowest price and in alphabetical name order
SELECT ProductID, ProductName, ProductPrice
FROM Product
ORDER BY ProductPrice DESC, ProductName;
--4 List the products that cost $3.49
SELECT *
FROM Product
WHERE ProductPrice = 3.49;
--5 List all products that cost less than $10.00
SELECT *
FROM Product
WHERE ProductPrice < 10.00;
--6 List all products not made by vendor DLL01
SELECT *
FROM Product
WHERE VendorID <> 'DLL01';
--7 List all the products with a price between $5.00 and $10.00
SELECT *
FROM Product
WHERE ProductPrice BETWEEN 5.00 AND 10.00;
--8 List any products made by either vendor DLL01 or vendor BRS01 costing $10.00 or greater
SELECT *
FROM Product
WHERE VendorID IN ('DLL01', 'BRS01') AND ProductPrice >= 10.00;
--9 return the average price of all the products in the products table
SELECT AVG(ProductPrice)
FROM Product;
--10 return the total number of customers in the customer table
SELECT COUNT(*)
FROM Customer;
--11 Return the number of customers in the customers table with an e-mail address
SELECT COUNT(*)
FROM Customer
WHERE CustEmail IS NOT NULL;
--12 Return the number of product types, minimum, maximum and average product price from the products table
SELECT COUNT(DISTINCT ProductID) AS NumProducts,
       MIN(ProductPrice) AS MinPrice,
       MAX(ProductPrice) AS MaxPrice,
       AVG(ProductPrice) AS AvgPrice
FROM Product;
--13 Return the vendor name, product price and product name from the vendors and product tables
SELECT v.VendorName, p.ProductPrice, p.ProductName
FROM Vendor v
INNER JOIN Product p ON v.VendorID = p.VendorID;
--14 Return the product name, vendor name, product price and quantity for each item in order number 20007
SELECT p.ProductName, v.VendorName, oi.ItemPrice, oi.Quantity
FROM OrderItem oi
INNER JOIN Product p ON oi.ProductID = p.ProductID
INNER JOIN Vendor v ON p.VendorID = v.VendorID
WHERE oi.OrderID = 20007;
--15 create a list of all the customers (customer name and customer contact) who orderd item RGAN01
SELECT c.CustName, c.CustContact
FROM Customer c
INNER JOIN OrderEntry o ON c.CustID = o.CustID
INNER JOIN OrderItem i ON o.OrderID = i.OrderID
WHERE i.ProductID = 'RGAN01';
--16 Display the total number of orders placed by every customer in the customers table, as well as the city the customer is in
SELECT c.CustName, c.CustCity, COUNT(oe.OrderID) AS NumOrders
FROM Customer c
LEFT JOIN OrderEntry oe ON c.CustID = oe.CustID
GROUP BY c.CustName, c.CustCity;
--17 create a report on all the customers in Nelson and Wellington. You should also inclue all Fun4All locations, regardless of city. The resulting customers
-- should be in alphabetical order of customer name then customer contact
SELECT CustName, CustContact, CustAddress, CustCity
FROM Customer
WHERE CustCity IN ('Nelson', 'Wellington') OR CustName LIKE '%Fun4All%'
ORDER BY CustName, CustContact
--18 create a view vProductCustomer which join the Customer, Order and OrderItem tables to return a list of all customers who have ordered ay product
-- Then retrieve from that view a list of acustomers who ordered product RGAN01
CREATE VIEW vProductCustomer AS
SELECT DISTINCT c.CustID, c.CustName, c.CustAddress, c.CustCity, c.CustContact, c.CustPhone, c.CustEmail
FROM Customer c
INNER JOIN OrderEntry oe ON c.CustID = oe.CustID
INNER JOIN OrderItem oi ON oe.OrderID = oi.OrderID;

SELECT DISTINCT CustName, CustContact
FROM vProductCustomer
WHERE CustID IN (
	SELECT DISTINCT c.CustID
	FROM Customer c
	JOIN OrderEntry oe ON c.CustID = oe.CustID
	JOIN OrderItem oi ON oe.OrderID = oi.OrderID
	JOIN Product p ON oi.ProductID = p.ProductID
	WHERE p.ProductID = 'RGAN01'
);
--19 add a customer to the database and other stuff