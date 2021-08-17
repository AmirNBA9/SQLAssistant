--ايجاد كلاستر ايندكس
USE Northwind
GO
--بررسی وجود جدول 
IF OBJECT_ID('Customers2', 'U') IS NOT NULL 
	DROP TABLE Customers2
GO
--تهیه کپی از جدول
SELECT CustomerID,City,Country INTO Customers2 FROM Customers
GO
SELECT * FROM Customers2
GO
SP_HELPINDEX Customers2
GO
--ايجاد يك كلاستر ايندكس
CREATE CLUSTERED INDEX IX_C ON Customers2(CustomerID)
GO
SET STATISTICS IO ON
GO
DBCC DROPCLEANBUFFERS--خالی کردن محتوای حافظه تخصیص داده شده به ازای صفحات
GO
--Logical Read بررسی تعداد
SELECT * FROM Customers2 WHERE
	 CustomerID BETWEEN 'COMMI' AND 'FALKO'
GO
SET STATISTICS IO OFF
GO