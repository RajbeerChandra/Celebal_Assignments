-- 1. List of all customers
SELECT * FROM Customer; -- Output: All columns for all customers

-- 2. List of all customers where company name ending in N
SELECT * FROM Customer WHERE CompanyName LIKE '%N'; -- Output: Customers with company names ending in 'N'

-- 3. List of all customers who live in Berlin or London
SELECT * FROM Customer WHERE City IN ('Berlin', 'London'); -- Output: Customers living in Berlin or London

-- 4. List of all customers who live in UK or USA
SELECT * FROM Customer WHERE Country IN ('UK', 'USA'); -- Output: Customers living in UK or USA

-- 5. List of all products sorted by product name
SELECT * FROM Product ORDER BY ProductName; -- Output: All products sorted by name

-- 6. List of all products where product name starts with an A
SELECT * FROM Product WHERE ProductName LIKE 'A%'; -- Output: Products with names starting with 'A'

-- 7. List of customers who ever placed an order
SELECT DISTINCT C.* FROM Customer C JOIN Orders O ON C.CustomerID = O.CustomerID; -- Output: Customers who placed orders

-- 8. List of customers who live in London and have bought chai
SELECT DISTINCT C.* FROM Customer C JOIN Orders O ON C.CustomerID = O.CustomerID JOIN OrderDetails OD ON O.OrderID = OD.OrderID JOIN Product P ON OD.ProductID = P.ProductID WHERE C.City = 'London' AND P.ProductName = 'Chai'; -- Output: Customers in London who bought Chai

-- 9. List of customers who never place an order
SELECT C.* FROM Customer C LEFT JOIN Orders O ON C.CustomerID = O.CustomerID WHERE O.CustomerID IS NULL; -- Output: Customers who never placed orders

-- 10. List of customers who ordered Tofu
SELECT DISTINCT C.* FROM Customer C JOIN Orders O ON C.CustomerID = O.CustomerID JOIN OrderDetails OD ON O.OrderID = OD.OrderID JOIN Product P ON OD.ProductID = P.ProductID WHERE P.ProductName = 'Tofu'; -- Output: Customers who ordered Tofu

-- 11. Details of first order of the system
SELECT TOP 1 * FROM Orders ORDER BY OrderDate ASC; -- Output: Details of the first order

-- 12. Find the details of most expensive order date
SELECT TOP 1 O.*, SUM(OD.UnitPrice * OD.Quantity) AS TotalOrderPrice FROM Orders O JOIN OrderDetails OD ON O.OrderID = OD.OrderID GROUP BY O.OrderID, O.OrderDate ORDER BY TotalOrderPrice DESC; -- Output: Details of the most expensive order

-- 13. For each order get the OrderID and Average quantity of items in that order
SELECT O.OrderID, AVG(OD.Quantity) AS AverageQuantity FROM Orders O JOIN OrderDetails OD ON O.OrderID = OD.OrderID GROUP BY O.OrderID; -- Output: OrderID and average quantity per order

-- 14. For each order get the orderID, minimum quantity and maximum quantity for that order
SELECT O.OrderID, MIN(OD.Quantity) AS MinQuantity, MAX(OD.Quantity) AS MaxQuantity FROM Orders O JOIN OrderDetails OD ON O.OrderID = OD.OrderID GROUP BY O.OrderID; -- Output: OrderID, min and max quantity per order

-- 15. Get a list of all managers and total number of employees who report to them
SELECT M.ManagerID, COUNT(E.EmployeeID) AS NumberOfEmployees FROM Employees E JOIN Employees M ON E.ManagerID = M.EmployeeID GROUP BY M.ManagerID; -- Output: ManagerID and number of employees reporting

-- 16. Get the OrderID and the total quantity for each order that has a total quantity of greater than 300
SELECT O.OrderID, SUM(OD.Quantity) AS TotalQuantity FROM Orders O JOIN OrderDetails OD ON O.OrderID = OD.OrderID GROUP BY O.OrderID HAVING SUM(OD.Quantity) > 300; -- Output: OrderID and total quantity for orders > 300

