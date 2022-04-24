/*
Before Detach database
1. Check rout of files and save them
2. Create one full backup
3. CheckDB integrity DBCC CHECKDB
4. Drop Connection
5. Set singleuser
6. Detach
*/

--DBCC CHECKDB

ALTER DATABASE TestDB SET SINGLE_USER WITH ROLLBACK IMMEDIATE; --Detach with no wait
GO

USE master;
ALTER DATABASE TestDB SET SINGLE_USER WITH ROLLBACK AFTER 2 Seconds;

GO
ALTER DATABASE TestDB SET MULTI_USER

ALTER DATABASE TestDB 
   SET OFFLINE;

--ALTER DATABASE TestDB 
--   SET ONLINE;

USE master;

EXEC master.sys.sp_detach_db @dbname = 'TestDB';