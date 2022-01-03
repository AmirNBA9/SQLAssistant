
-- Check AutoShrink ON Database
/*Autoshrink working on engine for 2012 or upper than*/

DECLARE @DataBaseName NVARCHAR(100);
DECLARE @i INT = 1;
DECLARE @Max_Database_id INT =
        (
            SELECT MAX(database_id) FROM sys.databases
        );

WHILE @i < @Max_Database_id
BEGIN
    SELECT @DataBaseName = name
    FROM sys.databases
    WHERE database_id = @i;

    SELECT DATABASEPROPERTYEX(@DataBaseName, 'IsAutoShrink') AS IsAutoShrink; -- 0-->Not true 1-->True

    SET @i += 1;
END;