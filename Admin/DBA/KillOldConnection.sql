DECLARE @SQL VARCHAR(MAX);

WITH t
AS
    (SELECT S.spid
       FROM sys.sysprocesses AS S
      WHERE S.spid > 70
        AND DATEDIFF (MINUTE, S.last_batch, GETDATE ()) >= 2)
SELECT @SQL = @SQL + 'KILL' + CAST(t.spid AS VARCHAR(10)) + ';' + CHAR (13)
  FROM t;

--EXEC sys.sp_executesql @SQL;

PRINT @SQL;