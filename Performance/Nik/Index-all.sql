/*1*/
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
--بررسی ساختار جدول
SP_HELP Orders
GO
SP_HELP Orders2
GO
--بررسی ایندکس های هر دو جدول
SP_HELPINDEX Orders
GO
SP_HELPINDEX Orders2
GO
--نمايش كلي  ركوردها
--Show Execution Plane
SELECT * FROM Orders --داراي كلاستر ايندكس
SELECT * FROM Orders2--جدول به شكل هيپ مي باشد
GO
--نمايش يك ركورد خاص
--Show Execution Plane
SELECT * FROM Orders WHERE OrderID=10666 --داراي كلاستر ايندكس
SELECT * FROM Orders2 WHERE OrderID=10666 --جدول به شكل هيپ مي باشد
GO
/*
نتیجه گیری
--جداول هيپ معمولا براي بدست آوردن ركوردهاي زياد خوب هستند
--جداول هيپ براي بدست آوردن تعداد كمي ركورد مناسب نمي باشند
*/

/*2*/--ايجاد كلاستر ايندكس
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

/*3*/--IO,Execution Time , Execution Plane بررسی 
--مربوط به کوئری ها زمانی که کلاسترایندکس داریم
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

/*4*/
--یکتا بودن کلاستر ایندکس/Unique بررسی
USE tempdb
GO
IF OBJECT_ID('Students', 'U') IS NOT NULL 
	DROP TABLE Students
GO
CREATE TABLE Students
(
	Code INT,
	FirstName NVARCHAR(50),
	LastName NVARCHAR(80)
)
GO
SP_HELPINDEX Students--جدول از نوع هیپ است
GO
INSERT INTO Students VALUES 
	(1001,N'مسعود',N'طاهری'),
	(1008,N'فرید',N'طاهری'),
	(1007,N'مجید',N'طاهری'),
	(1011,N'علی',N'طاهری'),
	(1009,N'احمد',N'غفاری'),
	(1002,N'علیرضا',N'نصیری'),
	(1003,N'محمد',N'صباغی')
GO
SELECT * FROM Students --رکوردهای جدول بر اساس فیلدی مرتب نشده اند و صرفا بر اساس ترتیب درج مرتب شده اند
GO
CREATE CLUSTERED INDEX IX_Clustered ON Students (Code) 
GO
SELECT * FROM Students-- رکوردها بر اساس فیلد کد مرتب شده اند
GO
INSERT INTO Students VALUES  (1003,N'احمد',N'باغبانی') --تلاش برای درج یک مقدار با کد تکراری
GO
SELECT * FROM Students--رکورد تکراری در جدول مشاهده شود
GO
--بررسی جهت وجود جدول
IF OBJECT_ID('Students2', 'U') IS NOT NULL 
	DROP TABLE Students2
--ایجاد جدول
CREATE TABLE Students2
(
	Code INT,
	FirstName NVARCHAR(50),
	LastName NVARCHAR(80)
)
GO
SP_HELPINDEX Students2--جدول از نوع هیپ است
GO
INSERT INTO Students2 VALUES 
	(1001,N'مسعود',N'طاهری'),
	(1008,N'فرید',N'طاهری'),
	(1007,N'مجید',N'طاهری'),
	(1011,N'علی',N'طاهری'),
	(1009,N'احمد',N'غفاری'),
	(1002,N'علیرضا',N'نصیری'),
	(1003,N'محمد',N'صباغی')
