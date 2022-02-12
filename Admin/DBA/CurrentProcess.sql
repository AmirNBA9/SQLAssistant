IF OBJECT_ID('[dba].[CurrentProcess]') IS NOT NULL
	DROP FUNCTION [dba].[CurrentProcess];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE         FUNCTION [dba].[CurrentProcess] (@SPID INT = 0)
RETURNS TABLE
AS
RETURN (   SELECT TOP 50    P.spid, DEST.text,
               RIGHT(CONVERT(VARCHAR, DATEADD(ms, DATEDIFF(ms, P.last_batch, GETDATE()), '1900-01-01'), 121), 12) AS 'batch_duration', P.program_name,
               P.hostname, P.loginame
             --, *
             FROM   master.dbo.sysprocesses P
                    OUTER APPLY sys.dm_exec_sql_text(sql_handle) AS DEST
            WHERE   P.spid > 50
               --and      P.status not in ('background', 'sleeping')
               --and      P.cmd not in ('AWAITING COMMAND'
               --                    ,'MIRROR HANDLER'
               --                    ,'LAZY WRITER'
               --                    ,'CHECKPOINT SLEEP'
               --                    ,'RA MANAGER')
               AND  (NULLIF(@SPID, 0) IS NULL OR P.spid = @SPID)
            ORDER BY batch_duration DESC);
GO
