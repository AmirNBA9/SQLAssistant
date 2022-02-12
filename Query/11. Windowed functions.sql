-- Ranking Functions (Windowed Functions) --
/*

ROW_NUMBER()   OVER ([PARTITION BY <Exp List>] ORDER BY <Exp List>) 
RANK() 
DENSE_RANK()
NTILE(<n>)

--
SELECT * , ROW_NUMBER() OVER (ORDER BY ProductName) AS Radif
FROM Products
--ORDER BY ProductID

SELECT ProductID , ProductName , UnitPrice , RANK()       OVER (ORDER BY UnitPrice DESC) AS PriceRank ,
                                             DENSE_RANK() OVER (ORDER BY UnitPrice DESC) AS DensePriceRank ,
											 NTILE(10)     OVER (ORDER BY UnitPrice DESC) AS NT
FROM Products


--

SELECT *
FROM Products
ORDER BY ProductID
OFFSET 10 ROWS FETCH NEXT 5 ROWS ONLY;

--

SELECT E.EmployeeID , E.LastName , COUNT(O.OrderID) AS OrderCount ,
       RANK() OVER (ORDER BY  COUNT(O.OrderID) DESC) AS SaleRank
FROM Employees E INNER JOIN Orders O
   ON E.EmployeeID = O.EmployeeID
GROUP BY E.EmployeeID , E.LastName
ORDER BY E.LastName

--
WITH T
AS
(
SELECT CategoryID , ProductID , ProductName , UnitPrice , RANK() OVER (PARTITION BY CategoryID ORDER BY UnitPrice DESC) AS PriceRank
FROM Products
)
SELECT *
FROM T
WHERE PriceRank = 1


--
USE Northwind;

WITH T
AS
(
SELECT C.Country , P.ProductName , SUM(OD.Quantity) AS TotalQuantity ,
       RANK() OVER (PARTITION BY C.Country ORDER BY  SUM(OD.Quantity) DESC) AS SaleRank
FROM Customers C INNER JOIN Orders O ON C.CustomerID = O.CustomerID
                 INNER JOIN [Order Details] OD ON O.OrderID = OD.OrderID
				 INNER JOIN Products P ON P.ProductID = OD.ProductID
GROUP BY C.Country , P.ProductName
)
SELECT * 
FROM T
WHERE SaleRank = 1


--
WITH T
AS
(
SELECT        MONTH(Orders.OrderDate) AS OrderMonth, Customers.CustomerID, Customers.CompanyName, SUM([Order Details].UnitPrice * [Order Details].Quantity) AS TotalPurchase ,
              RANK() OVER (PARTITION BY  MONTH(Orders.OrderDate) ORDER BY SUM([Order Details].UnitPrice * [Order Details].Quantity) DESC) AS PurchaseRank
FROM            Customers INNER JOIN
                         Orders ON Customers.CustomerID = Orders.CustomerID INNER JOIN
                         [Order Details] ON Orders.OrderID = [Order Details].OrderID
WHERE YEAR(Orders.OrderDate) = 1997
GROUP BY MONTH(Orders.OrderDate), Customers.CustomerID, Customers.CompanyName
)
SELECT *
FROM T
WHERE PurchaseRank = 1

--
-- OVER --

SELECT ProductID , ProductName , UnitPrice , (SELECT SUM(UnitPrice) FROM Products WHERE ProductID <= P.ProductID) AS cumulativeSum
FROM Products P
ORDER BY ProductID


SELECT ProductID , ProductName , UnitPrice , SUM(UnitPrice) OVER (ORDER BY ProductID ASC) AS cumulativeSum
FROM Products 


---------------------------------------------------------------------------------------------------------------

SELECT CategoryID , ProductID , ProductName , UnitPrice , (SELECT SUM(UnitPrice) FROM Products WHERE CategoryID = P.CategoryID AND ProductID <= P.ProductID) AS cumulativeSum
FROM Products P
ORDER BY CategoryID , ProductID


SELECT CategoryID , ProductID , ProductName , UnitPrice , SUM(UnitPrice) OVER (PARTITION BY CategoryID ORDER BY ProductID ASC) AS cumulativeSum
FROM Products 


--
