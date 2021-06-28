-- Using While loop
DECLARE @i INT = 0;
WHILE (@i < 100)
BEGIN
    PRINT @i;
    SET @i = @i + 1;
END;
GO

-- While loop with min aggregate function usage
DECLARE @ID AS INT;
SET @ID = (SELECT   MIN (ID) FROM   [TABLE]);
WHILE @ID IS NOT NULL
BEGIN
    PRINT @ID;
    SET @ID = (SELECT   MIN (ID) FROM   [TABLE] WHERE   ID > @ID);
END;