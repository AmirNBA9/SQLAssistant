--01
USE master
GO
--بررسی وجود بانک اطلاعاتی
IF DB_ID('Compression_Test')>0
	DROP DATABASE Compression_Test  
GO
--ایجاد بانک اطلاعاتی
CREATE DATABASE Compression_Test  
GO
USE Compression_Test
GO
--------------------------------------------------------------------
--None_Compression
--------------------------------------------------------------------
 --بررسی جهت وجود جدول 
IF OBJECT_ID('None_Compression')>0
	DROP TABLE None_Compression
GO
----None Compressionايجاد جدول به صورت 
CREATE TABLE None_Compression
( 
	Code   INT IDENTITY PRIMARY KEY,
	Family NVARCHAR(700),
	Name   NVARCHAR(700)
)WITH (Data_Compression = NONE)
GO
SP_HELPINDEX None_Compression
GO
INSERT INTO None_Compression(Family,Name) VALUES (REPLICATE(N'طاهری*',100),REPLICATE(N'علیرضا*',100))
GO 1000
--------------------------------------------------------------------
--Row_Level_Compression
--------------------------------------------------------------------
 --بررسی جهت وجود جدول 
IF OBJECT_ID('Row_Level_Compression')>0
	DROP TABLE Row_Level_Compression
GO
----Row Compressionايجاد جدول به صورت 
CREATE TABLE Row_Level_Compression
( 
	Code   INT IDENTITY PRIMARY KEY,
	Family NVARCHAR(700),
	Name   NVARCHAR(700)
)WITH (Data_Compression = ROW)
GO
SP_HELPINDEX Row_Level_Compression
GO
INSERT INTO Row_Level_Compression(Family,Name)
	 VALUES (REPLICATE(N'طاهری*',100),REPLICATE(N'علیرضا*',100))
GO 1000
--------------------------------------------------------------------
--Page_Level_Compression
--------------------------------------------------------------------
 --بررسی جهت وجود جدول 
IF OBJECT_ID('Page_Level_Compression')>0
	DROP TABLE Page_Level_Compression
GO
--Page Compressionايجاد جدول به صورت 
CREATE TABLE Page_Level_Compression
( 
	Code   INT IDENTITY PRIMARY KEY,
	Family NVARCHAR(700),
	Name   NVARCHAR(700)
)WITH (Data_Compression = PAGE)
GO
SP_HELPINDEX Page_Level_Compression
GO
INSERT INTO Page_Level_Compression(Family,Name) VALUES (REPLICATE(N'طاهری*',100),REPLICATE(N'علیرضا*',100))
GO 1000
--------------------------------------------------------------------
--بررسی حجم و تعداد صفحات مربوط به جدول
--------------------------------------------------------------------
SP_SPACEUSED None_Compression
GO
SP_SPACEUSED Row_Level_Compression
GO
SP_SPACEUSED Page_Level_Compression
GO
--------------------------------------------------------------------
--و زمان اجرای کوئری هاIO بررسی وضعیت 
--------------------------------------------------------------------
SET STATISTICS IO ON
SET STATISTICS TIME ON
GO
DBCC DROPCLEANBUFFERS
CHECKPOINT
GO
SELECT * FROM None_Compression
SELECT * FROM Row_Level_Compression
SELECT * FROM Page_Level_Compression
GO
SET STATISTICS IO OFF
SET STATISTICS TIME OFF
-----------------------------------------------------------------------------------
--فشرده کردن ایندکس های یک جدول
-----------------------------------------------------------------------------------
USE AdventureWorks2012
GO
SP_HELPINDEX 'Sales.SalesOrderHeader'
GO
--dm_db_index_physical_stats استفاده از تابع
SELECT 
	O.object_id,O.name,S.index_id,IX.name,S.index_type_desc,S.alloc_unit_type_desc,
	S.index_depth,S.index_level,S.page_count ,S.record_count,S.avg_fragmentation_in_percent
	FROM 
		sys.dm_db_index_physical_stats
			(DB_ID(),OBJECT_ID('Sales.SalesOrderHeader'),NULL,NULL,'DETAILED') S
	INNER JOIN sys.objects O ON S.object_id=O.object_id
	LEFT OUTER JOIN sys.indexes IX ON S.object_id = ix.object_id AND S.index_id = ix.index_id
	WHERE  S.index_level=0
GO
--alter index all on table_name rebuild with(data_compression=page)
--فشرده کردن یک ایندکس از جدول
ALTER INDEX AK_SalesOrderHeader_SalesOrderNumber ON Sales.SalesOrderHeader 
	REBUILD WITH(DATA_COMPRESSION=PAGE)
GO
--فشرده کردن کلیه ایندکس های یک جدول
--Clustered Index + NonClustered Index تاثیر آن بر روی
ALTER INDEX ALL ON Sales.SalesOrderHeader 
	REBUILD WITH(DATA_COMPRESSION=PAGE)
GO
--dm_db_index_physical_stats استفاده از تابع
SELECT 
	O.object_id,O.name,S.index_id,IX.name,S.index_type_desc,S.alloc_unit_type_desc,
	S.index_depth,S.index_level,S.page_count ,S.record_count,S.avg_fragmentation_in_percent
	FROM 
		sys.dm_db_index_physical_stats
			(DB_ID(),OBJECT_ID('Sales.SalesOrderHeader'),NULL,NULL,'DETAILED') S
	INNER JOIN sys.objects O ON S.object_id=O.object_id
	LEFT OUTER JOIN sys.indexes IX ON S.object_id = ix.object_id AND S.index_id = ix.index_id
	WHERE  S.index_level=0
GO
--غیر فشرده کردن ایندکس های یک جدول
ALTER INDEX ALL ON Sales.SalesOrderHeader 
	REBUILD WITH(DATA_COMPRESSION=NONE)
GO
-----------------------------------------------------------------------------------
