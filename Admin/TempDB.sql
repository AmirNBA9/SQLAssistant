/*Step1: Find*/

SELECT
    [owt].[session_id],
    [owt].[exec_context_id],
    [owt].[wait_duration_ms],
    [owt].[wait_type],
    [owt].[blocking_session_id],
    [owt].[resource_description], --
    CASE [owt].[wait_type]
        WHEN N'CXPACKET' THEN
            RIGHT ([owt].[resource_description],
            CHARINDEX (N'=', REVERSE ([owt].[resource_description])) - 1)
        ELSE NULL
    END AS [Node ID],
    [es].[program_name],
    [est].text,
    [er].[database_id],
    [eqp].[query_plan],
    [er].[cpu_time]
FROM sys.dm_os_waiting_tasks [owt]
INNER JOIN sys.dm_exec_sessions [es] ON
    [owt].[session_id] = [es].[session_id]
INNER JOIN sys.dm_exec_requests [er] ON
    [es].[session_id] = [er].[session_id]
OUTER APPLY sys.dm_exec_sql_text ([er].[sql_handle]) [est]
OUTER APPLY sys.dm_exec_query_plan ([er].[plan_handle]) [eqp]
WHERE
    [es].[is_user_process] = 1
ORDER BY
    [owt].[session_id],
    [owt].[exec_context_id];
GO

/*Step 2: Add tempdb file*/

ALTER DATABASE TempDB
	ADD FILE (Name = 'TempDB9', FILENAME = 'C:\TempDB\TempDB9.ndf', SIZE = 100MB, FILEGROWTH = 64MB)

/*MOVE FILE (This example is not optimize tempdb)*/
ALTER DATABASE TempDB
	MODIFY FILE (Name = 'Tempdev', FILENAME = 'D:\TempDB\Tempdev.mdf', SIZE = 128MB, FILEGROWTH = 128MB)

ALTER DATABASE TempDB
	MODIFY FILE (Name = 'TempDB9', FILENAME = 'D:\TempDB\TempDB9.ndf', SIZE = 128MB, FILEGROWTH = 128MB)

ALTER DATABASE TempDB
	MODIFY FILE (Name = 'Templog', FILENAME = 'D:\TempDB\Templog.ldf', SIZE = 128MB, FILEGROWTH = 128MB)