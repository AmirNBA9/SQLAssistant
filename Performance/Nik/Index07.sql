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