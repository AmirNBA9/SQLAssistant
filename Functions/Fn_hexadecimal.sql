CREATE FUNCTION fn_hexadecimal (@binvalue VARBINARY(256))
RETURNS VARCHAR(514)
AS
    BEGIN
        DECLARE @charvalue VARCHAR(514);
        DECLARE @i INT;
        DECLARE @length INT;
        DECLARE @hexstring CHAR(16);

        SELECT @charvalue = '0x';

        SELECT @i = 1;

        SELECT @length = DATALENGTH (@binvalue);

        SELECT @hexstring = '0123456789ABCDEF';

        WHILE (@i <= @length)
            BEGIN
                DECLARE @tempint INT;
                DECLARE @firstint INT;
                DECLARE @secondint INT;

                SELECT @tempint = CONVERT (INT, SUBSTRING (@binvalue, @i, 1));

                SELECT @firstint = FLOOR (@tempint / 16);

                SELECT @secondint = @tempint - (@firstint * 16);

                SELECT @charvalue = @charvalue + SUBSTRING (@hexstring, @firstint + 1, 1) + SUBSTRING (@hexstring, @secondint + 1, 1);

                SELECT @i = @i + 1;
            END;

        RETURN @charvalue;
    END;