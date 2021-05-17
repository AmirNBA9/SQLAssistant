---------
-- Type 1
---------

DECLARE @document varchar(64);  
SELECT @document = 'Reflectors are vital safety' +  
                   ' components of your bicycle.';  
SELECT CHARINDEX('of', @document);  
GO

---------
-- Type 2
---------

DECLARE @document varchar(64);  
  
SELECT @document = 'Reflectors are vital safety' +  
                   ' components of your bicycle.';  
SELECT CHARINDEX('vital', @document, 5);  
GO  

---------
-- Type 3
---------

DECLARE @document varchar(64);  
  
SELECT @document = 'Reflectors are vital safety' +  
                   ' components of your bicycle.';  
SELECT CHARINDEX('bike', @document);  
GO

---------
-- Type 4
---------

USE tempdb;  
GO  
--perform a case sensitive search  
SELECT CHARINDEX ( 'TEST',  
       'This is a Test'  
       COLLATE Latin1_General_CS_AS);

USE tempdb;  
GO  
SELECT CHARINDEX ( 'Test',  
       'This is a Test'  
       COLLATE Latin1_General_CS_AS);  

---------
-- Type 5
---------

SELECT CHARINDEX('is', 'This is a string');

SELECT CHARINDEX('is', 'This is a string', 4);

SELECT TOP(1) CHARINDEX('at', 'This is a string') FROM dbo.Categories;


