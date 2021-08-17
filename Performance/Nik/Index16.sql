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