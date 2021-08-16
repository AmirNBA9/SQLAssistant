-- Active or deactive feature on database
EXEC sp_fulltext_database 'enable'

-- Check fulltext on database
SELECT SERVERPROPERTY('IsFullTextInstalled')


SELECT name, DATABASEPROPERTY(name,'IsFulltextEnabled')
FROM master..sysdatabases where dbid > 4



-- Create a table and working fulltext on table
Select * from Product.Descriptions

SELECT FULLTEXTCATALOGPROPERTY('SearchProductName', 'PopulateStatus') AS Status
SELECT FULLTEXTCATALOGPROPERTY('SearchProductName', 'PopulateStatus') AS Status
SELECT FULLTEXTCATALOGPROPERTY('SearchCatalogLevel4', 'PopulateStatus') AS Status
SELECT FULLTEXTCATALOGPROPERTY('Mag_Title_Note', 'PopulateStatus') AS Status

--Example - Run a full population on a table
ALTER FULLTEXT INDEX ON Product.descriptions  
   START FULL POPULATION; 

--Example - Alter a full-text index to use automatic change tracking
ALTER FULLTEXT INDEX ON Product.descriptions SET CHANGE_TRACKING AUTO;  
GO  

--Example - Run a manual population
ALTER FULLTEXT INDEX ON Product.descriptions START UPDATE POPULATION; 
GO

-- Search text with fulltext atrribute CONTAINS
SELECT ProductName, ProductInfo,ProductID
FROM Product.descriptions  
WHERE CONTAINS(ProductName, N'اکبرجوجه')