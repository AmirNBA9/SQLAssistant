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
