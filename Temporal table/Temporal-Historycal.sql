--Step1
CREATE TABLE dbo.Employee
(
    [EmployeeID]		int NOT NULL PRIMARY KEY CLUSTERED
  , [Name]			nvarchar(100) NOT NULL
  , [Position]		varchar(100) NOT NULL
  , [Department]	varchar(100) NOT NULL
  , [Address]		nvarchar(1024) NOT NULL
  , [AnnualSalary]	decimal (10,2) NOT NULL
  , [ValidFrom]		datetime2 GENERATED ALWAYS AS ROW START
  , [ValidTo]		datetime2 GENERATED ALWAYS AS ROW END
  , PERIOD FOR SYSTEM_TIME (ValidFrom, ValidTo)
 )
WITH (SYSTEM_VERSIONING = ON (HISTORY_TABLE = dbo.EmployeeHistory));


Select * from dbo.Employee

--Step 2
insert into dbo.Employee (
 [EmployeeID]	
,[Name]			
,[Position]		
,[Department]	
,[Address]		
,[AnnualSalary]		
)
Values (3,'Name','Pos','DEp','Add',2)

Update dbo.Employee set Name='AMIR' where EmployeeID=1

--Step3
SELECT * FROM Employee
  FOR SYSTEM_TIME
    BETWEEN '2014-01-01 00:00:00.0000000' AND '2021-01-01 00:00:00.0000000'
      WHERE EmployeeID = 1 ORDER BY ValidFrom;