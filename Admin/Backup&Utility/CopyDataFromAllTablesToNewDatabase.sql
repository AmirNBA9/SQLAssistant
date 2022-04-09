/*Copy data from all tables on new database*/


CREATE DATABASE Test
GO
USE Northwind

EXEC sp_MSforeachtable 'SELECT * INTO Test.?  FROM ?'