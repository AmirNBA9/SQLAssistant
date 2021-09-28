

/*
WITH <CTE_Name> [(<FieldList>)]
AS ( Select ........... )
SELECT .... FROM <CTE_Name>
*/

USE Northwind;

WITH Sales_CTE 
AS
(
    SELECT EmployeeID , COUNT(OrderID) AS OrderCount
    FROM dbo.Orders
    GROUP BY EmployeeID
)
SELECT * 
From Sales_CTE
ORDER BY EmployeeID 