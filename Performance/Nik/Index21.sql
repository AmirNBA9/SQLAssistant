/*
COLUMNSTORE INDEX بررسي   
*/
USE tempdb
GO
--بررسی وجود جدول 
IF OBJECT_ID('Employees', 'U') IS NOT NULL 
	DROP TABLE Employees
GO
CREATE TABLE Employees
(
	Code INT IDENTITY CONSTRAINT PK_Code PRIMARY KEY,
	FirstName NVARCHAR(50),
	LastName NVARCHAR(80),
	HireDate SMALLDATETIME,
	City NVARCHAR(20)
)
GO
SP_HELPINDEX Employees
GO
INSERT INTO Employees (FirstName,LastName,HireDate,City) VALUES 
	(N'مسعود',N'طاهری','2000-01-01',N'میانه'),
	(N'فرید',N'طاهری','2003-01-01',N'میانه'),
	(N'احمد',N'غفاری','2003-01-01',N'میانه'),
	(N'خدیجه',N'افروزنیا','2000-01-01',N'تهران'),
	(N'مجید',N'طاهری','2005-01-01',N'تهران')
GO
SELECT * FROM Employees
GO
INSERT INTO Employees (FirstName,LastName,HireDate,City) 
	SELECT FirstName,LastName,HireDate,City FROM Employees
GO 10
SELECT * FROM Employees
GO
--------------------------------------------------------
--NONCLUSTERED COLUMNSTORE INDEX OVER CLUSTERED INDEX
CREATE NONCLUSTERED COLUMNSTORE INDEX IX_ColumnStore 
	ON Employees(FirstName,LastName,HireDate)
GO
--NONCLUSTERED INDEX OVER CLUSTERED INDEX
CREATE NONCLUSTERED INDEX IX_NC
	ON Employees(FirstName,LastName,HireDate)
GO
SP_HELPINDEX Employees
GO
--------------------------------------------------------
--اگر کوئری شامل فیلدهای مورد استفاده در کالمن استور ایندکس باشد
--Show Execution Plan
SELECT Code,FirstName,LastName FROM Employees
GO
--Show Execution Plan
SELECT Code,FirstName,LastName FROM Employees
	OPTION (IGNORE_NONCLUSTERED_COLUMNSTORE_INDEX)
--SELECT Code,FirstName,LastName FROM Employees WITH(INDEX(IX_NC))
GO
--------------------------------------------------------
SET STATISTICS IO ON
GO
SELECT Code,FirstName,LastName FROM Employees
GO
SELECT Code,FirstName,LastName FROM Employees
	OPTION (IGNORE_NONCLUSTERED_COLUMNSTORE_INDEX)
GO
SET STATISTICS IO OFF
--------------------------------------------------------