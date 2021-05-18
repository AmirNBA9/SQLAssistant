/*
	What is the performance bottleneck?
	Is there any blocking? If yes, who is the blocker?
	What are the queries which are executing currently?
	What is the name of the stored procedure running currently?
	Which statement in stored procedure is getting executed right now?
	Who is consuming CPU right now? What are the high CPU queries?
	Who is doing lots of IO right now?
*/

SELECT s.session_id
    ,r.STATUS
    ,r.blocking_session_id 'blocked by'
    ,r.wait_type
    ,wait_resource
    ,r.wait_time / (1000.0) 'Wait Time (in Sec)'
    ,r.cpu_time
    ,r.logical_reads
    ,r.reads
    ,r.writes
    ,r.total_elapsed_time / (1000.0) 'Elapsed Time (in Sec)'
    ,Substring(st.TEXT, (r.statement_start_offset / 2) + 1, (
            (
                CASE r.statement_end_offset
                    WHEN - 1
                        THEN Datalength(st.TEXT)
                    ELSE r.statement_end_offset
                    END - r.statement_start_offset
                ) / 2
            ) + 1) AS statement_text
    ,Coalesce(Quotename(Db_name(st.dbid)) + N'.' + Quotename(Object_schema_name(st.objectid, st.dbid)) + N'.' + 
     Quotename(Object_name(st.objectid, st.dbid)), '') AS command_text
    ,r.command
    ,s.login_name
    ,s.host_name
    ,s.program_name
    ,s.host_process_id
    ,s.last_request_end_time
    ,s.login_time
    ,r.open_transaction_count
FROM sys.dm_exec_sessions AS s
INNER JOIN sys.dm_exec_requests AS r ON r.session_id = s.session_id
CROSS APPLY sys.dm_exec_sql_text(r.sql_handle) AS st
WHERE r.session_id != @@SPID
ORDER BY r.cpu_time DESC
    ,r.STATUS
    ,r.blocking_session_id
    ,s.session_id