USE [master];
GO

ALTER DATABASE [Faraz_sg3]
	SET RECOVERY BULK_LOGGED
	WITH NO_WAIT;
GO

USE Faraz_sg3;
GO
-- EXEC sp_MSforeachtable @command1 = "ALTER INDEX ALL ON '?' REBUILD";
EXEC sp_MSforeachtable @command1 = "print '?' DBCC DBREINDEX ('?', ' ', 80)";

GO

EXEC sp_updatestats;
GO

USE [master];
GO

ALTER DATABASE [Faraz_sg3]
	SET RECOVERY FULL
	WITH NO_WAIT;