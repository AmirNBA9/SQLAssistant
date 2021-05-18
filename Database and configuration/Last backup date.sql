SELECT 	B.name as Database_Name, ISNULL(STR(ABS(DATEDIFF(day, GetDate(), 
	MAX(Backup_finish_date)))), 'NEVER') as DaysSinceLastBackup,
	ISNULL(Convert(char(10), MAX(backup_finish_date), 101), 'NEVER') as LastBackupDate
	FROM master.dbo.sysdatabases B LEFT OUTER JOIN msdb.dbo.backupset A 
	ON A.database_name = B.name AND A.type = 'D' GROUP BY B.Name ORDER BY B.name