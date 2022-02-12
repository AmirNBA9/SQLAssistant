
SELECT ProductID , ProductName , UnitPrice -- , CategoryID 
FROM Products
ORDER BY CategoryID 

SELECT *
FROM Products
ORDER BY LEFT(ProductName,1)

--

SELECT EmployeeID , YEAR(OrderDate) AS OrderYear , COUNT(OrderID) AS OrderCount
FROM Orders
GROUP BY EmployeeID , YEAR(OrderDate)
--ORDER BY EmployeeID , OrderYear DESC
--ORDER BY CustomerID  خطا
--ORDER BY COUNT(OrderID)
--ORDER BY SUM(Freight)
--ORDER BY 1,2
ORDER BY 3 DESC


--
