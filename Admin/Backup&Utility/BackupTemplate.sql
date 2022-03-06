
BACKUP <BackupType , nvarchar(50) , DATABASE> <Database_Name , nvarchar(128) , DBName>
    TO DISK = '<FileName , nvarchar(255) , C:\Backup\><Database_Name , nvarchar(128) , DBName>.BAK'
	WITH INIT , <CompressionType , nvarchar(50) , COMPRESSION>