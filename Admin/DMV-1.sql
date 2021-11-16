-- Count Of connections
SELECT @@CONNECTIONS

-- Count Of received packects under network connections
SELECT @@PACK_RECEIVED

-- Count Of sent packects under network connections
SELECT @@PACK_SENT

-- Count of total packets with error
SELECT @@PACKET_ERRORS

-- Count of total read from drive
SELECT @@TOTAL_READ

-- Count of total write from drive
SELECT @@TOTAL_WRITE

-- Count of total read/write packet with error
SELECT @@TOTAL_ERRORS

-- All of them with own SP// CPU,Runed Time,Packet read / write
EXEC sys.sp_monitor

-- Connection of instance
SELECT  *
  FROM  sys.dm_exec_connections;

-- Information about client version, client program name, client login time, login user, current session setting
SELECT  *
  FROM  sys.dm_exec_sessions;

-- query plan informations
SELECT TOP 5    total_worker_time / execution_count AS [Avg CPU Time], plan_handle, query_plan
  FROM  sys.dm_exec_query_stats AS qs
        CROSS APPLY sys.dm_exec_text_query_plan (qs.plan_handle, 0, -1)
 ORDER BY total_worker_time / execution_count DESC;
GO

-- With out functions use sys.dm_exec_sql_text
	--Step 1
	-- Identify current spid (session_id)
	SELECT @@SPID;
	GO

	-- Create activity
	WAITFOR DELAY '00:02:00';

	-- Step 2
	SELECT  t.*
	  FROM  sys.dm_exec_requests AS r
	        CROSS APPLY sys.dm_exec_sql_text (r.sql_handle) AS t
	 WHERE  session_id = 56; -- modify this value with your actual spid

-- runed request informations
SELECT  *
  FROM  sys.dm_exec_requests;

-- Information about Execution Plan by Statistic in rows per query
SELECT  *
  FROM  sys.dm_exec_query_stats;