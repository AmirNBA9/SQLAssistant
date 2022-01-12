/*Clear log file*/
USE LoyaltyDW;
GO

-- Truncate the log by changing the database recovery model to SIMPLE.
ALTER DATABASE LoyaltyDW
	SET RECOVERY SIMPLE;
GO

-- Shrink the truncated log file to 1 MB.
DBCC SHRINKFILE(LoyaltyDW_log, 1);
GO

-- Reset the database recovery model.
ALTER DATABASE LoyaltyDW
	SET RECOVERY FULL;
GO

/*Check open tarnsaction on database*/
DBCC OPENTRAN;
GO

/*Check logical and physical integrity of all the objects in the specified database by performing*/
-- Check the current database. 

DBCC CHECKDB;
GO

-- Check the AdventureWorks2012 database without nonclustered indexes.    
DBCC CHECKDB(AdventureWorks2012, NOINDEX);
GO

-- The following example checks the current database and suppresses all informational messages.
DBCC CHECKDB WITH NO_INFOMSGS;
GO