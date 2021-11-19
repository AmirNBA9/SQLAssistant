--
DECLARE @SessionId INT 
SELECT TOP 1 @SessionId = der.session_id FROM sys.dm_exec_requests der
WHERE der.blocking_session_id > 0

SELECT * FROM sys.dm_exec_sessions des
WHERE des.session_id = @SessionId

-- If find blocking, kill it