--IO,Execution Time , Execution Plane بررسی 
--مربوط به کوئری ها زمانی که کلاسترایندکس داریم
USE Northwind
GO
--بررسی وجود جدول 
IF OBJECT_ID('Orders2', 'U') IS NOT NULL 
	DROP TABLE Orders2
GO
--تهیه کپی از جدول
SELECT * INTO Orders2 FROM Orders
GO
--بررسی تعداد رکوردهای جدول
SELECT COUNT(OrderID) FROM Orders
SELECT COUNT(OrderID) FROM Orders2
GO
--بررسی ایندکس های هر دو جدول
SP_HELPINDEX Orders
GO
SP_HELPINDEX Orders2--این جدول کلاستر ایندکس ندارد و هیپ می باشد
GO
------------------------------------------------------------
--IO مشاهده آمار
DBCC DROPCLEANBUFFERS --خالی کردن حافظه تخصیص داده شده به صفحات داده
GO
SET STATISTICS IO ON --فعال کردن آمار مربوط به دیسک
GO
--اگر تعداد رکوردهای بازگشتی کم باشد
SELECT * FROM Orders  WHERE OrderID=10918 --جدول دارای کلاستر ایندکس
GO
DBCC DROPCLEANBUFFERS --خالی کردن حافظه تخصیص داده شده به صفحات داده
GO
SELECT * FROM Orders2 WHERE OrderID=10918 -- جدول فاقد کلاستر ایندکس* جدول از نوع هیپ
GO
DBCC DROPCLEANBUFFERS --خالی کردن حافظه تخصیص داده شده به صفحات داده
GO
--اگر تعداد رکوردهای بازگشتی زیاد باشد
SELECT * FROM Orders 
GO
DBCC DROPCLEANBUFFERS --خالی کردن حافظه تخصیص داده شده به صفحات داده
GO
SELECT * FROM Orders2
GO 
SET STATISTICS IO OFF --غیر فعال کردن آمار مربوط به دیسک
------------------------------------------------------------
--Execution Time مشاهده آمار
DBCC DROPCLEANBUFFERS --خالی کردن حافظه تخصیص داده شده به صفحات داده
GO
SET STATISTICS TIME ON --فعال کردن آمار مربوط به زمان اجرا
GO
SELECT * FROM Orders  WHERE OrderID=10918 --جدول دارای کلاستر ایندکس
GO
DBCC DROPCLEANBUFFERS --خالی کردن حافظه تخصیص داده شده به صفحات داده
GO
SELECT * FROM Orders2 WHERE OrderID=10918 -- جدول فاقد کلاستر ایندکس* جدول از نوع هیپ
GO
SET STATISTICS TIME OFF --غیر فعال کردن آمار مربوط به زمان اجرا
GO
------------------------------------------------------------
DBCC DROPCLEANBUFFERS --خالی کردن حافظه تخصیص داده شده به صفحات داده
GO
--مقایسه پلن اجرایی دو جدول
SELECT * FROM Orders  WHERE OrderID=10918 --جدول دارای کلاستر ایندکس
SELECT * FROM Orders2 WHERE OrderID=10918 -- جدول فاقد کلاستر ایندکس* جدول از نوع هیپ
GO