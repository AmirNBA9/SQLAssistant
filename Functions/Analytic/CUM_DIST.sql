/*
This function calculates the cumulative distribution of a value within a group of values.
*/

--Syntax
CUME_DIST( )  
    OVER ( [ partition_by_clause ] order_by_clause )

--Example 1: CUME_DIST returns a value that represents the percent of employees with a salary less than or equal to the current employee in the same department.
USE AdventureWorks2012;  
GO  
SELECT Department, LastName, Rate,   
       CUME_DIST () OVER (PARTITION BY Department ORDER BY Rate) AS CumeDist,   
       PERCENT_RANK() OVER (PARTITION BY Department ORDER BY Rate ) AS PctRank  
FROM HumanResources.vEmployeeDepartmentHistory AS edh  
    INNER JOIN HumanResources.EmployeePayHistory AS e    
    ON e.BusinessEntityID = edh.BusinessEntityID  
WHERE Department IN (N'Information Services',N'Document Control')   
ORDER BY Department, Rate DESC;