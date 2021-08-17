--چگونه بوک مارک لوکاپ موجود در نان کلاستر ایندکس ها را حذف کنیم
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
CREATE NONCLUSTERED INDEX IX_NC1 ON Orders2(OrderID)
--CREATE INDEX IX_NC1 ON Orders2(OrderID)
GO
--جدول از نوع هیپ است چون کلاستر ایندکس ندارد
SP_HELPINDEX Orders2 
GO
--در حال حاضر کوئری بوک مارک لوکاپ ندارد
SELECT OrderID,CustomerID,OrderDate FROM Orders2 
	 WHERE OrderID BETWEEN 10268 AND 10278
GO
--اجبار به استفاده از ایندکس
-- فرایند بوک مارک لوکاپ اتفاق افتاده است
SELECT OrderID,CustomerID,OrderDate FROM Orders2  WITH (INDEX(IX_NC1)) 
	 WHERE OrderID BETWEEN 10268 AND 10278
GO
------------------------------------------------------------------------------------------
--چگونه بوک مارک لوکاپ را حذف کنیم
--با توجه به اینکه کوئری جهت تکمیل اطلاعات مورد نیاز خود از سطح برگ به دیتا مراجعه می کند
--بهترین راه این است که کلیه فیلدهای مورد نیاز کوئری داخل ایندکس باشه
CREATE NONCLUSTERED INDEX IX_NC2 ON Orders2(OrderID) 
	INCLUDE(CustomerID,OrderDate)
GO
SP_HELPINDEX Orders2
--اجرای کوئری بدون اینکه اجبار به استفاده از ایندکس خاصی باشد اجرا شود
SELECT OrderID,CustomerID,OrderDate FROM Orders2  
	 WHERE OrderID BETWEEN 10268 AND 10278
GO
--اجبار به استفاده از ایندکس
SELECT OrderID,CustomerID,OrderDate FROM Orders2  WITH (INDEX(IX_NC2)) 
	 WHERE OrderID BETWEEN 10268 AND 10278
GO
-----------------------------------
--مقایسه هر دو کوئری
--کوئری اول استفاده از نان کلاستر ایندکس
SELECT OrderID,CustomerID,OrderDate FROM Orders2  WITH (INDEX(IX_NC1)) 
	 WHERE OrderID BETWEEN 10268 AND 10278
--کوئری دوم
--Cover Index
SELECT OrderID,CustomerID,OrderDate FROM Orders2  WITH (INDEX(IX_NC2)) 
	 WHERE OrderID BETWEEN 10268 AND 10278
GO
--------------------------------------------------------------------------
--سوال
--آیا من می توانم فیلدهای مورد نیاز کوئری را به نوعی دیگر داخل ایندکس جا بدهم
--استفاده از روشی به جزء کاور ایندکس
USE tempdb
GO
IF OBJECT_ID('MyTable', 'U') IS NOT NULL 
	DROP TABLE MyTable
GO
CREATE TABLE MyTable
(
	Country NVARCHAR(50),
	City NVARCHAR(100),
)
GO
INSERT INTO MyTable VALUES ('UK','Manchester')
INSERT INTO MyTable VALUES ('UK','London')
INSERT INTO MyTable VALUES ('USA','Washington')
INSERT INTO MyTable VALUES ('USA','Boston')
INSERT INTO MyTable VALUES ('IRAN','Tehran')
GO
--مشاهده پلن اجرایی
--نحوه مرتب شدن رکوردها
SELECT * FROM MyTable
GO
CREATE NONCLUSTERED INDEX IX1 ON --فيلدها جز كليد ايندكس هستند
	MyTable(Country, City) 
GO
--مشاهده پلن اجرایی
--نحوه مرتب شدن رکوردها
SELECT * FROM MyTable
GO
CREATE NONCLUSTERED INDEX IX2 ON --به جدول اضافه شده اندInclude فيلدها به شكل 
	MyTable(Country) INCLUDE (City)
GO
--مشاهده پلن اجرایی
--نحوه مرتب شدن رکوردها
SELECT * FROM MyTable
/*
در صورتيكه فيلدها جزء كليد ايندكس باشند
عمليات مرتب سازي بر اساس فيلدهاي كليد ايندكس انجام خواهد شد									   
Index on MyTable(Country, City)

	Country		City
	-------		------
	IRAN		Tehran
	UK			London
	UK			Manchester
	USA			Boston
	USA			Washington

به جدول اضافه شده اندInclude در صورتيكه فيلدها به شكل
Index on MyTable(Country) Include(City)

	Country		City
	-------		------
	IRAN		Tehran
	UK			Manchester
	UK			London
	USA			Washington
	USA			Boston
*/
SELECT * FROM MyTable WITH (INDEX(0)) --Table Scan
SELECT * FROM MyTable WITH (INDEX(IX1))-- Index on MyTable(Country, City)
SELECT * FROM MyTable WITH (INDEX(IX2))-- Index on MyTable(Country) Include(City)
---------------------------------------------------------------
--نحوه ساخت به شکل ویژوالی 
