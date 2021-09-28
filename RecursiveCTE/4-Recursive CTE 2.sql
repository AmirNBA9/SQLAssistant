USE HR;
GO

WITH DirectReports ( EmployeeID, Title , ManagerID ,OrgLevel , Heirarchy )
AS
(
-- Anchor member definition
    SELECT EmployeeID, Title , ManagerID ,  0  , CONVERT(nvarchar(MAX) , EmployeeID )  -- IMPORTANT: Only MAX is accepted
    FROM Employees
    WHERE ManagerID IS NULL
    
    UNION ALL -- ALL is necessary
    
-- Recursive member definition
    SELECT E.EmployeeID, E.Title , E.ManagerID, 
           DR.OrgLevel + 1 , 
           CONVERT(nvarchar(6) , E.EmployeeID) + '->' + DR.Heirarchy 
    FROM Employees AS E INNER JOIN DirectReports AS DR
        ON E.ManagerID = DR.EmployeeID
)
-- Statement that executes the CTE

SELECT *
FROM DirectReports
ORDER BY EmployeeID


