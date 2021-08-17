
--SQL SERVER مشاهده قسمت هاي مختلف حافظه تخصيص يافته به 
DBCC MemoryStatus 
GO
--مشاهده كوئري هايي كه كش شده اند
SELECT * FROM sys.syscacheobjects 
GO
--مشاهده كوئري هايي كه كش شده اند
SELECT C.cacheobjtype,C.objtype,C.sql,C.sqlbytes 
	FROM sys.syscacheobjects C
GO
--چه تعداد كوئري كش شده اند
SELECT COUNT(C.objid) FROM sys.syscacheobjects C
GO
--چه مقدار حافظه به متن كوئري هايي كه كش شده اند تخصيص يافته است 
SELECT SUM(C.sqlbytes) FROM sys.syscacheobjects C
GO
--مشاهده كوئري هايي كه كش شده اند
--هر كوئري يك هندل دارد
--اين هندل به صورت هش شده مي باشد
SELECT * FROM sys.dm_exec_cached_plans 
GO
--مشاهده سورس كوئري هايي كه كش شده اند
SELECT CP.cacheobjtype ,CP.size_in_bytes,ST.text
	FROM sys.dm_exec_cached_plans CP
		CROSS APPLY sys.dm_exec_sql_text(plan_handle) AS ST
GO
--مقدار حافظه تخصيص يافته در كش به ازاي كوئري ها كه شامل ركوردهاي موجود در حافظه
SELECT  SUM(CP.size_in_bytes) FROM sys.dm_exec_cached_plans CP
GO
--مشاهده سورس كوئري هايي كه كش شده اند
--به همراه پلت اجرايي 
SELECT CP.cacheobjtype ,CP.size_in_bytes,ST.text,query_plan
	FROM sys.dm_exec_cached_plans CP
		CROSS APPLY sys.dm_exec_sql_text(plan_handle) AS ST
		CROSS APPLY sys.dm_exec_query_plan(plan_handle) 
GO
--------------------------------------------------------------------------------------------------
DBCC FREEPROCCACHE --پاك كردن كش مربوط به پروسيجرهاو .... به ازاي كليه بانك هاي اطلاعاتي مي باشد
GO
--محتواي كش نمايش داده شود
SELECT CP.cacheobjtype ,CP.size_in_bytes,ST.text
	FROM sys.dm_exec_cached_plans CP
		CROSS APPLY sys.dm_exec_sql_text(plan_handle) AS ST
GO
--محتواي كش نمايش داده شود
SELECT * FROM sys.syscacheobjects 
--------------------------------------------------------------------------------------------------------
--مديريت كش
CHECKPOINT--كليه صفحات تغيير يافته موجود در حافظه و لاگ فال در ديتا فايل نوشته مي شود
GO
DBCC DROPCLEANBUFFERS-- صفحه هاي موجود در كش را پاك مي كند اين دستور تاثيري بر صفحه هاي كثيف ندارد 
--صفحه كثيف صفحه اي است كه در حافظه تغيير يافته ولي به ديتا فايل منتقل نشده است و منتظر فرآيند چك پوينت و...است
GO
DECLARE @DB_ID INT
SET @DB_ID=DB_ID('Northwind')
DBCC FLUSHPROCINDB(@DB_ID)--پاك كردن كش مربوط به پروسيجرها و... يك ديتابيس خاص
GO
DBCC FREEPROCCACHE --پاك كردن كش مربوط به پروسيجرهاو .... به ازاي كليه بانك هاي اطلاعاتي مي باشد
GO
--------------------------------------------------------------------------------------------------------
--بررسي اطلاعات موجود در كش
USE Northwind
GO
DBCC FREEPROCCACHE --پاك كردن كش مربوط به پروسيجرهاو .... به ازاي كليه بانك هاي اطلاعاتي مي باشد
GO
SELECT * FROM Orders
GO
--كوئري كه از جدول سفارش ها گرفتم در كش موجود است
SELECT CP.cacheobjtype ,CP.size_in_bytes,ST.text
	FROM sys.dm_exec_cached_plans CP
		CROSS APPLY sys.dm_exec_sql_text(plan_handle) AS ST
			WHERE ST.text LIKE '%Orders%'
GO
--كوئري كه از جدول سفارش ها گرفتم در كش موجود است
SELECT C.sql,C.sqlbytes FROM sys.syscacheobjects C
GO
------------------
DBCC FREEPROCCACHE --پاك كردن كش مربوط به پروسيجرهاو .... به ازاي كليه بانك هاي اطلاعاتي مي باشد
GO
--محتواي كش نمايش داده شود
SELECT C.sql,C.sqlbytes FROM sys.syscacheobjects C
GO
--هر دستور تك تك اجرا شود
SELECT * FROM Orders WHERE ShipCountry='uk'
go
SELECT * FROM Orders WHERE ShipCountry='Uk'
go
SELECT * FROM orders WHERE ShipCountry='uk'
go
SELECT * FROM Orders WHERE  ShipCountry='uk'
GO
SELECT c.cacheobjtype , C.sql,C.sqlbytes FROM sys.syscacheobjects C
GO
DBCC FREEPROCCACHE --پاك كردن كش مربوط به پروسيجرهاو .... به ازاي كليه بانك هاي اطلاعاتي مي باشد
GO
--------------------------------------------------------------------------------------------------------
USE Northwind
GO
-- در پلن كش SP تاثير استفاده از 
GO
--حذف پروسيجر
DROP PROCEDURE SP2
GO
--ايجاد يك پروسيجر
CREATE PROC SP2
(
	@ShipCountry NVARCHAR(100)
)
AS
SELECT * FROM ORDERS 
	WHERE ShipCountry=@ShipCountry
GO
DBCC FREEPROCCACHE --پاك كردن كش مربوط به پروسيجرهاو .... به ازاي كليه بانك هاي اطلاعاتي مي باشد
GO
EXEC SP2 'UK'
EXEC SP2 'Uk'
GO
SELECT c.cacheobjtype , C.sql,C.sqlbytes FROM sys.syscacheobjects C
GO
EXEC SP2 'uK'
EXEC SP2 'uk'
GO
SELECT c.cacheobjtype , C.sql,C.sqlbytes FROM sys.syscacheobjects C
GO
EXEC SP2 'italy'
EXEC SP2 'germany'
GO
SELECT c.cacheobjtype , C.sql,C.sqlbytes FROM sys.syscacheobjects C
GO
