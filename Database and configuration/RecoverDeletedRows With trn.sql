-- Create a sample database
USE Master    
GO    
CREATE DATABASE [RecoverDeletedData]    
ON PRIMARY    
	( NAME = N'RecoverDeletedData',FILENAME = N'D:\Data\RecoverDeletedData.mdf',SIZE = 4096KB, FILEGROWTH = 1024KB )     
LOG ON     
	( NAME = N'RecoverDeletedData_log', FILENAME = N'D:\Data\RecoverDeletedData.ldf', SIZE = 1024KB, FILEGROWTH = 10%)     
GO 

-- Create a table for our environment
USE RecoverDeletedData     
GO 
CREATE TABLE [Friends] (    
[Sr.No] INT IDENTITY(1,1),    
[Name] varchar (50),    
[City] varchar (50));  

-- let’s insert some values into it    
INSERT INTO Friends VALUES ('IanRox', 'Delhi')     
	,('Jim', 'New York')    
	,('Catherine', 'Las Vegas')     
	,('John', 'California')     
	,('Katie', 'Mexico')    
	,('Sabrina', 'Indiana')     
	,('Alfred', 'Hamburg')     
	,('Vaibhav', 'Bangalore')     
	,('Vijeta', 'Mumbai')     
	,('YashRox', 'Sultanpur')  

-- We will take full backup of database “RecoverDeletedData”
USE RecoverDeletedData     
GO     
BACKUP DATABASE [RecoverDeletedData]     
TO DISK = N'D:\Data\RDDFull.bak'     
WITH NOFORMAT, NOINIT, NAME = N'RecoverDeletedData-Full Database Backup',     
SKIP, NOREWIND, NOUNLOAD, STATS = 10     
GO

-- Now we will go ahead and delete some rows so that we can recover them with the help of LSNs.
USE RecoverDeletedData     
GO     
DELETE Friends     
WHERE [Sr.No] > 5    
GO

-- Now check the “friends” again FROM below query:
SELECT * FROM friends
GO

-- Now take transaction log backup of the database. USE RecoverDeletedData  
BACKUP LOG [RecoverDeletedData]     
TO DISK = N'D:\Data\RDDTrLog.trn'     
WITH NOFORMAT, NOINIT,     
NAME = N'RecoverDeletedData-Transaction Log Backup',     
SKIP, NOREWIND, NOUNLOAD, STATS = 10     
GO

-- Now to recover deleted rows we must gather information for deleted rows. To gather information about deleted rows we can run below query-
USE RecoverDeletedData     
GO     
SELECT [Current LSN], [Transaction ID], Operation, Context, AllocUnitName     
FROM     
fn_dblog(NULL, NULL)    
WHERE Operation = 'LOP_DELETE_ROWS'

-- We will find exact time when rows got deleted with below query using Transaction ID
SELECT [Current LSN], Operation, [Transaction ID], [Begin Time], [Transaction Name], [Transaction SID]    
	FROM fn_dblog(NULL, NULL)    
   WHERE [Transaction ID] = '0000:00000364'    
		AND [Operation] = 'LOP_BEGIN_XACT'  
		-- 00000025:00000123:0001 /*Save Current LSN for this result*/

-- We will proceed with restore operation to recover deleted rows with below query:
RESTORE DATABASE RecoverDeletedData_COPY FROM     
DISK = 'D:\Data\RDDFull.bak'     
WITH     
MOVE 'RecoverDeletedData' TO 'D:\db\RecoverDeletedData.mdf',     
MOVE 'RecoverDeletedData_log' TO 'D:\db\RecoverDeletedData_log.ldf',     
REPLACE, NORECOVERY;     
GO

-- We will apply transaction log to restore deleted rows using LSN "saved"
USE RecoverDeletedData     
GO     
RESTORE LOG RecoverDeletedData_COPY   
FROM DISK = N'D:\Data\RDDTrLog.trn'   
WITH STOPBEFOREMARK = 'lsn:0x00000025:00000123:0001' /*Here one thing we need to remember that the LSN values are in hexadecimal form and for restoring with LSN value we need it in decimal form. To convert it to decimal form just put 0x before LSN like below in stopbeforemark clause*/

-- Check that our deleted records are back in RecoverDeletedData_Copy Database
USE RecoverDeletedData_Copy
GO
SELECT * FROM friends