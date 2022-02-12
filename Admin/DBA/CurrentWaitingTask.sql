IF OBJECT_ID('[dba].[CurrentWaitingTask]') IS NOT NULL
	DROP PROCEDURE [dba].[CurrentWaitingTask];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE       PROCEDURE [dba].[CurrentWaitingTask]
AS
BEGIN
    SELECT  [owt].[session_id] AS [SPID], [owt].[exec_context_id] AS [Thread], [ot].[scheduler_id] AS [Scheduler], [owt].[wait_duration_ms] AS [wait_ms],
        [owt].[wait_type], [owt].[blocking_session_id] AS [Blocking SPID], [owt].[resource_description],
        CASE [owt].[wait_type]
            WHEN N'CXPACKET'
                THEN RIGHT([owt].[resource_description], CHARINDEX(N'=', REVERSE([owt].[resource_description])) - 1)ELSE NULL
        END AS [Node ID], [eqmg].[dop] AS [DOP], [er].[database_id] AS [DBID],
        --CAST('https://www.sqlskills.com/help/waits/' + [owt].[wait_type] AS XML) AS [Help/Info URL], 
        [est].text, [eqp].[query_plan]
      FROM  sys.dm_os_waiting_tasks [owt]
            INNER JOIN sys.dm_os_tasks [ot] ON [owt].[waiting_task_address] = [ot].[task_address]
            INNER JOIN sys.dm_exec_sessions [es] ON [owt].[session_id] = [es].[session_id]
            INNER JOIN sys.dm_exec_requests [er] ON [es].[session_id] = [er].[session_id]
            FULL JOIN sys.dm_exec_query_memory_grants [eqmg] ON [owt].[session_id] = [eqmg].[session_id]
            OUTER APPLY sys.dm_exec_sql_text([er].[sql_handle]) [est]
            OUTER APPLY sys.dm_exec_query_plan([er].[plan_handle]) [eqp]
     WHERE  [es].[is_user_process] = 1 AND  owt.wait_type <> 'CXPACKET' AND owt.wait_type <> 'CXCONSUMER'
     ORDER BY [owt].[session_id], [owt].[exec_context_id];
END;

GO