GO
SELECT * FROM Students2 --رکوردهای جدول بر اساس فیلدی مرتب نشده اند و صرفا بر اساس ترتیب درج مرتب شده اند
GO
CREATE UNIQUE CLUSTERED INDEX IX_UniqueClustered ON Students2 (Code) 
GO
SELECT * FROM Students2-- رکوردها بر اساس فیلد کد مرتب شده اند
GO
INSERT INTO Students2 VALUES  (1003,N'احمد',N'باغبانی') --تلاش برای درج یک مقدار با کد تکراری
GO
SELECT * FROM Students2--رکورد تکراری در جدول مشاهده شود
GO
--بررسی تاثیر یونیک بودن کلاستر ایندکس در کوئری ها
--زمانیکه حجم رکوردها بالا است
DECLARE @CODE INT=1020
WHILE @CODE<=2020
BEGIN
	INSERT INTO Students VALUES (@CODE,'FirstName'+CAST(@CODE AS VARCHAR(10)),'LastName'+CAST(@CODE AS VARCHAR(10))) --کلاستر ایندکس عادری
	INSERT INTO Students2 VALUES (@CODE,'FirstName'+CAST(@CODE AS VARCHAR(10)),'LastName'+CAST(@CODE AS VARCHAR(10))) --کلاستر ایندکس به شکل یونیک
	SET @CODE=@CODE+1
END
GO
SELECT * FROM Students
SELECT * FROM Students2
GO
SELECT * FROM Students WHERE CODE=2010
SELECT * FROM Students2 WHERE CODE=2010
GO

/*5*/
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

/*6*/
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

/*7*/
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

/*8*/
--و تاثیر استفاده از آنها در ایندکسUnique Key , Primary key
USE tempdb
GO
--بررسی وجود جدول 
IF OBJECT_ID('Students', 'U') IS NOT NULL 
	DROP TABLE Students
GO
CREATE TABLE Students
(
	ID INT PRIMARY KEY,
	NationalCode BIGINT UNIQUE,
	FirstName NVARCHAR(50),
	LastName NVARCHAR(70)
)
GO
SP_HELPCONSTRAINT Students
GO
--بررسی دو ویژگی مهم کلید اصلی و کلید یکتا
/*
هر دو کلید مقدار یکتا می گیرند
--یونیک کی می تواند نال را به عنوان مقدار مجاز دریافت کنید 
--ولی پرایمری کی نمی تواند نل را به عنوان مقدار مجاز دریفات کند
*/
INSERT INTO  Students(ID,NationalCode,FirstName,LastName) VALUES (NULL,'1234567890',N'مسعود',N'طاهری')
INSERT INTO  Students(ID,NationalCode,FirstName,LastName) VALUES (1,NULL,N'مسعود',N'طاهری')
INSERT INTO  Students(ID,NationalCode,FirstName,LastName) VALUES (2,NULL,N'فرید',N'طاهری')
GO
SELECT * FROM Students
--بررسی وجود جدول 
IF OBJECT_ID('Students', 'U') IS NOT NULL 
	DROP TABLE Students
GO
CREATE TABLE Students
(
	ID INT IDENTITY PRIMARY KEY,
	NationalCode BIGINT UNIQUE,
	FirstName NVARCHAR(50),
	LastName NVARCHAR(70)
)
GO
SP_HELPCONSTRAINT Students
SP_HELPINDEX Students
GO
INSERT INTO  Students(NationalCode,FirstName,LastName) VALUES ('1234567890',N'مسعود',N'طاهری')
INSERT INTO  Students(NationalCode,FirstName,LastName) VALUES ('1234567890',N'فرید',N'طاهری')
GO

/*9*/--تاثیر درج و حذف رکوردها در ایندکس ها
--	هنگام درج به روز رساني و حذف ركوردها ايندكس هاي آن نيز به روز مي شود
-- Non Clustered indexes must be updated (maintained) 
-- immediately when the main table is modified:

SP_HELPINDEX Customers
GO
ALTER DATABASE NORTHWIND SET RECOVERY SIMPLE --تغییر نحوه رفتار لاگ فایل هنگام ذخیره اطلاعات به چه صورتی باشد
GO
CHECKPOINT  --انتقال كليه صفحات تغيير يافته از حافظه به ديسك
GO
SELECT * FROM  fn_dblog(null,null) --نمايش محتواي لاگ فايل
GO
--درج يك ركورد در جدول مشتريان
INSERT INTO  Customers(CustomerID,CompanyName) VALUES('a','b')
GO
--به تعداد درج هاي انجام شده  به ازی جدول مشتریان و ایندکس های مربوط به آن در لاگ فایل توجه كنيد 
SELECT * FROM  fn_dblog(null,null) --نمايش محتواي لاگ فايل
GO


