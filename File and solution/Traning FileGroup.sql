--Step one:
/*
ایجاد دیتابیس با تعداد سه فایل گروه
Defualt : آنی که در صورت مشخص نشدن دیتا در آن قرار میگیرد
ReadOnly: آنی که برای آرشیو کردن دیتا از آن استفاده می شود
*/

--Step two
/*ایجاد پارتیشن و اسکیما
use PartitionDB
go
Create partition function pfOrderdateRange(DateTime)
as
range left for values ('2016/12/31','2017/12/31','2018/12/31')
Go
Create partition scheme psOderdateRange
as
partition pfOrderDateRange TO (FG1,FG2,FG3,[PRIMARY])
go
*/

--Step3
/*ایجاد جدول بصورت Align Index

Create table Orders(
Orderid int Identity(1,1) Not null,
Orderdate datetime not null,
OrderFreight Money null,
ProductID int null,
Constraint PK_Orders primary key clustered (orderID  ASC, orderdate Asc)
On psOderdateRange (orderdate)
) On psOderdateRange (orderdate)
go
*/

--Step 4
/*insert data
SET NOCOUNT ON
DECLARE @OrderDate DATETIME
DECLARE @X INT
SET @OrderDate = '2010/01/01'
SET @X = 0
WHILE @X < 300
BEGIN
INSERT dbo.Orders ( OrderDate, OrderFreight, ProductID)
VALUES( @OrderDate + @X, @X + 10, @X)
 SET @X = @X + 1
END
GO
SET NOCOUNT ON
DECLARE @OrderDate DATETIME
DECLARE @X INT
SET @OrderDate = '2011/01/01'
SET @X = 0
WHILE @X < 300
BEGIN
INSERT dbo.Orders ( OrderDate, OrderFreight, ProductID)
VALUES( @OrderDate + @X, @X + 10, @X)
 SET @X = @X + 1
END
GO
SET NOCOUNT ON
DECLARE @OrderDate DATETIME
DECLARE @X INT
SET @OrderDate = '2012/01/01'
SET @X = 0
WHILE @X < 300
BEGIN
INSERT dbo.Orders ( OrderDate, OrderFreight, ProductID)
VALUES( @OrderDate + @X, @X + 10, @X)
 SET @X = @X + 1
END
GO
*/

--Step 5
/*مشاهده نحوه توزیع داده
USE [PartitionDB]
GO
SELECT OBJECT_NAME(i.object_id) AS OBJECT_NAME,
p.partition_number, fg.NAME AS FILEGROUP_NAME, ROWS, au.total_pages,
CASE boundary_value_on_right
WHEN 1 THEN 'Less than'
ELSE 'Less or equal than' END AS 'Comparition',VALUE
FROM sys.partitions p JOIN sys.indexes i
ON p.object_id = i.object_id AND p.index_id = i.index_id
JOIN sys.partition_schemes ps ON ps.data_space_id = i.data_space_id
JOIN sys.partition_functions f ON f.function_id = ps.function_id
LEFT JOIN sys.partition_range_values rv
ON f.function_id = rv.function_id
AND p.partition_number = rv.boundary_id
JOIN sys.destination_data_spaces dds
ON dds.partition_scheme_id = ps.data_space_id
AND dds.destination_id = p.partition_number
JOIN sys.filegroups fg
ON dds.data_space_id = fg.data_space_id
JOIN (SELECT container_id, SUM(total_pages) AS total_pages
FROM sys.allocation_units
GROUP BY container_id) AS au
ON au.container_id = p.partition_id WHERE i.index_id < 2
*/

--step 7
/*در ادامه به ایجاد یک Filegroup جدید*/
/* Query 2-3- Split a partition
-- Add FG4:
ALTER DATABASE PartitionDB ADD FILEGROUP FG4
Go
ALTER PARTITION SCHEME [psOderdateRange] NEXT USED FG4
GO
ALTER PARTITION FUNCTION [pfOrderDateRange]() SPLIT RANGE('2019/12/31')
GO
-- Add Partition 4 (P4) to FG4:
GO
ALTER DATABASE PartitionDB ADD FILE
(
NAME = P4,
FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL14.MSSQLSERVER2017\MSSQL\DATA\P4.NDF'
, SIZE = 1024KB , MAXSIZE = UNLIMITED, FILEGROWTH = 10%)
 TO FILEGROUP [FG4]
--
GO
*/

--step 5
/*ورود مجدد دیتا
SET NOCOUNT ON
DECLARE @OrderDate DATETIME
DECLARE @X INT
SET @OrderDate = '2018/01/01'
SET @X = 0
WHILE @X < 300
BEGIN
INSERT dbo.Orders ( OrderDate, OrderFreight, ProductID)
VALUES( @OrderDate + @X, @X + 10, @X)
 SET @X = @X + 1
END
GO
SET NOCOUNT ON
DECLARE @OrderDate DATETIME
DECLARE @X INT
SET @OrderDate = '2019/01/01'
SET @X = 0
WHILE @X < 300
BEGIN
INSERT dbo.Orders ( OrderDate, OrderFreight, ProductID)
VALUES( @OrderDate + @X, @X + 10, @X)
 SET @X = @X + 1
END
GO
*/

--step 8
/*ادغام پارتیشن*/
/* Query 2-4- Merge Partitions 
ALTER PARTITION FUNCTION [pfOrderDateRange]() MERGE RANGE('2017/12/31')
Go
*/

--step 9
/* آرشیو نمودن اطلاعات*/
/* Query 2-5- Switch Partitions 
USE [PartitionDB]
GO
CREATE TABLE [dbo].[Orders_Temp](
[OrderID] [int] IDENTITY(1,1) NOT NULL,
[OrderDate] [datetime] NOT NULL,
[OrderFreight] [money] NULL,
[ProductID] [int] NULL,
 CONSTRAINT [PK_OrdersTemp] PRIMARY KEY CLUSTERED ([OrderID] ASC,[OrderDate] ASC)ON FG1
) ON FG1
GO
USE [tempdb]
GO
Create TABLE [dbo].[Orders_Hist](
[OrderID] [int] NOT NULL,
[OrderDate] [datetime] NOT NULL,
[OrderFreight] [money] NULL,
[ProductID] [int] NULL,
 CONSTRAINT [PK_OrdersTemp] PRIMARY KEY CLUSTERED ([OrderID] ASC,[OrderDate] ASC)
)
GO
USE [PartitionDB]
GO
ALTER TABLE [dbo].[Orders] SWITCH PARTITION 1 TO [dbo].[Orders_Temp]
GO
INSERT INTO [tempdb].[dbo].[Orders_Hist]
SELECT * FROM  [dbo].[Orders_Temp]
GO
DROP TABLE [dbo].[Orders_Temp]
GO
SELECT * FROM [tempdb].[dbo].[Orders_Hist]
*/