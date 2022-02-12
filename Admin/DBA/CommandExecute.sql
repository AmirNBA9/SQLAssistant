IF OBJECT_ID ('[dba].[CommandExecute]') IS NOT NULL
    DROP PROCEDURE dba.CommandExecute;
GO

SET QUOTED_IDENTIFIER ON;
GO

SET ANSI_NULLS ON;
GO

CREATE PROCEDURE dba.CommandExecute
    @DatabaseContext NVARCHAR(MAX), @Command NVARCHAR(MAX), @CommandType NVARCHAR(MAX), @Mode INT, @Comment NVARCHAR(MAX) = NULL, @DatabaseName NVARCHAR(MAX) = NULL, @SchemaName NVARCHAR(MAX) = NULL,
    @ObjectName      NVARCHAR(MAX)                                                                                        = NULL, @ObjectType NVARCHAR(MAX) = NULL, @IndexName NVARCHAR(MAX) = NULL, @IndexType INT = NULL, @StatisticsName NVARCHAR(MAX) = NULL, @PartitionNumber INT = NULL,
    @ExtendedInfo    XML                                                                                                  = NULL, @LockMessageSeverity INT = 16, @LogToTable NVARCHAR(MAX), @Execute NVARCHAR(MAX)
AS
    BEGIN

        ----------------------------------------------------------------------------------------------------
        --// Source:  https://ola.hallengren.com                                                        //--
        --// License: https://ola.hallengren.com/license.html                                           //--
        --// GitHub:  https://github.com/olahallengren/sql-server-maintenance-solution                  //--
        --// Version: 2020-01-26 14:06:53                                                               //--
        ----------------------------------------------------------------------------------------------------
        SET NOCOUNT ON;

        DECLARE @StartMessage NVARCHAR(MAX);
        DECLARE @EndMessage NVARCHAR(MAX);
        DECLARE @ErrorMessage NVARCHAR(MAX);
        DECLARE @ErrorMessageOriginal NVARCHAR(MAX);
        DECLARE @Severity INT;

        DECLARE @Errors TABLE (ID       INT           IDENTITY PRIMARY KEY,
                               Message  NVARCHAR(MAX) NOT NULL,
                               Severity INT           NOT NULL,
                               State    INT);

        DECLARE @CurrentMessage NVARCHAR(MAX);
        DECLARE @CurrentSeverity INT;
        DECLARE @CurrentState INT;
        DECLARE @sp_executesql NVARCHAR(MAX) = QUOTENAME (@DatabaseContext) + N'.sys.sp_executesql';
        DECLARE @StartTime DATETIME2;
        DECLARE @EndTime DATETIME2;
        DECLARE @ID INT;
        DECLARE @Error INT = 0;
        DECLARE @ReturnCode INT = 0;
        DECLARE @EmptyLine NVARCHAR(MAX) = CHAR (9);

        ----------------------------------------------------------------------------------------------------
        --// Check core requirements                                                                    //--
        ----------------------------------------------------------------------------------------------------
        IF NOT (SELECT compatibility_level FROM sys.databases WHERE database_id = DB_ID ()) >= 90
            BEGIN
                INSERT INTO @Errors (Message, Severity, State)
                SELECT 'The database ' + QUOTENAME (DB_NAME (DB_ID ())) + ' has to be in compatibility level 90 or higher.', 16, 1;
            END;

        IF NOT (SELECT uses_ansi_nulls FROM sys.sql_modules WHERE object_id = @@PROCID) = 1
            BEGIN
                INSERT INTO @Errors (Message, Severity, State)
                SELECT 'ANSI_NULLS has to be set to ON for the stored procedure.', 16, 1;
            END;

        IF NOT (SELECT uses_quoted_identifier
                  FROM sys.sql_modules
                 WHERE object_id = @@PROCID) = 1
            BEGIN
                INSERT INTO @Errors (Message, Severity, State)
                SELECT 'QUOTED_IDENTIFIER has to be set to ON for the stored procedure.', 16, 1;
            END;

        IF @LogToTable = 'Y'
       AND NOT EXISTS (SELECT *
                         FROM sys.objects objects
                              INNER JOIN sys.schemas schemas ON objects.schema_id = schemas.schema_id
                        WHERE objects.type = 'U'
                          AND schemas.name = 'dbo'
                          AND objects.name = 'CommandLog')
            BEGIN
                INSERT INTO @Errors (Message, Severity, State)
                SELECT 'The table CommandLog is missing. Download https://ola.hallengren.com/scripts/CommandLog.sql.', 16, 1;
            END;

        ----------------------------------------------------------------------------------------------------
        --// Check input parameters                                                                     //--
        ----------------------------------------------------------------------------------------------------
        IF @DatabaseContext IS NULL
        OR NOT EXISTS (SELECT *
                         FROM sys.databases
                        WHERE name = @DatabaseContext)
            BEGIN
                INSERT INTO @Errors (Message, Severity, State)
                SELECT 'The value for the parameter @DatabaseContext is not supported.', 16, 1;
            END;

        IF @Command IS NULL
        OR @Command = ''
            BEGIN
                INSERT INTO @Errors (Message, Severity, State)
                SELECT 'The value for the parameter @Command is not supported.', 16, 1;
            END;

        IF @CommandType IS NULL
        OR @CommandType = ''
        OR LEN (@CommandType) > 60
            BEGIN
                INSERT INTO @Errors (Message, Severity, State)
                SELECT 'The value for the parameter @CommandType is not supported.', 16, 1;
            END;

        IF @Mode NOT IN ( 1, 2 )
        OR @Mode IS NULL
            BEGIN
                INSERT INTO @Errors (Message, Severity, State)
                SELECT 'The value for the parameter @Mode is not supported.', 16, 1;
            END;

        IF @LockMessageSeverity NOT IN ( 10, 16 )
        OR @LockMessageSeverity IS NULL
            BEGIN
                INSERT INTO @Errors (Message, Severity, State)
                SELECT 'The value for the parameter @LockMessageSeverity is not supported.', 16, 1;
            END;

        IF @LogToTable NOT IN ( 'Y', 'N' )
        OR @LogToTable IS NULL
            BEGIN
                INSERT INTO @Errors (Message, Severity, State)
                SELECT 'The value for the parameter @LogToTable is not supported.', 16, 1;
            END;

        IF @Execute NOT IN ( 'Y', 'N' )
        OR @Execute IS NULL
            BEGIN
                INSERT INTO @Errors (Message, Severity, State)
                SELECT 'The value for the parameter @Execute is not supported.', 16, 1;
            END;

        ----------------------------------------------------------------------------------------------------
        --// Raise errors                                                                               //--
        ----------------------------------------------------------------------------------------------------
        DECLARE ErrorCursor CURSOR FAST_FORWARD FOR SELECT Message, Severity, State FROM @Errors ORDER BY ID ASC;

        OPEN ErrorCursor;

        FETCH ErrorCursor
         INTO @CurrentMessage, @CurrentSeverity, @CurrentState;

        WHILE @@FETCH_STATUS = 0
            BEGIN
                RAISERROR ('%s', @CurrentSeverity, @CurrentState, @CurrentMessage) WITH NOWAIT;

                RAISERROR (@EmptyLine, 10, 1) WITH NOWAIT;

                FETCH NEXT FROM ErrorCursor
                 INTO @CurrentMessage, @CurrentSeverity, @CurrentState;
            END;

        CLOSE ErrorCursor;
        DEALLOCATE ErrorCursor;

        IF EXISTS (SELECT * FROM @Errors WHERE Severity >= 16)
            BEGIN
                SET @ReturnCode = 50000;

                GOTO ReturnCode;
            END;

        ----------------------------------------------------------------------------------------------------
        --// Log initial information                                                                    //--
        ----------------------------------------------------------------------------------------------------
        SET @StartTime = SYSDATETIME ();
        SET @StartMessage = N'Date and time: ' + CONVERT (NVARCHAR, @StartTime, 120);

        RAISERROR ('%s', 10, 1, @StartMessage) WITH NOWAIT;

        SET @StartMessage = N'Database context: ' + QUOTENAME (@DatabaseContext);

        RAISERROR ('%s', 10, 1, @StartMessage) WITH NOWAIT;

        SET @StartMessage = N'Command: ' + @Command;

        RAISERROR ('%s', 10, 1, @StartMessage) WITH NOWAIT;

        IF @Comment IS NOT NULL
            BEGIN
                SET @StartMessage = N'Comment: ' + @Comment;

                RAISERROR ('%s', 10, 1, @StartMessage) WITH NOWAIT;
            END;

        IF @LogToTable = 'Y'
            BEGIN
                INSERT INTO dbo.CommandLog (DatabaseName, SchemaName, ObjectName, ObjectType, IndexName, IndexType, StatisticsName, PartitionNumber, ExtendedInfo, CommandType, Command, StartTime)
                VALUES (@DatabaseName, @SchemaName, @ObjectName, @ObjectType, @IndexName, @IndexType, @StatisticsName, @PartitionNumber, @ExtendedInfo, @CommandType, @Command, @StartTime);
            END;

        SET @ID = SCOPE_IDENTITY ();

        ----------------------------------------------------------------------------------------------------
        --// Execute command                                                                            //--
        ----------------------------------------------------------------------------------------------------
        IF @Mode = 1
       AND @Execute = 'Y'
            BEGIN
                EXECUTE @sp_executesql @stmt = @Command;

                SET @Error = @@ERROR;
                SET @ReturnCode = @Error;
            END;

        IF @Mode = 2
       AND @Execute = 'Y'
            BEGIN
                BEGIN TRY
                    EXECUTE @sp_executesql @stmt = @Command;
                END TRY
                BEGIN CATCH
                    SET @Error = ERROR_NUMBER ();
                    SET @ErrorMessageOriginal = ERROR_MESSAGE ();
                    SET @ErrorMessage = N'Msg ' + CAST(ERROR_NUMBER () AS NVARCHAR) + N', ' + ISNULL (ERROR_MESSAGE (), '');
                    SET @Severity = CASE
                                        WHEN ERROR_NUMBER () IN ( 1205, 1222 ) THEN @LockMessageSeverity
                                        ELSE 16
                                    END;

                    RAISERROR ('%s', @Severity, 1, @ErrorMessage) WITH NOWAIT;

                    IF NOT (ERROR_NUMBER () IN ( 1205, 1222 )
                        AND @LockMessageSeverity = 10)
                        BEGIN
                            SET @ReturnCode = ERROR_NUMBER ();
                        END;
                END CATCH;
            END;

        ----------------------------------------------------------------------------------------------------
        --// Log completing information                                                                 //--
        ----------------------------------------------------------------------------------------------------
        SET @EndTime = SYSDATETIME ();
        SET @EndMessage = N'Outcome: ' + CASE
                                             WHEN @Execute = 'N' THEN 'Not Executed'
                                             WHEN @Error = 0 THEN 'Succeeded'
                                             ELSE 'Failed'
                                         END;

        RAISERROR ('%s', 10, 1, @EndMessage) WITH NOWAIT;

        SET @EndMessage = N'Duration: ' + CASE
                                              WHEN (DATEDIFF (SECOND, @StartTime, @EndTime) / (24 * 3600)) > 0 THEN CAST((DATEDIFF (SECOND, @StartTime, @EndTime) / (24 * 3600)) AS NVARCHAR) + '.'
                                              ELSE ''
                                          END + CONVERT (NVARCHAR, DATEADD (SECOND, DATEDIFF (SECOND, @StartTime, @EndTime), '1900-01-01'), 108);

        RAISERROR ('%s', 10, 1, @EndMessage) WITH NOWAIT;

        SET @EndMessage = N'Date and time: ' + CONVERT (NVARCHAR, @EndTime, 120);

        RAISERROR ('%s', 10, 1, @EndMessage) WITH NOWAIT;

        RAISERROR (@EmptyLine, 10, 1) WITH NOWAIT;

        IF @LogToTable = 'Y'
            BEGIN
                UPDATE dbo.CommandLog
                   SET EndTime = @EndTime, ErrorNumber = CASE
                                                             WHEN @Execute = 'N' THEN NULL
                                                             ELSE @Error
                                                         END, ErrorMessage = @ErrorMessageOriginal
                 WHERE ID = @ID;
            END;

        ReturnCode:
        IF @ReturnCode <> 0
            BEGIN
                RETURN @ReturnCode;
            END;

    ----------------------------------------------------------------------------------------------------
    END;
GO