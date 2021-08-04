SET QUOTED_IDENTIFIER ON;
SET ANSI_NULLS ON;
GO
ALTER PROC [dbo].[Json_HasData]
    @PackageProcessDetailItems NVARCHAR(MAX) = NULL, @IsEmptyData BIT OUTPUT
AS
BEGIN

    DECLARE @FirstRow NVARCHAR(MAX) = (SELECT TOP (1)   value FROM  OPENJSON (@PackageProcessDetailItems));
    DECLARE @ColumnCommand NVARCHAR(MAX);
    DECLARE @ColumnNullCommand NVARCHAR(MAX);
    DECLARE @Command NVARCHAR(MAX);

    -- A table for Json key,value and type
    DECLARE @Columns TABLE (Position INT IDENTITY PRIMARY KEY,
        ColumnName sysname NOT NULL UNIQUE,
        JsonDatatype INT NOT NULL,
        SqlDatatype VARCHAR(30) NOT NULL);

    -- Find datatypes
    INSERT INTO @Columns (ColumnName, JsonDatatype, SqlDatatype)
    SELECT  [key], type, CASE type
                             WHEN 0 -- NULL
                                 THEN 'varchar(1)'
                             WHEN 1 -- String value
                                 THEN 'nvarchar(2000)'
                             WHEN 2 -- Int, double, float
                                 THEN 'float'
                             WHEN 3 -- Boolean
                                 THEN 'bit'
                         /*4 and 5 is array and object*/
                         END
      FROM  OPENJSON (@FirstRow);

    -- Create table columns
    SET @ColumnCommand = N'(' + (   SELECT  CHAR (13) + CHAR (10) + CHAR (9) + ColumnName + ' ' + c.SqlDatatype + CASE
                                                                                                                      WHEN c.Position < COUNT (*) OVER ()
                                                                                                                          THEN ',' ELSE ''
                                                                                                                  END
                                      FROM  @Columns c
                                     ORDER BY c.Position
                                    FOR XML PATH (''), TYPE).value ('.', 'nvarchar(max)') + CHAR (13) + CHAR (10) + N')';

    -- Where statement table columns
    SET @ColumnNullCommand = N'' + (   SELECT   CHAR (13) + CHAR (10) + CHAR (9) + ColumnName + ' IS NULL AND'
                                         FROM   @Columns c
                                        ORDER BY c.Position
                                       FOR XML PATH (''), TYPE).value ('.', 'nvarchar(max)') + CHAR (13) + CHAR (10) + N'';
    SET @ColumnNullCommand = LEFT(@ColumnNullCommand, LEN (@ColumnNullCommand) - 5);

    -- Create table
    SET @Command = N'CREATE TABLE #Temp ' + @ColumnCommand + CHAR (13) + CHAR (10) + N' ';
    -- Insert command
    SET @Command = @Command + N'INSERT INTO #Temp SELECT * FROM OPENJSON(@PackageProcessDetailItems) WITH' + @ColumnCommand + CHAR (13) + CHAR (10) + N' ';

    -- Set output command
    SET @Command =
        @Command + N'Declare @Counter int = (SELECT Count(1) FROM #temp WHERE' + @ColumnNullCommand + CHAR (13) + CHAR (10) + N') ' + CHAR (13) + CHAR (10)
        + N' IF (@Counter = 0) SET @IsEmptyData = 0 ' + CHAR (13) + CHAR (10) + N'Else SET @IsEmptyData = 1 ';

    EXEC sp_executesql @Command, N'@PackageProcessDetailItems NVARCHAR(MAX), @IsEmptyData int OUTPUT', @PackageProcessDetailItems, @IsEmptyData = @IsEmptyData OUTPUT;

END;
GO
