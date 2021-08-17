--STATISTICS مديريت
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