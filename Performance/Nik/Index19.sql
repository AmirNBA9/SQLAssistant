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