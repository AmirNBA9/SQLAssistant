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

/*
We don't need system databases:

System Databases:
                  1) SystemResource --Hide
				  2) Master 
				  3) Model
				  4) MSDB
				  5) Tempdb
				  6) Distribution --Hide
*/