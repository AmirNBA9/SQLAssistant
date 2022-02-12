-- PIVOT --
WITH T
AS
(SELECT E.EmployeeID , E.LastName , YEAR(O.OrderDate) AS OrderYear , O.OrderID
 FROM Employees E INNER JOIN Orders O
    ON E.EmployeeID = O.EmployeeID
)
SELECT * , [1996] + [1997] + [1998] AS Total
FROM T
PIVOT (COUNT(OrderID) FOR OrderYear IN ([1996] , [1997] , [1998]) ) AS myPivot
ORDER BY EmployeeID

--
WITH T
AS
(
SELECT        Employees.EmployeeID, Employees.LastName, Customers.Country, [Order Details].UnitPrice * [Order Details].Quantity AS LinePrice
FROM            Customers INNER JOIN
                         Orders ON Customers.CustomerID = Orders.CustomerID INNER JOIN
                         Employees ON Orders.EmployeeID = Employees.EmployeeID INNER JOIN
                         [Order Details] ON Orders.OrderID = [Order Details].OrderID
)
SELECT * , [USA] + [UK] + [Germany]+ [France] AS Total
FROM T
PIVOT (SUM(LinePrice) FOR Country IN ([USA] , [UK] , [Germany] , [France]) ) AS myPivot
ORDER BY EmployeeID

--
