/*
Before Detach database
1. Check rout of files and save them
2. Create one full backup
3. CheckDB integrity DBCC CHECKDB
*/

--DBCC CHECKDB

ALTER DATABASE TestDB SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
GO

USE master;

EXEC master.sys.sp_detach_db @dbname = 'TestDB';