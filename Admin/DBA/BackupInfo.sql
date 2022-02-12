IF OBJECT_ID ('[dba].[BackupInfo]') IS NOT NULL
    DROP PROCEDURE dba.BackupInfo;
GO

SET QUOTED_IDENTIFIER ON;
GO

SET ANSI_NULLS ON;
GO

CREATE PROCEDURE dba.BackupInfo
    @DBName sysname = NULL
AS
    BEGIN
        SELECT @DBName = ISNULL (@DBName, DB_NAME ());

        SELECT CAST(s.database_name AS CHAR(20)) AS DB, m.physical_device_name, --
               CAST(CAST(s.backup_size / (1024 * 1024) AS INT) AS CHAR(12)) AS MBSize, CAST(DATEDIFF (SECOND, s.backup_start_date, s.backup_finish_date) AS CHAR(4)) AS SecsTaken, --
               s.backup_start_date, CAST(s.first_lsn AS CHAR(30)) AS first_lsn, CAST(s.last_lsn AS CHAR(30)) AS last_lsn, --
               CASE s.type
                   WHEN 'D' THEN 'Full'
                   WHEN 'I' THEN 'Diff'
                   WHEN 'L' THEN 'TLog'
               END AS BackupType
          FROM msdb.dbo.backupset s
               INNER JOIN msdb.dbo.backupmediafamily m ON s.media_set_id = m.media_set_id
                                                      AND s.backup_start_date > DATEADD (DAY, -7, GETDATE ())
         WHERE s.database_name = @DBName
         ORDER BY DB, s.backup_start_date DESC /*, BackupType*/;
    END;
GO