/*10*/

--فیلتر ایندکس ها
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
SELECT * FROM ORDERS2
	WHERE (OrderDate >='1996-01-01' AND OrderDate <='1997-06-30')
--ايجاد يك نان کلاستر ايندكس
--به صورت کارو ایندکس و فیلتر شده
CREATE NONCLUSTERED INDEX IX_NC1 ON Orders2(OrderID) 
	INCLUDE (CustomerID,OrderDate)
		WHERE (OrderDate >='1996-01-01' AND OrderDate <='1997-06-30')
GO
--ايجاد يك نان کلاستر ايندكس
--به صورت کارو ایندکس
CREATE NONCLUSTERED INDEX IX_NC2 ON Orders2(OrderID) 
	INCLUDE (CustomerID,OrderDate)
GO
SP_HELPINDEX ORDERS2
GO
--مقايسه حجم اشغال شده توسط اين دو ايندكس
SELECT Index_ID, Index_Type_Desc, Page_Count,record_count
	FROM SYS.DM_DB_INDEX_PHYSICAL_STATS(DB_ID(N'Northwind'), OBJECT_ID(N'Northwind.DBO.Orders2'), NULL, NULL , 'detailed')
GO
--IOفعال سازي نمايش آمار 
SET STATISTICS IO ON
GO
--استفاده از ایندکس فیلتر شده
SELECT OrderID,CustomerID,OrderDate FROM Orders2
	WHERE (OrderDate >='1996-01-01' AND OrderDate <='1997-06-30')
GO
--استفاده از ایندکس فیلتر نشده
SELECT OrderID,CustomerID,OrderDate FROM Orders2 WITH (INDEX(IX_NC2))
	WHERE (OrderDate >='1996-01-01' AND OrderDate <='1997-06-30')
GO
--مقایسه پپلن اجرایی دو کوئری
SELECT OrderID,CustomerID,OrderDate FROM Orders2
	WHERE (OrderDate >='1996-01-01' AND OrderDate <='1997-06-30')
--استفاده از ایندکس فیلتر نشده
SELECT OrderID,CustomerID,OrderDate FROM Orders2 WITH (INDEX(IX_NC2))
	WHERE (OrderDate >='1996-01-01' AND OrderDate <='1997-06-30')
GO
----------------------------------------------------------------------------------
--كاربرد ديگر ايندكس هاي فيلتر شده
--در صورتيكه كد ملي داراي مقدار باشد اين مقدار يكتا باشد
USE tempdb
GO
--بررسی وجود جدول 
IF OBJECT_ID('Students', 'U') IS NOT NULL 
	DROP TABLE Students
GO
CREATE TABLE Students
(
	ID INT IDENTITY PRIMARY KEY,
	Name NVARCHAR(50),
	Family NVARCHAR(50),
	NationalCode NVARCHAR(20)
)
GO
SP_HELPINDEX Students
GO
INSERT Students(Name, Family, NationalCode) VALUES
    (N'مسعود', N'طاهري', '111-111-111-111'),
    (N'فريد', N'طاهري', NULL),
    (N'مجيد', N'طاهري', '222-222-222-222'),
    (N'علي', N'طاهري', '333-333-333-333'),
    (N'عليرضا', N'نصيري', NULL),
    (N'حامد', N'اكبر مقدم', '444-444-444-444'),
    (N'بهروز', N'اكبري', ''),
    (N'صادق', N'نوري', ''),
    (N'محمد', N'صباغي', NULL)
