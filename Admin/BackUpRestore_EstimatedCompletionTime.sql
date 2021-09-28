-- Find how much time elapse Backup etimate to finish or restore estimated completion_time
SELECT  r.session_id, CONVERT (NVARCHAR(255), DB_NAME (r.database_id)) AS [DATABASE], a.text AS Query, --
    CASE r.command
        WHEN 'BACKUP DATABASE'
            THEN 'Database Backup'
        WHEN 'RESTORE DATABASE'
            THEN 'Database Restore'
        WHEN 'RESTORE VERIFYON'
            THEN 'Database Restore Verification'
        WHEN 'RESTORE HEADERON'
            THEN 'Database Restore Verification - Header' ELSE 'LOG'
    END AS [type], --
    start_time AS [started], DATEADD (SECOND, estimated_completion_time / 1000, GETDATE ()) AS [Est. COMPLETION TIME],
    DATEDIFF (SECOND, start_time, (DATEADD (SECOND, estimated_completion_time / 1000, GETDATE ()))) - wait_time / 1000 AS [Seconds LEFT],
    DATEDIFF (SECOND, start_time, (DATEADD (SECOND, estimated_completion_time / 1000, GETDATE ()))) AS [Est. Wait TIME() Seconds],
    CONVERT (VARCHAR(5), CAST((percent_complete) AS DECIMAL(4, 1))) AS [% Complete], GETDATE () AS [CURRENT TIME]
  FROM  sys.dm_exec_requests r
        CROSS APPLY sys.dm_exec_sql_text (r.sql_handle) a
 WHERE  command IN ( 'BACKUP DATABASE', 'BACKUP LOG', 'RESTORE DATABASE', 'RESTORE VERIFYON', 'RESTORE HEADERON' );
GO