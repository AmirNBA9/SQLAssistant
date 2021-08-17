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
--بررسی تعداد رکوردهای جدول
SELECT COUNT(CustomerID) FROM Customers
SELECT COUNT(CustomerID) FROM Customers2
GO
--مشاهده رکوردهای جدول 
SELECT * FROM Customers2
SELECT * FROM Customers
GO
--بررسی ساختار جدول
SP_HELP Customers
GO
SP_HELP Customers2
GO
--بررسی ایندکس های هر دو جدول
SP_HELPINDEX Customers
GO
SP_HELPINDEX Customers2--این جدول کلاستر ایندکس ندارد و هیپ می باشد
GO
--ايجاد يك كلاستر ايندكس
--کلاستر ایندکس در حقیقت ترتیب فیزیکی رکوردها را مشخص می کند
CREATE CLUSTERED INDEX IX_C ON Customers2(CustomerID)
GO
--رکوردها طبق مراحل معرفی شده در درس مرتب می  گردند
/*
1-تهیه کپی از جدول
2-مرتب شدن رکوردهای موجود در جدول کپی بر اساس کلید ایندکس
3-ایجاد ساختار ایندکس 
4-حذف جدول اصلی و جایگزینی جدول کپی شده با آن
*/
GO
SELECT  * FROM Customers2
GO
IF OBJECT_ID('Customers2', 'U') IS NOT NULL 
	DROP TABLE Customers2
GO
--تهیه کپی از جدول
SELECT CustomerID,City,Country INTO Customers2 FROM Customers
GO
SELECT  * FROM Customers2
GO
SP_HELPINDEX Customers2
GO
SELECT  * FROM Customers2

