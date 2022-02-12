-- Union
-- Combining Select results --

SELECT Country FROM Customers
UNION
SELECT Country FROM Suppliers

SELECT Country FROM Customers
UNION ALL
SELECT Country FROM Suppliers

SELECT Country FROM Customers
INTERSECT
SELECT Country FROM Suppliers

SELECT Country FROM Customers
EXCEPT
SELECT Country FROM Suppliers

SELECT Country FROM Suppliers
EXCEPT
SELECT Country FROM Customers


-- Union and union all
SELECT  SubjectCode, SubjectName, MarksObtained
  FROM  Marksheet1
UNION
SELECT  CourseCode, CourseName, MarksObtained
  FROM  Marksheet2;

/*
Note: The output for union of the three tables will also be same as union on Marksheet1 and Marksheet2 because
union operation does not take duplicate values.
*/
SELECT  SubjectCode, SubjectName, MarksObtained
  FROM  Marksheet1
UNION
SELECT  CourseCode, CourseName, MarksObtained
  FROM  Marksheet2
UNION
SELECT  SubjectCode, SubjectName, MarksObtained
  FROM  Marksheet3;


-- Union all
/*
CREATE VIEW V_AllOrders
AS
SELECT * , 1 AS BranchID        FROM Shiraz.dbo.Orders
UNION ALL
SELECT * , 2 AS BranchID        FROM Ahwaz.dbo.Orders
UNION ALL
SELECT * , 3 AS BranchID         FROM Isfahan.dbo.Orders
..
..
...

GO

CREATE VIEW V_AllOrderDetails
AS
SELECT *, 1 AS BranchID          FROM Shiraz.dbo.OrderDetails
UNION ALL
SELECT *, 2 AS BranchID          FROM Ahwaz.dbo.OrderDetails
UNION ALL
SELECT *, 3 AS BranchID          FROM Isfahan.dbo.OrderDetails
..
..
...
GO

SELECT *
FROM V_AllOrders O INNER JOIN V_AllOrderDetails OD
   ON O.OrderID = OD.OrderID AND O.BranchID = OD.BranchID


/**/
CREATE VIEW V_AllParties
AS
SELECT CONVERT(nvarchar(5),EmployeeID) AS ID , LastName AS [Name] , Country , 'E' AS Origin
FROM Employees

UNION

SELECT CustomerID , CompanyName , Country , 'C'
FROM Customers

UNION

SELECT CAST(SupplierID AS nvarchar(5)) , CompanyName , Country , 'S'
FROM Suppliers

GO


SELECT Country , Origin , COUNT(ID) AS [Count]
FROM V_AllParties
GROUP BY Country , Origin
ORDER BY 1,2

GO


WITH T
AS
(SELECT Country , Origin , ID 
 FROM V_AllParties
)
SELECT Country , C AS Customers , S AS Suppliers , E AS Employees , C+S+E AS Total
FROM T
PIVOT (COUNT(ID) FOR Origin IN ([C] , [S] , [E])) AS myPivot
ORDER BY Country


--

