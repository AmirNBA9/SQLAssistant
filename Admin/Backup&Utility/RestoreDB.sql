USE master;
GO

DECLARE @DB NVARCHAR(1000) = N'TestDB'
DECLARE @SQL NVARCHAR(MAX)

SET @SQL = N'
RESTORE DATABASE ['+@DB+'] 
FROM DISK = N''D:\New folder\'+@DB+'.bak'' -- Check Backup name
WITH FILE = 1, MOVE N'''+@DB+'''
               TO N''D:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\DATA\'+@DB+'.mdf'',
     MOVE N'''+@DB+'_log''
     TO N''D:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\DATA\'+@DB+'_log.ldf'', NOUNLOAD, STATS = 5;'
PRINT @SQL
--EXEC (@SQL)
GO