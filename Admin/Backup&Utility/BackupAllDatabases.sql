/*
Create Backup from all database in an instance
*/
EXEC sp_msForEachDB 
'IF ''?'' != ''TempDB''
BEGIN
   PRINT ''?'' 
   BACKUP DATABASE [?] TO DISK = ''C:\Backup\?.bak'' WITH INIT , CHECKSUM , COMPRESSION
END
'