DECLARE @Db NVARCHAR(100) = NULL;
DECLARE @Id INT = 5;
DECLARE @Str NVARCHAR(MAX);

WHILE 1 = 1
    BEGIN
        SELECT @Db = name
          FROM sys.databases
         WHERE recovery_model_desc = 'simple' AND database_id > 4

        IF @Id = 48
            BREAK;

        PRINT CONVERT(NVARCHAR(10),@Id) + ' ' + @Db;

        SET @Str = N'ALTER DATABASE [' + @Db + N'] SET RECOVERY FULL WITH NO_WAIT';
		SET @Id = @Id + 1
        EXEC (@Str);
    END;
