USE Northwind
GO
--بررسی وجود جدول 
IF OBJECT_ID('Orders2', 'U') IS NOT NULL 
	DROP TABLE Orders2
GO
--تهیه کپی از جدول
SELECT * INTO Orders2 FROM Orders  
GO
--بررسی تعداد رکوردهای جدول
SELECT COUNT(OrderID) FROM Orders
SELECT COUNT(OrderID) FROM Orders2 
GO
--بررسی ساختار جدول
SP_HELP Orders
GO
SP_HELP Orders2
GO
--بررسی ایندکس های هر دو جدول
SP_HELPINDEX Orders
GO
SP_HELPINDEX Orders2
GO
--نمايش كلي  ركوردها
--Show Execution Plane
SELECT * FROM Orders --داراي كلاستر ايندكس
SELECT * FROM Orders2--جدول به شكل هيپ مي باشد
GO
--نمايش يك ركورد خاص
--Show Execution Plane
SELECT * FROM Orders WHERE OrderID=10666 --داراي كلاستر ايندكس
SELECT * FROM Orders2 WHERE OrderID=10666 --جدول به شكل هيپ مي باشد
GO
/*
نتیجه گیری
--جداول هيپ معمولا براي بدست آوردن ركوردهاي زياد خوب هستند
--جداول هيپ براي بدست آوردن تعداد كمي ركورد مناسب نمي باشند
*/