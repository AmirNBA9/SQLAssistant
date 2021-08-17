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
