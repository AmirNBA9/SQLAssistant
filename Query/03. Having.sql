-- HAVING --

SELECT EmployeeID , COUNT(OrderID) AS OrderCount
FROM Orders
WHERE YEAR(OrderDate) = 1997 
GROUP BY EmployeeID
HAVING COUNT(OrderID) > 50

--

SELECT OrderID , SUM(Quantity*UnitPrice) AS OrderPrice
FROM [Order Details]
--WHERE OrderID > 10500
GROUP BY OrderID
HAVING SUM(Quantity*UnitPrice) > 10000  AND OrderID > 10500
ORDER BY OrderPrice DESC


--
