IF OBJECT_ID('[dba].[CurrentSPIDQuery]') IS NOT NULL
	DROP PROCEDURE [dba].[CurrentSPIDQuery];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE       PROCEDURE [dba].[CurrentSPIDQuery]
    @SPID INT
AS
BEGIN
    DECLARE @stmt_start INT, @stmt_end INT, @sql_handle BINARY(20);

    SELECT TOP 1    @sql_handle = sql_handle, --
        @stmt_start = CASE stmt_start
                          WHEN 0
                              THEN 0 ELSE stmt_start / 2
                      END, --
        @stmt_end = CASE stmt_end
                        WHEN -1
                            THEN -1 ELSE stmt_end / 2
                    END
      FROM  sys.sysprocesses
     WHERE  spid = @SPID
     ORDER BY ecid;

    SELECT  SUBSTRING(text, COALESCE(NULLIF(@stmt_start, 0), 1), --
                CASE @stmt_end
                    WHEN -1
                        THEN DATALENGTH(text) ELSE (@stmt_end - @stmt_start)
                END)
      FROM  ::fn_get_sql(@sql_handle);

END;
GO