-- 17. List of all orders placed on or after 1996/12/31
SELECT * FROM Orders WHERE OrderDate >= '1996-12-31'; -- Output: Orders placed on or after 1996-12-31

-- 18. List of all orders shipped to Canada
SELECT * FROM Orders WHERE ShipCountry = 'Canada'; -- Output: Orders shipped to Canada

-- 19. List of all orders with order total > 200
SELECT O.OrderID, SUM(OD.UnitPrice * OD.Quantity) AS OrderTotal FROM Orders O JOIN OrderDetails OD ON O.OrderID = OD.OrderID GROUP BY O.OrderID HAVING SUM(OD.UnitPrice * OD.Quantity) > 200; -- Output: OrderID and order total > 200

-- 20. List of countries and sales made in each country
SELECT ShipCountry, SUM(OD.UnitPrice * OD.Quantity) AS TotalSales FROM Orders O JOIN OrderDetails OD ON O.OrderID = OD.OrderID GROUP BY ShipCountry; -- Output: Countries and total sales

-- 21. List of Customer ContactName and number of orders they placed
SELECT C.ContactName, COUNT(O.OrderID) AS NumberOfOrders FROM Customer C JOIN Orders O ON C.CustomerID = O.CustomerID GROUP BY C.ContactName; -- Output: Customer contact names and order count

-- 22. List of customer contact names who have placed more than 3 orders
SELECT C.ContactName FROM Customer C JOIN Orders O ON C.CustomerID = O.CustomerID GROUP BY C.ContactName HAVING COUNT(O.OrderID) > 3; -- Output: Customer contact names with > 3 orders

-- 23. List of discontinued products which were ordered between 1/1/1997 and 1/1/1998
SELECT DISTINCT P.ProductName FROM Product P JOIN OrderDetails OD ON P.ProductID = OD.ProductID JOIN Orders O ON OD.OrderID = O.OrderID WHERE P.Discontinued = 1 AND O.OrderDate BETWEEN '1997-01-01' AND '1998-01-01'; -- Output: Discontinued products ordered in 1997

-- 24. List of employee firstname, lastName, supervisor FirstName, LastName
SELECT E.FirstName, E.LastName, S.FirstName AS SupervisorFirstName, S.LastName AS SupervisorLastName FROM Employees E LEFT JOIN Employees S ON E.SupervisorID = S.EmployeeID; -- Output: Employee names and their supervisors

-- 25. List of Employees id and total sales conducted by employee
SELECT E.EmployeeID, SUM(OD.UnitPrice * OD.Quantity) AS TotalSales FROM Employees E JOIN Orders O ON E.EmployeeID = O.EmployeeID JOIN OrderDetails OD ON O.OrderID = OD.OrderID GROUP BY E.EmployeeID; -- Output: EmployeeID and total sales

-- 26. List of employees whose FirstName contains character 'a'
SELECT * FROM Employees WHERE FirstName LIKE '%a%'; -- Output: Employees with 'a' in first name

-- 27. List of managers who have more than four people reporting to them
SELECT M.EmployeeID, M.FirstName, M.LastName, COUNT(E.EmployeeID) AS NumberOfReports FROM Employees E JOIN Employees M ON E.SupervisorID = M.EmployeeID GROUP BY M.EmployeeID, M.FirstName, M.LastName HAVING COUNT(E.EmployeeID) > 4; -- Output: Managers with > 4 reports

-- 28. List of Orders and ProductNames
SELECT O.OrderID, P.ProductName FROM Orders O JOIN OrderDetails OD ON O.OrderID = OD.OrderID JOIN Product P ON OD.ProductID = P.ProductID; -- Output: Orders and product names

-- 29. List of orders placed by the best customer
WITH BestCustomer AS (
    SELECT TOP 1 CustomerID, COUNT(OrderID) AS NumberOfOrders
    FROM Orders
    GROUP BY CustomerID
    ORDER BY NumberOfOrders DESC
)
SELECT O.*
FROM Orders O
JOIN BestCustomer BC ON O.CustomerID = BC.CustomerID; -- Output: Orders by top customer

-- 30. List of orders placed by customers who do not have a Fax number
SELECT O.*
FROM Orders O
JOIN Customer C ON O.CustomerID = C.CustomerID
WHERE C.Fax IS NULL;
-- Output: Orders by customers without a fax


