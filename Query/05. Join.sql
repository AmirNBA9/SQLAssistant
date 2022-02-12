
SELECT COUNT(*) FROM Categories   -- 8 records
SELECT COUNT(*) FROM Products     --77 records

-- غیر استاندارد
SELECT *
FROM Categories , Products
WHERE Categories.CategoryID = Products.CategoryID 

-- استاندارد
SELECT *
FROM Categories INNER JOIN Products
    ON Categories.CategoryID = Products.CategoryID 

--
SELECT E.EmployeeID , E.LastName , E.Country , E.City ,
       C.CustomerID , C.CompanyName , C.Country , C.City
FROM Employees E CROSS JOIN Customers C
WHERE E.Country = C.Country AND E.City = C.City
ORDER BY C.CustomerID


--
/*

select .....
From Details D	inner Join Master1 M1 on
					D.FK1=M1.PKM1
				inner Join Master2 M2 ON
					D.FK2=M2.PKM2
*/

--
--- Categoreis--->Products<-------Suppliers

Select P.ProductID, p.ProductName,p.UnitsInStock,
		c.CategoryID,c.CategoryName
		,s.SupplierID,s.CompanyName --,s.country
From Products P		inner Join Categories C ON P.CategoryID=c.CategoryID
					inner Join Suppliers S ON p.SupplierID=s.SupplierID
Where s.Country= N'USA'
order by c.CategoryID

--
--- Categoreis--->Products<-------Suppliers

Select	c.CategoryID,c.CategoryName,
		count(p.ProductID) as Pcount, Isnull(sum(p.unitsinstock),0) as TotalStock, String_agg(p.Productname,',') as ProductsNames

from Products P
				inner join Categories C on p.CategoryID=c.CategoryID
				inner join Suppliers S on P.SupplierID=s.SupplierID
Where S.Country=N'USA'
Group by  all c.CategoryID,c.CategoryName

Order by C.CategoryID

--
--   Employees -----> orders <--------Customers

Select	E.EmployeeID,e.LastName,
		count(o.OrderID) as Ocount
From orders O
			inner join Employees E On o.EmployeeID=e.EmployeeID
			inner join Customers C On o.CustomerID=c.CustomerID
Where C.Country='Denmark'
Group by E.EmployeeID,e.LastName
Order by 1

--
USE Northwind

SELECT EmployeeID , LastName , (SELECT COUNT(OrderID) FROM Orders) AS TOC
FROM Employees
ORDER BY 1



SELECT EmployeeID , LastName , (SELECT COUNT(OrderID) FROM Orders WHERE EmployeeID = Employees.EmployeeID) AS OrderCount
FROM Employees
ORDER BY 1


SELECT E.EmployeeID , E.LastName , COUNT(O.OrderID) AS OrderCount , FORMAT(100.0 * COUNT(O.OrderID) / (SELECT COUNT(OrderID) FROM Orders) , '###.#') AS Perc
FROM Employees E LEFT JOIN Orders O
   ON E.EmployeeID = O.EmployeeID
GROUP BY GROUPING SETS ( (E.EmployeeID , E.LastName) , () )

--
CREATE TABLE T1 (ID int NOT NULL PRIMARY KEY , Value int NOT NULL)
CREATE TABLE T2 (ID int NOT NULL PRIMARY KEY , Value int NOT NULL)

INSERT INTO T1
   VALUES (1,10) , (2,15) , (4,12) , (5,20) , (8,40)

INSERT INTO T2
   VALUES (1,14) , (2,11) , (3,17) , (5,20) , (7,30)

SELECT * FROM T1
SELECT * FROM T2


/*
1    14
2    15
3    17
4    12
5    20
7    30
8    40


*/

--

SELECT *
FROM T1 INNER JOIN T2
   ON T1.ID = T2.ID

SELECT *
FROM T1 FULL JOIN T2
   ON T1.ID = T2.ID



--
--SELECT O1.OrderID , O1.OrderDate , O1.CustomerID , 
--       O2.OrderID , O2.OrderDate , O2.CustomerID 
SELECT DISTINCT O1.CustomerID
FROM Orders O1 CROSS JOIN Orders O2
WHERE O1.CustomerID = O2.CustomerID AND DATEDIFF(Day, O1.OrderDate , O2.OrderDate) = 1
ORDER BY O1.CustomerID

--
SELECT DISTINCT P.ProductID , P.ProductName
FROM Products P INNER JOIN [Order Details] OD ON P.ProductID = OD.ProductID
                INNER JOIN Orders O ON O.OrderID = OD.OrderID
WHERE YEAR(O.OrderDate) = 1997 AND MONTH(O.OrderDate) = 9 
ORDER BY P.ProductID
