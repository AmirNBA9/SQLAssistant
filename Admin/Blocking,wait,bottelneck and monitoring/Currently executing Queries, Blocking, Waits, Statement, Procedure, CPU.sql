/*
	What is the performance bottleneck?
	Is there any blocking? If yes, who is the blocker?
	What are the queries which are executing currently?
	What is the name of the stored procedure running currently?
	Which statement in stored procedure is getting executed right now?
	Who is consuming CPU right now? What are the high CPU queries?
	Who is doing lots of IO right now?
*/

SELECT S.session_id, R.status, R.blocking_session_id AS 'blocked by', R.wait_type, R.wait_resource, R.wait_time / (1000.0) AS 'Wait Time (in Sec)', R.wait_time / (60000.0) AS 'Wait Time (in Min)',
       R.cpu_time, R.logical_reads, R.reads, R.writes, R.total_elapsed_time / (1000.0) AS 'Elapsed Time (in Sec)', R.total_elapsed_time / (60000.0) AS 'Elapsed Time (in Min)',
       (R.total_elapsed_time / (60000.0)) / 60 AS 'Elapsed Time (in Houre)', SUBSTRING (ST.text, (R.statement_start_offset / 2) + 1, ((CASE R.statement_end_offset
                                                                                                                                       WHEN -1 THEN DATALENGTH (ST.text)
                                                                                                                                       ELSE R.statement_end_offset
                                                                                                                                   END - R.statement_start_offset) / 2) + 1) AS statement_text,
       COALESCE (QUOTENAME (DB_NAME (ST.dbid)) + N'.' + QUOTENAME (OBJECT_SCHEMA_NAME (ST.objectid, ST.dbid)) + N'.' + QUOTENAME (OBJECT_NAME (ST.objectid, ST.dbid)), '') AS command_text, R.command,
       S.login_name, S.host_name, S.program_name, S.host_process_id, S.last_request_end_time, S.login_time, R.open_transaction_count
  FROM sys.dm_exec_sessions AS S
       INNER JOIN sys.dm_os_waiting_tasks AS OWT ON OWT.session_id = S.session_id
       INNER JOIN sys.dm_exec_requests AS R ON R.session_id = S.session_id
       CROSS APPLY sys.dm_exec_sql_text (R.sql_handle) AS ST
 WHERE R.session_id != @@SPID
 ORDER BY R.cpu_time DESC, R.status, R.blocking_session_id, S.session_id;
GO

/*
Find Query plan

*/
SELECT owt.session_id, owt.exec_context_id, owt.wait_duration_ms, owt.wait_type, owt.blocking_session_id, owt.resource_description, --
       CASE owt.wait_type
           WHEN N'CXPACKET' THEN RIGHT(owt.resource_description, CHARINDEX (N'=', REVERSE (owt.resource_description)) - 1)
           ELSE NULL
       END AS [Node ID], es.program_name, est.text, er.database_id, eqp.query_plan, er.cpu_time
  FROM sys.dm_os_waiting_tasks owt
       INNER JOIN sys.dm_exec_sessions es ON owt.session_id = es.session_id
       INNER JOIN sys.dm_exec_requests er ON es.session_id = er.session_id
       OUTER APPLY sys.dm_exec_sql_text (er.sql_handle) est
       OUTER APPLY sys.dm_exec_query_plan (er.plan_handle) eqp
 WHERE es.is_user_process = 1
 ORDER BY owt.session_id, owt.exec_context_id;
GO

--DBCC INPUTBUFFER (SPID)