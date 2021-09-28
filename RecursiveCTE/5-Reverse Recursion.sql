USE HR;
GO

WITH DirectReports ( EmployeeID, Title , ManagerID ,OrgLevel)
AS
(
-- Anchor member definition
    SELECT EmployeeID, Title , ManagerID ,  0 AS OrgLevel
    FROM Employees
    WHERE EmployeeID = 10
    
    UNION ALL -- ALL is necessary
    
-- Recursive member definition
    SELECT E.EmployeeID, E.Title , E.ManagerID, DR.OrgLevel -1
    FROM Employees AS E INNER JOIN DirectReports AS DR
        ON E.EmployeeID = DR.ManagerID
)

-- Statement that executes the CTE
SELECT *
FROM DirectReports
--WHERE OrgLevel = 2
ORDER BY OrgLevel




