USE HR

SELECT * FROM Employees

-----------------------------------------------------------------------
DROP TABLE IF EXISTS NewEmployees ;

CREATE TABLE NewEmployees
(
  EmployeeID int NOT NULL PRIMARY KEY,
  EmpName Nvarchar(50) ,
  Title Nvarchar(50),
  ManagerID int, 
  OrgNode HierarchyID NOT NULL UNIQUE ,
  OrgNodeText AS OrgNode.ToString() PERSISTED ,
  OrgLevel AS OrgNode.GetLevel() PERSISTED
);
GO

-- Create a temporary table named #Children with a column named Seq that will contain  
-- the sequence of children for each node:


IF OBJECT_ID('TempDB..#Children','U') IS NOT NULL
    DROP TABLE #Children ;


CREATE TABLE #Children 
   (
    EmployeeID int,
    ManagerID int,
    Seq int
)
GO  

-- Add an index that will significantly speed up the query that populates the NewOrg table:
CREATE CLUSTERED INDEX tmpind ON #Children(ManagerID, EmployeeID)

GO

INSERT INTO #Children (EmployeeID, ManagerID, Seq)
    SELECT EmployeeID, ManagerID, ROW_NUMBER() OVER (PARTITION BY ManagerID ORDER BY EmployeeID) 
    FROM Employees
GO 

SELECT * FROM #Children ORDER BY ManagerID, Seq

GO
--------------------------------------------------------------------------------------------------
WITH Emp(OrgNode, EmployeeID) 
AS
(
SELECT HierarchyID::GetRoot() , EmployeeID 
FROM #Children  
WHERE ManagerID IS NULL 

UNION ALL 

SELECT CAST( E.OrgNode.ToString() + CAST(C.Seq AS varchar(30)) + '/'  AS HierarchyID), C.EmployeeID
FROM #Children AS C INNER JOIN Emp AS E
      ON C.ManagerID = E.EmployeeID 
)
INSERT INTO NewEmployees (OrgNode, EmployeeID, ManagerID,Title)
SELECT Emp.OrgNode, Employees.EmployeeID, Employees.ManagerID, Employees.Title
FROM Employees INNER JOIN Emp
   ON Employees.EmployeeID = Emp.EmployeeID
GO

DROP TABLE #Children
GO
----------------------------------------------------------------------------------------------------
SELECT *
FROM NewEmployees
ORDER BY OrgNode
GO