GO
SELECT * FROM Students
GO
--در صورتيكه كد ملي داراي مقدار باشد اين مقدار يكتا باشد
-- This Will Fail
CREATE UNIQUE NONCLUSTERED INDEX IX1 ON Students(NationalCode)
--CREATE UNIQUE INDEX IX1 ON Students(NationalCode)
GO
--در صورتيكه كد ملي داراي مقدار باشد اين مقدار يكتا باشد
-- This Will Work
CREATE UNIQUE INDEX IX1 ON Students(NationalCode) 
	WHERE (NationalCode <>'' AND  NationalCode IS NOT NULL)
GO
SP_HELPINDEX Students
GO
-- This Will Be Inserted
INSERT Students(Name, Family, NationalCode)
    VALUES (N'كريم', N'صادقي' , NULL)
GO
-- This Will Be Inserted
INSERT Students(Name, Family, NationalCode)
    VALUES (N'علي', N'شادي' , '')
GO
-- This Will Be Inserted
INSERT Students(Name, Family, NationalCode)
    VALUES (N'محمد', N'اصغري' , '')
GO
-- This Will Be Prevented Because of Duplicate NationalCode
INSERT Students(Name, Family, NationalCode)
    VALUES (N'ناصر', N'رادمنش' , '222-222-222-222')
GO
SELECT * FROM Students

/*11*/
/*معرفي آمار توزيع
-- Introducing Distribution Statistics
--ها در يك فيلد را نشان مي دهدValueپراكندگي Statistics
این آمار باعث می شود که اس کیو ال سرور ایندکس مناسب برای کوئری را انتخاب کند
GO
 Statistics are built when:
1) You create an index
2) You search on a column without statistics (Depends on db option)
*/
USE Northwind
GO
SELECT * FROM CUSTOMERS
SELECT City,COUNT(City) FROM Customers
	GROUP BY City
GO
--Statistics Blob
SP_HELPINDEX Customers
DBCC SHOW_STATISTICS ('Customers','City')
DBCC SHOW_STATISTICS ('Customers','City') WITH STAT_HEADER 
DBCC SHOW_STATISTICS ('Customers','City') WITH DENSITY_VECTOR --پراكندگي
DBCC SHOW_STATISTICS ('Customers','City') WITH HISTOGRAM
SELECT City,COUNT(City) FROM Customers
	GROUP BY City
GO
--Statistics Blob
SP_HELPINDEX Orders
DBCC SHOW_STATISTICS ('Orders','CustomerID')
DBCC SHOW_STATISTICS ('Orders','CustomerID') WITH STAT_HEADER 
DBCC SHOW_STATISTICS ('Orders','CustomerID') WITH DENSITY_VECTOR --پراكندگي
DBCC SHOW_STATISTICS ('Orders','CustomerID') WITH HISTOGRAM
SELECT CustomerID,COUNT(CustomerID) FROM Orders
	GROUP BY CustomerID
GO
------------------------------------------------------------------------------------------------------------------------
IF OBJECT_ID('Orders2', 'U') IS NOT NULL 
	DROP TABLE Orders2
GO
--تهیه کپی از جدول
SELECT * INTO Orders2 FROM Orders
GO
CREATE CLUSTERED INDEX IX_OrderID ON Orders2(OrderID)
GO
SP_HELPINDEX Orders2 
GO
---------------------
--اگر يك كوئري داراي شرطي باشد كه فيلد مورد نظر آن داراي ايندكس نمي باشد
--ساخته مي شودStatisticsبراي آن باز هم  
---------------------
GO
--نداریم ShipCountryایندکس بر روی فیلد
SELECT * FROM  Orders2 
	WHERE ShipCountry='USA' 
GO
--Statisticsمشاهده
DBCC SHOW_STATISTICS ('Orders2','_WA_Sys_0000000E_5BE2A6F2')
GO
--جداگانه ساخته مي شودStatistics به ازاي هر كدام از فيلدهاي موجود در شرط كوئري يك 
SELECT * FROM  Orders2 WHERE 
	ShipCountry='USA' AND EmployeeID=5
GO
------------------------------------------------------------------------------------------------------------------------
--دو ایندکس ایجاد می کنیمOrders2 بر روی جدول
CREATE NONCLUSTERED INDEX IX_ShipCountry ON Orders2(ShipCountry) 
	INCLUDE (OrderID,EmployeeID)
