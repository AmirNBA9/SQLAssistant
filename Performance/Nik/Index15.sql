--تاثیر درج و حذف رکوردها در ایندکس ها
--	هنگام درج به روز رساني و حذف ركوردها ايندكس هاي آن نيز به روز مي شود
-- Non Clustered indexes must be updated (maintained) 
-- immediately when the main table is modified:
USE Northwind
GO
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