-- 31. List of Postal codes where the product Tofu was shipped
SELECT DISTINCT O.ShipPostalCode FROM Orders O JOIN OrderDetails OD ON O.OrderID = OD.OrderID JOIN Product P ON OD.ProductID = P.ProductID WHERE P.ProductName = 'Tofu'; -- Output: Postal codes where Tofu was shipped

-- 32. List of product names that were shipped to France
SELECT DISTINCT P.ProductName FROM Product P JOIN OrderDetails OD ON P.ProductID = OD.ProductID JOIN Orders O ON OD.OrderID = O.OrderID WHERE O.ShipCountry = 'France'; -- Output: Product names shipped to France

-- 33. List of ProductNames and Categories for the supplier 'Specialty Biscuits, Ltd.'
SELECT P.ProductName, C.CategoryName FROM Product P JOIN Category C ON P.CategoryID = C.CategoryID JOIN Supplier S ON P.SupplierID = S.SupplierID WHERE S.CompanyName = 'Specialty Biscuits, Ltd.'; -- Output: Product names and categories from Specialty Biscuits, Ltd.

-- 34. List of products that were never ordered
SELECT P.ProductName FROM Product P LEFT JOIN OrderDetails OD ON P.ProductID = OD.ProductID WHERE OD.ProductID IS NULL; -- Output: Products never ordered

-- 35. List of products where units in stock is less than 10 and units on order are 0
SELECT P.ProductName FROM Product P WHERE P.UnitsInStock < 10 AND P.UnitsOnOrder = 0; -- Output: Products with low stock and no orders

-- 36. List of top 10 countries by sales
SELECT TOP 10 O.ShipCountry, SUM(OD.UnitPrice * OD.Quantity) AS TotalSales
FROM Orders O
JOIN OrderDetails OD ON O.OrderID = OD.OrderID
GROUP BY O.ShipCountry
ORDER BY TotalSales DESC;
-- Output: Top 10 countries by sales


-- 37. Number of orders each employee has taken for customers with CustomerIDs between A and AO
SELECT E.EmployeeID, COUNT(O.OrderID) AS NumberOfOrders
FROM Employees E
JOIN Orders O ON E.EmployeeID = O.EmployeeID
JOIN Customer C ON O.CustomerID = C.CustomerID
WHERE C.CustomerID BETWEEN 'A' AND 'AO'
GROUP BY E.EmployeeID;
-- Output: Orders by employees for specific customers


-- 38. Order date of most expensive order
SELECT TOP 1 O.OrderDate FROM Orders O JOIN OrderDetails OD ON O.OrderID = OD.OrderID GROUP BY O.OrderID, O.OrderDate ORDER BY SUM(OD.UnitPrice * OD.Quantity) DESC; -- Output: Order date of the most expensive order

-- 39. Product name and total revenue from that product
SELECT P.ProductName, SUM(OD.UnitPrice * OD.Quantity) AS TotalRevenue FROM Product P JOIN OrderDetails OD ON P.ProductID = OD.ProductID GROUP BY P.ProductName; -- Output: Product names and total revenue

-- 40. Supplier ID and number of products offered
SELECT S.SupplierID, COUNT(P.ProductID) AS NumberOfProducts FROM Supplier S JOIN Product P ON S.SupplierID = P.SupplierID GROUP BY S.SupplierID; -- Output: Supplier IDs and number of products offered

-- 41. Top ten customers based on their business
SELECT TOP 10 C.CustomerID, C.ContactName, SUM(OD.UnitPrice * OD.Quantity) AS TotalSpent
FROM Customer C
JOIN Orders O ON C.CustomerID = O.CustomerID
JOIN OrderDetails OD ON O.OrderID = OD.OrderID
GROUP BY C.CustomerID, C.ContactName
ORDER BY TotalSpent DESC;
-- Output: Top 10 customers by spending


-- 42. What is the total revenue of the company
SELECT SUM(OD.UnitPrice * OD.Quantity) AS TotalRevenue
FROM OrderDetails OD;
-- Output: Total revenue of the company

