USE master
GO
IF DB_ID('TestDB')>0
BEGIN
	ALTER DATABASE TestDB SET SINGLE_USER WITH ROLLBACK IMMEDIATE
	DROP DATABASE TestDB
END
GO
CREATE DATABASE TestDB
GO
--------------------------------------------------------------------
--Employees بررسی جهت وجود جدول 
DROP TABLE IF EXISTS Employees
GO
--Employees ایجاد جدول
--شده توجه کنید Encrypt به فیلد 
CREATE TABLE Employees
(
	EmployeeID INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
	FirstName NVARCHAR(50),
	LastName NVARCHAR(50),
	CardNo NVARCHAR(50) COLLATE  Latin1_General_BIN2  ENCRYPTED WITH
	--CardNo NVARCHAR(50) COLLATE  PERSIAN_100_BIN2  ENCRYPTED WITH
	(
		ENCRYPTION_TYPE = Deterministic,
		ALGORITHM='AEAD_AES_256_CBC_HMAC_SHA_256', 
		COLUMN_ENCRYPTION_KEY=MYCEK
	)
)
GO
--------------------------------------------------------------------
--ایجاد پروسیجر
DROP PROCEDURE IF EXISTS usp_GellAllEmployees
DROP PROCEDURE IF EXISTS usp_GellEmployeesByLastName
DROP PROCEDURE IF EXISTS usp_GellEmployeesByCardNo
DROP PROCEDURE IF EXISTS usp_InsertEmployee
GO
CREATE PROCEDURE usp_GellAllEmployees 
AS
	SELECT 
		EmployeeID,
		FirstName,
		LastName,
		CardNo
	FROM Employees 	
GO
CREATE PROCEDURE usp_GellEmployeesByLastName (@LastName NVARCHAR(50))
AS
	SELECT 
		EmployeeID,
		FirstName,
		LastName,
		CardNo
	FROM Employees
	WHERE LastName=@LastName
GO
CREATE PROCEDURE usp_GellEmployeesByCardNo (@CardNo NVARCHAR(50))
AS
	SELECT 
		EmployeeID,
		FirstName,
		LastName,
		CardNo
	FROM Employees
	WHERE CardNo=@CardNo 
GO
CREATE PROCEDURE usp_InsertEmployee 
	(@FirstName NVARCHAR(50),@LastName NVARCHAR(50),@CardNo NVARCHAR(50))
AS
	INSERT INTO Employees (FirstName,LastName,CardNo)
		VALUES (@FirstName,@LastName,@CardNo)
GO
EXEC usp_InsertEmployee @FirstName='A',@LastName='B',@CardNo=N'123'
--------------------------------------------------------------------
GO
USE TestDB
GO
SELECT * FROM Employees
--Column Encryption Setting=Enabled