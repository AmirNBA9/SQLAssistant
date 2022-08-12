
/*01. Find*/
SELECT Status = CASE tr.status
                    WHEN 1 THEN 'Running'
                    WHEN 0 THEN 'Stopped'
                END, --
       [Default] = CASE tr.is_default
                       WHEN 1 THEN 'System TRACE'
                       WHEN 0 THEN 'User TRACE'
                   END, --
       login_name = COALESCE (se.login_name, se.login_name, 'No reader spid'), [Trace Path] = COALESCE (tr.path, tr.path, 'OLE DB Client Side Trace')
  FROM sys.traces tr
       LEFT JOIN sys.dm_exec_sessions se ON tr.reader_spid = se.session_id;


/*02. Stop trace*/
SELECT *
  FROM sys.traces
 WHERE path LIKE N'%audittrace_%';

-- Find the trace that is called audittrace.trc:
--Stop the trace
EXEC sys.sp_trace_setstatus @traceid = 1, @status = 0

--Delete the trace definition from the server
EXEC sys.sp_trace_setstatus @traceid = 1, @status = 2


/**/
-- Set the 'show advanced option' to '1'

USE master;
GO
EXEC sp_configure 'show advanced option', '1';


-- Then run reconfigure:

RECONFIGURE;

-- Then show all configuration options;

EXEC sp_configure;

-- Verify that the 'C2 Audit Mode' config_value and run_value fields are set to '1'. If they are - that is what needs to be changed. You should be able to run the code to set the config_value to '0' (disabled).

EXEC sp_configure 'c2 audit mode', '0';

-- If you run EXEC sp_configure; again it should show the config_value is '0' and the run_value is still '1'. To turn off the c2 audit trace, you need to have the run_value set to '0' as well. To get this, run:

EXEC RECONFIGURE with OVERRIDE;

-- If that doesn't do it, then restart the SQL SERVER and SQL AGENT services and the config_value will get picked up.