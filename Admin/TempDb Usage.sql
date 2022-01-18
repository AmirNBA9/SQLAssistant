-- Find Time Data File Auto Grow 
DECLARE @current_tracefilename VARCHAR(500);
DECLARE @0_tracefilename VARCHAR(500);
DECLARE @indx INT;
SELECT @current_tracefilename = path
FROM sys.traces
WHERE is_default = 1;
SET @current_tracefilename = REVERSE(@current_tracefilename);
SELECT @indx = PATINDEX('%\%', @current_tracefilename);
SET @current_tracefilename = REVERSE(@current_tracefilename);
SET @0_tracefilename = LEFT(@current_tracefilename, LEN(@current_tracefilename) - @indx) + '\log.trc';
SELECT DatabaseName, 
       te.name, 
       Filename, 
       CONVERT(DECIMAL(10, 3), Duration / 1000000e0) AS TimeTakenSeconds, 
       StartTime, 
       EndTime, 
       (IntegerData * 8.0 / 1024) AS 'ChangeInSize MB', 
       ApplicationName, 
       HostName, 
       LoginName,*
FROM ::fn_trace_gettable(@0_tracefilename, DEFAULT) t
     INNER JOIN sys.trace_events AS te ON t.EventClass = te.trace_event_id
WHERE DatabaseName='tempdb' AND (trace_event_id >= 92 AND trace_event_id <= 95)
ORDER BY t.StartTime


GO


-- Search Query 
 SELECT TOP 10
   t.text as 'SQL Text', 
   st.execution_count , 
   ISNULL( st.total_elapsed_time / st.execution_count, 0 ) as 'AVG Excecution Time',
   st.total_worker_time / st.execution_count as 'AVG Worker Time',
   st.total_worker_time,
   st.max_logical_reads, 
   st.max_logical_writes, 
   st.creation_time,
   ISNULL( st.execution_count / DATEDIFF( second, st.creation_time, getdate()), 0 ) as 'Calls Per Second'
FROM sys.dm_exec_query_stats st
   CROSS APPLY sys.dm_exec_sql_text( st.sql_handle )  t
ORDER BY 
   st.total_elapsed_time DESC
