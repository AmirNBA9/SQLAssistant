/*We have a senario for using Truncate table*/
Use master
GO

-- Create a database
Create Database MyDatabase
GO
Alter Database MyDatabase Set Recovery Simple;
GO

-- Create a new table
Use MyDatabase
GO

Create Table MyTable

(ID Int Identity Not Null, MyColumn Char(8000) Default 'Truncate Table')


-- insert 10000 row data in table
Set Nocount On
GO

Insert Into MyTable Default Values
GO 10000

-- check result
Select Count(*) As N'RowCount' From MyTable

-- Trancate table in transaction with check count of table
Begin Transaction

Truncate Table MyTable

Select Count(*) As N'RowCount' From MyTable


--- Now rollback transaction and check result
Rollback Transaction

Select Count(*) As N'RowCount' From MyTable