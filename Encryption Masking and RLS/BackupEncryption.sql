-- 1
-- Creates a database master key.   
-- The key is encrypted using the password "<master key password>"  
USE master;  
GO  
CREATE MASTER KEY ENCRYPTION BY PASSWORD = '<master key password>';  
GO

-- 2
Use Master  
GO  
CREATE CERTIFICATE MyTestDBBackupEncryptCert  
   WITH SUBJECT = 'MyTestDB Backup Encryption Certificate';  
GO

-- 3
BACKUP DATABASE [MyTestDB]  
TO DISK = N'C:\Program Files\Microsoft SQL Server\MSSQL13.MSSQLSERVER\MSSQL\Backup\MyTestDB.bak'  
WITH  
  COMPRESSION,  
  ENCRYPTION   
   (  
   ALGORITHM = AES_256,  
   SERVER CERTIFICATE = MyTestDBBackupEncryptCert  
   ),  
  STATS = 10  
GO