GO
CREATE NONCLUSTERED INDEX IX_EmployeeID ON Orders2(EmployeeID)  
	INCLUDE (OrderID,ShipCountry)
GO
SP_HELPINDEX Orders2
GO
--بررسی پلن اجرایی جهت مشاهده ایندکس مورد استفاده
SELECT * FROM  Orders2 
	WHERE ShipCountry='USA' AND EmployeeID=5
GO
--حتی اگر جای شرط را عوض کنید باز هم از همان ایندکس قبلی استفاده خواهد شد
SELECT * FROM  Orders2 
	WHERE EmployeeID=5 AND ShipCountry='USA' 
GO
--از كجا مي فهمد كه از كدام ايندكس استفاده كند به نفعش استSQL
--ShipCountry ايندكس مربوط به  
--EmployeeID ايندكس مربوط به  
GO
DBCC SHOW_STATISTICS('Orders2','IX_EmployeeID') --EmployeeID=5 :  42 RECORD
DBCC SHOW_STATISTICS('Orders2','IX_ShipCountry') --ShipCountry='USA' : 122 RECORD
--استفاده مي شودIX_EmployeeIDپس از ايندكس
GO
---------------------------------------
--بررسی پلن اجرایی جهت مشاهده ایندکس مورد استفاده
SELECT OrderID,EmployeeID,ShipCountry FROM  Orders2 
	WHERE ShipCountry='USA' AND EmployeeID=5
GO
--حتی اگر جای شرط را عوض کنید باز هم از همان ایندکس قبلی استفاده خواهد شد
SELECT OrderID,EmployeeID,ShipCountry FROM  Orders2 
	WHERE EmployeeID=5 AND ShipCountry='USA' 
GO
--از كجا مي فهمد كه از كدام ايندكس استفاده كند به نفعش استSQL
--ShipCountry ايندكس مربوط به  
--EmployeeID ايندكس مربوط به  
GO
DBCC SHOW_STATISTICS('Orders2','IX_EmployeeID') --EmployeeID=5 :  42 RECORD
DBCC SHOW_STATISTICS('Orders2','IX_ShipCountry') --ShipCountry='USA' : 122 RECORD
--استفاده مي شودIX_EmployeeIDپس از ايندكس
---------------------------------------------------------------------------------------


/*12*/ --STATISTICS مديريت
USE Northwind
GO
--بررسی وجود جدول 
IF OBJECT_ID('Customers2', 'U') IS NOT NULL 
	DROP TABLE Customers2
GO
--Make table in query
SELECT * INTO Customers2 FROM Customers
GO
SP_HELPINDEX Customers2 
GO
SELECT * FROM Customers2 
	where  ContactTitle = 'Owner' 
GO
-------------------------------
/*
Create statistics
Update statistics	
Drop statistics	
*/
--STATISTICS ايجاد
CREATE STATISTICS Country_City ON Customers2(Country,City)
GO
DBCC SHOW_STATISTICS ('Customers2','Country_City')--هاي فيلد مورد نظرValuesمشاهده آمار پراكندگي 
GO
-------------------------------
--از نوع فيلتر شدهSTATISTICS 
CREATE STATISTICS Country ON Customers2(Country)--هاي فيلد مورد نظرValuesمشاهده آمار پراكندگي 
 WHERE ContactTitle = 'Owner'
GO
DBCC SHOW_STATISTICS ('Customers2','Country') --هاي فيلد مورد نظرValuesمشاهده آمار پراكندگي 
GO
-------------------------------
--STATISTICS استخراج ليست 
SELECT * FROM sys.stats
SELECT * FROM sys.stats WHERE NAME='Country'
SELECT * FROM sys.stats_columns
SELECT OBJECT_NAME(object_id), * FROM sys.stats_columns
	WHERE OBJECT_NAME(object_id)='Customers2'
