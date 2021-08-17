--ایندکس NONCLUSTERED ایجاد   
--بر روی یک هیپ
USE Northwind
GO
--بررسی وجود جدول 
IF OBJECT_ID('Customers2', 'U') IS NOT NULL 
	DROP TABLE Customers2
GO
--تهیه کپی از جدول
SELECT * INTO Customers2 FROM Customers
GO
--جدول از نوع هیپ است
SP_HELPINDEX Customers2 
GO
--ايجاد يك نان کلاستر ايندكس
--NonClustered Index Over Heap
CREATE NONCLUSTERED INDEX IX_NC ON Customers2(Country)
GO
--آیا فرایند بوک مارک لوکاپ اتفاق افتاده است
SELECT Country FROM Customers2 
	WHERE Country IN ('Sweden' ,'Spain')
GO
--آیا فرایند بوک مارک لوکاپ اتفاق افتاده است
--عدم استفاده از ایندکس
SELECT CustomerID,Country,City FROM Customers2 
	WHERE Country IN ('Sweden' ,'Spain')
GO
--اجبار به استفاده از ایندکس
--آیا فرایند بوک مارک لوکاپ اتفاق افتاده است
SELECT CustomerID,Country,City FROM Customers2 WITH (INDEX(IX_NC))
	WHERE Country IN ('Sweden' ,'Spain')
GO
/*
هارد ديسك از سطح برگ به سطح داده جهت استخراج ستون هاي مورد نياز خود مراجعه مي كند
اين عمليات براي كوئري هايي كه تعداد ركوردهاي بازگشتي آن زياد است هزينه بر مي باشد
*/
------------------------------------------------------------------------------------------
--ایندکس NONCLUSTERED ایجاد   
--بر روی یک جدول از نوع هیپ
USE Northwind
GO
--بررسی وجود جدول 
IF OBJECT_ID('Orders2', 'U') IS NOT NULL 
	DROP TABLE Orders2
GO
--تهیه کپی از جدول
SELECT * INTO Orders2 FROM Orders
GO
--جدول از نوع هیپ است
SP_HELPINDEX Orders2 
GO
--ايجاد يك نان کلاستر ايندكس
--NonClustered Index Over Heap
CREATE NONCLUSTERED INDEX IX_NC ON Orders2(OrderID)
GO
--جدول از نوع هیپ است چون کلاستر ایندکس ندارد
SP_HELPINDEX Orders2 
GO
--آیا فرایند بوک مارک لوکاپ اتفاق افتاده است
SELECT OrderID FROM Orders2 
	WHERE OrderID BETWEEN 10268 AND 10278
GO
--آیا فرایند بوک مارک لوکاپ اتفاق افتاده است
--عدم استفاده از ایندکس
SELECT OrderID,CustomerID,OrderDate FROM Orders2 
	WHERE OrderID BETWEEN 10268 AND 10278
GO
--اجبار به استفاده از ایندکس
--آیا فرایند بوک مارک لوکاپ اتفاق افتاده است
SELECT OrderID,CustomerID,OrderDate FROM Orders2  WITH (INDEX(IX_NC)) 
	 WHERE OrderID BETWEEN 10268 AND 10278
GO
--آیا فرایند بوک مارک لوکاپ اتفاق افتاده است
SELECT OrderID,CustomerID,OrderDate FROM Orders2  WITH (INDEX(IX_NC)) 
	 WHERE OrderID = 10268 
-------------------
--IO بررسی تعداد
SET STATISTICS IO ON
GO
SELECT OrderID,CustomerID,OrderDate FROM Orders2  WITH (INDEX(IX_NC)) 
	 WHERE OrderID = 10268 
GO
SELECT OrderID,CustomerID,OrderDate FROM Orders2  WITH (INDEX(IX_NC)) 
	 WHERE OrderID BETWEEN 10268 AND 10278
GO
SET STATISTICS IO OFF
-------------------
--این دو کوئری را با هم مقایسه کنید
SELECT OrderID,CustomerID,OrderDate FROM Orders2  WITH (INDEX(IX_NC)) --استفاده از نان کلاستر ایندکس
	 WHERE OrderID BETWEEN 10268 AND 10278
GO
SELECT OrderID,CustomerID,OrderDate FROM Orders2  WITH (INDEX(0)) -- عدم استفاده از ایندکس/اسکن کردن جدول
	 WHERE OrderID BETWEEN 10268 AND 10278
GO
------------------------------------------------------------------------------------------
--ایندکس NONCLUSTERED ایجاد   
--بر روی یک کلاستر ایندکس
USE Northwind
GO
--بررسی وجود جدول 
IF OBJECT_ID('Customers2', 'U') IS NOT NULL 
	DROP TABLE Customers2
GO
--تهیه کپی از جدول
SELECT * INTO Customers2 FROM Customers
GO
--جدول از نوع هیپ است
SP_HELPINDEX Customers2 
GO
--ایجاد یک کلاستر ایندکس
CREATE CLUSTERED INDEX IX_C ON Customers2(CustomerID)
GO
--ایجاد یک نان کلاستر ایندکس
CREATE NONCLUSTERED INDEX IX_NC ON Customers2(Country)
GO
SP_HELPINDEX Customers2 
GO
--آیا فرایند بوک مارک لوکاپ اتفاق افتاده است
SELECT Country FROM Customers2 
	WHERE Country IN ('Sweden' ,'Spain')
GO
--آیا فرایند بوک مارک لوکاپ اتفاق افتاده است
--عدم استفاده از ایندکس
SELECT CustomerID,Country,City FROM Customers2 
	WHERE Country IN ('Sweden' ,'Spain')
GO
--اجبار به استفاده از ایندکس
--آیا فرایند بوک مارک لوکاپ اتفاق افتاده است
SELECT CustomerID,Country,City FROM Customers2 WITH (INDEX(IX_NC))
	WHERE Country IN ('Sweden' ,'Spain')
GO
--اجبار به استفاده از ایندکس
--آیا فرایند بوک مارک لوکاپ اتفاق افتاده است
SELECT CustomerID,Country,City FROM Customers2 WITH (INDEX(IX_NC))
	WHERE Country ='Brazil'
GO
/*
هارد ديسك از سطح برگ به سطح داده جهت استخراج ستون هاي مورد نياز خود مراجعه مي كند
اين عمليات براي كوئري هايي كه تعداد ركوردهاي بازگشتي آن زياد است هزينه بر مي باشد
*/
--IO بررسی تعداد
SET STATISTICS IO ON
GO
SELECT CustomerID,Country,City FROM Customers2 WITH (INDEX(IX_NC))
	WHERE Country ='Brazil'
GO
SET STATISTICS IO OFF