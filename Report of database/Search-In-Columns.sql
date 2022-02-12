DECLARE @SearchStr NVARCHAR(100);

SET @SearchStr = N'83.';

-- Copyright © 2002 Narayana Vyas Kondreddi. All rights reserved.
-- Purpose: To search all columns of all tables for a given search string
-- Written by: Narayana Vyas Kondreddi
-- Site: http://vyaskn.tripod.com
-- Updated and tested by Tim Gaunt
-- http://www.thesitedoctor.co.uk
-- http://blogs.thesitedoctor.co.uk/tim/2010/02/19/Search+Every+Table+And+Field+In+A+SQL+Server+Database+Updated.aspx
-- Tested on: SQL Server 7.0, SQL Server 2000, SQL Server 2005 and SQL Server 2010
-- Date modified: 03rd March 2011 19:00 GMT

--CREATE TABLE #Results (ColumnName nvarchar(370), ColumnValue nvarchar(3630))
SET NOCOUNT ON;

DECLARE @TableName NVARCHAR(256), @ColumnName NVARCHAR(128), @SearchStr2 NVARCHAR(110);

SET @TableName = N'';
SET @SearchStr2 = QUOTENAME ('%' + @SearchStr + '%', '''');

WHILE @TableName IS NOT NULL
    BEGIN
        SET @ColumnName = N'';
        SET @TableName = N'[dbo].[tbl_Reserv]';

        WHILE (@TableName IS NOT NULL) AND (@ColumnName IS NOT NULL)
            BEGIN
                SET @ColumnName = (SELECT MIN (QUOTENAME (COLUMN_NAME))
                                     FROM INFORMATION_SCHEMA.COLUMNS
                                    WHERE TABLE_SCHEMA = PARSENAME (@TableName, 2)
                                      AND TABLE_NAME = PARSENAME (@TableName, 1)
                                      AND DATA_TYPE IN ( 'char', 'varchar', 'nchar', 'nvarchar', 'int', 'decimal' )
                                      AND QUOTENAME (COLUMN_NAME) > @ColumnName);

                IF @ColumnName IS NOT NULL
                    BEGIN
                        INSERT INTO #Results
                        EXEC ('SELECT ''' + @TableName + '.' + @ColumnName + ''', LEFT(' + @ColumnName + ', 3630) FROM ' + @TableName + ' (NOLOCK) ' + ' WHERE ' + @ColumnName + ' LIKE ' + @SearchStr2);
                    END;
            END;
    END;

SELECT ColumnName, ColumnValue
  FROM #Results;

DROP TABLE #Results;