GO
-------------------------------
/*
خودكارStatistcs پيش نيازهاي به روز رساني و ايجاد 
*/
--فعال شدن وضعيت به روزرساني آن در بانك اطلاعاتي مي باشدStatistics شرط به روزرساني 
ALTER DATABASE Northwind 
	SET AUTO_CREATE_STATISTICS OFF WITH NO_WAIT
GO
--فعال شدن وضعيت به روزرساني آن در بانك اطلاعاتي مي باشدStatistics شرط به روزرساني 
ALTER DATABASE Northwind
	SET AUTO_UPDATE_STATISTICS ON  WITH NO_WAIT
GO
-- به شكل آسنكرونStatistics فعال سازي به روز رساني خودكار 
ALTER DATABASE Northwind
	SET AUTO_UPDATE_STATISTICS_ASYNC ON  WITH NO_WAIT
GO
--STATISTICS به روز رساني
ALTER DATABASE Northwind --غير فعال كردن به روز رساني خودكار
	SET AUTO_UPDATE_STATISTICS OFF WITH NO_WAIT
GO
EXEC sp_autostats 'Customers2'
--EXEC sp_autostats 'Customers2','OFF'
GO
DBCC SHOW_STATISTICS ('Customers2','Country') WITH HISTOGRAM--هاي فيلد مورد نظرValuesمشاهده آمار پراكندگي 
GO
INSERT INTO Customers2(CustomerID,CompanyName,ContactTitle,City,Country) 
	VALUES('M_T','DSICT','Owner','Tehran','IRAN')
GO
SELECT * FROM Customers2 WHERE Country='IRAN'  
GO
DBCC SHOW_STATISTICS ('Customers2','Country') WITH HISTOGRAM--نمايش آمار پراكندگي ركوردها
--همانطور كه مشاهده مي كنيد آمار هنوز به روز نشده است چرا؟
GO
UPDATE STATISTICS Customers2 --هاي مربوط به جدولSTATISTICS به روز رساني
GO
DBCC SHOW_STATISTICS ('Customers2','Country') WITH HISTOGRAM--نمايش آمار پراكندگي ركوردها
GO
--مر بوط به كليه جداولSTATISTICS به روز رساني 
EXEC sp_updatestats
GO
DBCC SHOW_STATISTICS ('Customers2','Country') WITH HISTOGRAM--نمايش آمار پراكندگي ركوردها
GO
ALTER DATABASE Northwind -- فعال كردن به روز رساني خودكار
	SET AUTO_UPDATE_STATISTICS ON WITH NO_WAIT	
-------------------------------
--STATISTICS حذف
DROP STATISTICS Customers2.Country
---------------------------------------------------------------------------------------


/*13*/
/*
Index Optionبررسي  
*/
-------------------------------------------------------
--Using the IGNORE_DUP_KEY option
USE tempdb
GO
--بررسی وجود جدول 
IF OBJECT_ID('T1', 'U') IS NOT NULL 
	DROP TABLE T1
GO
CREATE TABLE T1
(
	F1 INT,
	F2 NVARCHAR(10)
)
GO
CREATE UNIQUE CLUSTERED INDEX IX1 ON T1(F1)
GO
SP_HELPINDEX T1
GO
INSERT INTO T1 VALUES (1,'A')
INSERT INTO T1 VALUES (2,'B')
INSERT INTO T1 VALUES (2,'B')
INSERT INTO T1 VALUES (3,'C')
--به خطاي ايجاد شده دقت كنيد
GO
SELECT * FROM T1
GO
DELETE FROM T1
GO
DROP INDEX IX1 ON T1
GO
--دقت كنيدIGNORE_DUP_KEYبه تنظيم
CREATE UNIQUE CLUSTERED INDEX IX1 ON T1(F1)
	WITH (IGNORE_DUP_KEY = ON)
