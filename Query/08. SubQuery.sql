
SELECT CategoryID , CategoryName , (SELECT TOP 1 CONVERT(nvarchar(5),ProductID) + ' ' +  ProductName + ' ' + CONVERT(nvarchar(10) , UnitPrice)
                                    FROM Products
									WHERE CategoryID = C.CategoryID
									ORDER BY UnitPrice DESC
                                   ) AS MostExpensiveProduct
FROM Categories C


--
SELECT CategoryID , CategoryName , (SELECT TOP 1 ProductID 
                                    FROM Products
									WHERE CategoryID = C.CategoryID
									ORDER BY UnitPrice DESC
                                   ) AS ProductID ,
								   
								   (SELECT TOP 1 ProductName
                                    FROM Products
									WHERE CategoryID = C.CategoryID
									ORDER BY UnitPrice DESC
                                   ) AS ProductName ,

                                   (SELECT TOP 1 UnitPrice 
                                    FROM Products
									WHERE CategoryID = C.CategoryID
									ORDER BY UnitPrice DESC
                                   ) AS UnitPrice

FROM Categories C


--

SELECT EmployeeID , LastName , (SELECT COUNT(OrderID) FROM Orders WHERE EmployeeID = E.EmployeeID AND YEAR(OrderDate) = 1996) AS [1996] ,
                               (SELECT COUNT(OrderID) FROM Orders WHERE EmployeeID = E.EmployeeID AND YEAR(OrderDate) = 1997) AS [1997] ,
                               (SELECT COUNT(OrderID) FROM Orders WHERE EmployeeID = E.EmployeeID AND YEAR(OrderDate) = 1998) AS [1998] ,
                               (SELECT COUNT(OrderID) FROM Orders WHERE EmployeeID = E.EmployeeID AND YEAR(OrderDate) IN (1996,1997,1998) ) AS [Total] 

FROM Employees E
ORDER BY 1

--


SELECT *
FROM Products
WHERE UnitPrice = (SELECT MAX(UnitPrice) FROM Products)

SELECT *
FROM Products
WHERE UnitPrice > (SELECT AVG(UnitPrice) FROM Products)


SELECT *
FROM Products P
WHERE UnitPrice > (SELECT AVG(UnitPrice) FROM Products WHERE CategoryID = P.CategoryID)
ORDER BY ProductID

SELECT AVG(UnitPrice) FROM Products WHERE CategoryID = 2


--
SELECT *
FROM Products P
WHERE UnitPrice > (SELECT AVG(UnitPrice) FROM Products WHERE CategoryID = P.CategoryID)
ORDER BY ProductID;
-----------------------------------------------------------------------------------------------------------
WITH T
AS
(SELECT CategoryID , AVG(UnitPrice) AS AvgPrice
 FROM Products
 GROUP BY CategoryID
)
SELECT P.*
FROM Products P INNER JOIN T
   ON P.CategoryID = T.CategoryID
WHERE P.UnitPrice > T.AvgPrice
ORDER BY P.ProductID


--

SELECT C.CategoryID , C.CategoryName , P.ProductID , P.ProductName , P.UnitPrice
FROM Categories C INNER JOIN Products P
   ON C.CategoryID = P.CategoryID
WHERE UnitPrice = (SELECT MAX(UnitPrice) FROM Products WHERE CategoryID= C.CategoryID)
ORDER BY C.CategoryID

--

-- Customers ---------> Orders ----------> [Order Details]
WITH T
AS
(
SELECT C.Country , C.CustomerID , C.CompanyName , SUM(OD.Quantity*OD.UnitPrice) AS TotalPurchase
FROM Customers C INNER JOIN Orders O ON C.CustomerID = O.CustomerID
                 INNER JOIN [Order Details] OD ON o.OrderID = OD.OrderID
GROUP BY C.Country , C.CustomerID , C.CompanyName
)
SELECT *
FROM T
WHERE TotalPurchase = (SELECT MAX(TotalPurchase) FROM T AS T2 WHERE T2.Country = T.Country)
ORDER BY Country


--
WITH T
AS
(
SELECT YEAR(O.OrderDate) AS OrderYear , E.EmployeeID , E.LastName , SUM(OD.Quantity*OD.UnitPrice) AS TotalSale
FROM Employees E INNER JOIN Orders O INNER JOIN [Order Details] OD
     ON O.OrderID = OD.OrderID
	 ON E.EmployeeID = O.EmployeeID
GROUP BY YEAR(O.OrderDate), E.EmployeeID , E.LastName
)
SELECT *
FROM T
WHERE TotalSale = (SELECT MAX(TotalSale) FROM T AS T2 WHERE T2.OrderYear = T.OrderYear)
ORDER BY OrderYear

--


-- Join , Having
SELECT C.CategoryID , C.CategoryName , MIN(P.UnitPrice) AS MinPrice
FROM Categories C INNER JOIN Products P
   ON C.CategoryID = P.CategoryID
GROUP BY C.CategoryID , C.CategoryName 
HAVING MIN(P.UnitPrice) > 8.00

-- Type I:
SELECT CategoryID , CategoryName
FROM Categories C
WHERE (SELECT MIN(UnitPrice) FROM Products WHERE CategoryID = C.CategoryID) > 8.00


-- Type II (ALL):
SELECT CategoryID , CategoryName
FROM Categories C
WHERE 8.00 < ALL (SELECT UnitPrice FROM Products WHERE CategoryID = C.CategoryID)


--
SELECT *
FROM Employees E
WHERE 'Denmark' = ALL (SELECT C.Country
                        FROM Customers C INNER JOIN Orders O
						    ON C.CustomerID = O.CustomerID
                        WHERE O.EmployeeID = E.EmployeeID
                       )

SELECT C.Country
                        FROM Customers C INNER JOIN Orders O
						    ON C.CustomerID = O.CustomerID
                        WHERE O.EmployeeID = 5


SELECT CategoryID , CategoryName
FROM Categories C
WHERE 80.00 < ANY (SELECT UnitPrice FROM Products WHERE CategoryID = C.CategoryID)

SELECT UnitPrice FROM Products WHERE CategoryID = 2


--
SELECT *
FROM Employees E
WHERE 'Denmark' = ANY (SELECT C.Country
                        FROM Customers C INNER JOIN Orders O
						    ON C.CustomerID = O.CustomerID
                        WHERE O.EmployeeID = E.EmployeeID
                       )


--

SELECT *
FROM Employees E
WHERE EXISTS (SELECT * FROM Customers C INNER JOIN Orders O
                  ON C.CustomerID = O.CustomerID
              WHERE O.EmployeeID = E.EmployeeID AND C.Country = 'Denmark')

SELECT *
FROM Employees E
WHERE NOT EXISTS (SELECT * FROM Customers C INNER JOIN Orders O
                    ON C.CustomerID = O.CustomerID
                  WHERE O.EmployeeID = E.EmployeeID AND C.Country = 'Denmark')

SELECT *
FROM Customers C
WHERE NOT EXISTS (SELECT * FROM Orders WHERE CustomerID = C.CustomerID)

--

SELECT *
FROM Categories
WHERE CategoryID IN (SELECT CategoryID FROM Products WHERE UnitPrice > 80)

--

SELECT *
FROM Employees
WHERE EmployeeID IN (SELECT DISTINCT O.EmployeeID
                     FROM Orders O INNER JOIN Customers C
					      ON O.CustomerID = C.CustomerID
                     WHERE C.Country = 'Denmark'
                    )

--

SELECT *
FROM Customers
WHERE CustomerID NOT IN (SELECT DISTINCT CustomerID FROM Orders)

--
