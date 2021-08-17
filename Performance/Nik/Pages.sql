/*1*/
USE MASTER;
GO
CREATE DATABASE RecordAnatomy;
GO 
USE RecordAnatomy;
GO
SELECT * FROM sys.sysfiles
SP_HELPFILE
GO
CREATE TABLE Example
(
	FirstName VARCHAR(100), 
	LastName VARCHAR(100), 
	Age INT
);
GO
INSERT INTO Example VALUES ('Masoud', 'Taheri', 29);
INSERT INTO Example VALUES ('Farid', 'Taheri', 28);
GO
SELECT * FROM Example 
GO
/*And we can use DBCC IND again to find the page to look at: 
PageFID : Data FileID
PagePID : Page ID
*/
DBCC IND ('RecordAnatomy', 'Example', 1);
GO 
DBCC TRACEON (3604)
DBCC PAGE ('RecordAnatomy', 1, 77, 3);
GO 
------------------------------
--بررسی جزئی در مورد ساختار لاگ فایل
USE RecordAnatomy
GO
DBCC LOG('RecordAnatomy')--مشاهده محتوای لاگ فایل
GO
ALTER DATABASE RecordAnatomy SET RECOVERY SIMPLE --تغییر نحوه رفتار لاگ فایل هنگام ذخیره اطلاعات به چه صورتی باشد
GO
CHECKPOINT --صفحات داده های آن در حافظه یافته به دیسک منتقل می شود 
GO
CREATE TABLE T1
(
	F1 INT
)
GO
DBCC LOG('RecordAnatomy')--مشاهده محتوای لاگ فایل
GO
CHECKPOINT --صفحات داده های آن در حافظه یافته به دیسک منتقل می شود 
GO
DBCC LOG('RecordAnatomy')--مشاهده محتوای لاگ فایل
GO
INSERT INTO T1 VALUES (1)
GO
DBCC LOG('RecordAnatomy')--مشاهده محتوای لاگ فایل
GO
select * from t1


/*2*/
USE Northwind
GO
SELECT * FROM Orders
GO
SELECT * FROM [Order Details]
GO
SELECT * FROM Products
GO
SELECT * FROM Employees
GO
SELECT * FROM Customers

/*3*/

USE Northwind
GO
--IOفعال سازي آمار
--مفاهيم زير شرح داده شود
--Phisical Read
--Logical Read
--Read Ahead 
SET STATISTICS IO ON
GO
--تعداد صفحات واکشی شده بررسی گردد
SELECT * FROM Orders
GO
--خالی کردن محتوای حافظه تخصیص داده شده به ازای صفحات
DBCC DROPCLEANBUFFERS
GO
--تعداد صفحات واکشی شده بررسی گردد
SELECT OrderID,OrderDate FROM Orders
GO
SET STATISTICS IO OFF
GO
--خالی کردن محتوای حافظه تخصیص داده شده به ازای صفحات
DBCC DROPCLEANBUFFERS
GO
---------------------------
--فعال سازی آمار زمان اجرا
SET STATISTICS TIME ON
--تعداد صفحات واکشی شده بررسی گردد
SELECT * FROM Orders
GO
--خالی کردن محتوای حافظه تخصیص داده شده به ازای صفحات
DBCC DROPCLEANBUFFERS
GO
--تعداد صفحات واکشی شده بررسی گردد
SELECT OrderID,OrderDate FROM Orders
GO
SET STATISTICS TIME OFF
GO
---------------------------------
--Execution Plane مشاهده 
--نقشه اجرایی در واقع نحوه اجرا شدن یک کوئری را مشخص می کند
--به این موضوع اصطلاحا ترتیب اجرای فیزیکی کوئری می گویند
GO
--Execution Plane بررسی 
SELECT * FROM Orders
GO
--Execution Plane بررسی انواع
SELECT * FROM Orders
GO
--Execution Plane بررسی نحوه خواندن
SELECT * FROM Orders
	INNER JOIN [Order Details] ON Orders.OrderID=[Order Details].OrderID
GO