GO
INSERT INTO T1 VALUES (1,'A')
INSERT INTO T1 VALUES (2,'B')
INSERT INTO T1 VALUES (2,'B')
INSERT INTO T1 VALUES (3,'C')
--به هشدار ايجاد شده دقت كنيد
GO
SELECT * FROM T1
GO
INSERT INTO T1 VALUES (2,'B')
SELECT * FROM T1
GO
-------------------------------------------------------
--Using DROP_EXISTING to drop and re-create an index
--در صورتيكه ايندكس از قبل وجود داشته باشد مجددا ايجاد مي شود
--از اين گزينه بيشتر براي بازسازي ايندكس استفاده مي شود
CREATE UNIQUE CLUSTERED INDEX IX1 ON T1(F1)
	WITH (DROP_EXISTING = ON)
GO
-------------------------------------------------------
--SORT_IN_TEMPDB
--مرتب سازي ايندكس در بانك اطلاعاتي تمپ
CREATE UNIQUE CLUSTERED INDEX IX1 ON T1(F1)
	WITH (SORT_IN_TEMPDB=ON,DROP_EXISTING = ON)
GO
-------------------------------------------------------
--ONLINE 
--ايجاد ايندكس به شكل آنلاين بدون اينكه كاربري در سطح شبكه قفل شود
--درحقيقت هيچ قفلي بر روي جدول ايجاد نمي شود
--با اعمال اين حالت پروسه ساخت ايندكس ممكن است طولاني شود
CREATE UNIQUE CLUSTERED INDEX IX1 ON T1(F1)
	WITH (ONLINE=ON,DROP_EXISTING = ON)
GO
-------------------------------------------------------
--ALLOW_ROW_LOCKS 
--قفل مربوط به  يك جدول را در سطح رديف يا همان ركوردهاي آن اعمال مي كند
CREATE UNIQUE CLUSTERED INDEX IX1 ON T1(F1)
	WITH (ALLOW_ROW_LOCKS=ON,DROP_EXISTING = ON)
GO
-------------------------------------------------------
--ALLOW_PAGE_LOCKS 
--قفل مربوط به  يك جدول را در سطح صفحه اعمال مي كند
CREATE UNIQUE CLUSTERED INDEX IX1 ON T1(F1)
	WITH (ALLOW_PAGE_LOCKS=ON,DROP_EXISTING = ON)
GO
-------------------------------------------------------
/*DATA_COMPRESSION 
نوع فشرده سازي  فيلدهاي موجود در ايندكس را مشخص مي كند
*/
--ROW COMPRESSION 
CREATE UNIQUE CLUSTERED INDEX IX1 ON T1(F1)
	WITH (DATA_COMPRESSION=ROW ,DROP_EXISTING = ON)
GO
--PAGE COMPRESSION 
CREATE UNIQUE CLUSTERED INDEX IX1 ON T1(F1)
	WITH (DATA_COMPRESSION=PAGE ,DROP_EXISTING = ON)
-------------------------------------------------------
/*MAXDOP : MAX Degree Of Parallelism 
هاي درگير جهت ساخت ايندكس را مشخص مي كندprocessorتعداد 
IF MAXDOP=1 THEN : Suppresses parallel plan generation
IF MAXDOP>1 THEN : maximum number of processors used in a parallel index 
IF MAXDOP=0 (default) : Uses the actual number of processors or fewer based on the current system workload
*/
SP_CONFIGURE 'Max Degree of Parallelism'
GO
CREATE UNIQUE CLUSTERED INDEX IX1 ON T1(F1)
	WITH (MAXDOP=5 ,DROP_EXISTING = ON)
GO
-------------------------------------------------------
--STATISTICS_NORECOMPUTE 
--كنترل محاسبه آمار خودكار ايندكس ها را مشخص مي كند
--IF STATISTICS_NORECOMPUTE=OFF THEN : USE UPDATE STATISTICS TABLE_NAME
CREATE UNIQUE CLUSTERED INDEX IX1 ON T1(F1)
	WITH (STATISTICS_NORECOMPUTE=OFF,DROP_EXISTING = ON)
GO
-------------------------------------------------------

/*14*/
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
