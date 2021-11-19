SELECT
	B.name AS Database_Name
   ,ISNULL(STR(ABS(DATEDIFF(DAY, GETDATE(),
	MAX(Backup_finish_date)))), 'NEVER') AS DaysSinceLastBackup
   ,ISNULL(CONVERT(CHAR(10), MAX(backup_finish_date), 101), 'NEVER') AS LastBackupDate
FROM master.dbo.sysdatabases B
	LEFT OUTER JOIN msdb.dbo.backupset A ON A.Database_Name = B.name AND A.type = 'D'
GROUP BY B.name
ORDER BY B.name