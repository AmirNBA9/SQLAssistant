DECLARE @upperLetters VARCHAR(26) = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ',
        @lowerLetters VARCHAR(26) = 'abcdefghijklmnopqrstuvwxyz',
        @digits VARCHAR(10) = '0123456789',
        @specials VARCHAR(32) = '-!"#$%&()*+,./:;?@[]^_`{|}~+<=>',
        @password VARCHAR(MAX) = ''
;WITH Tally (n) AS (
    SELECT TOP (16) ROW_NUMBER() OVER (ORDER BY (SELECT NULL))
    FROM master..spt_values
)
SELECT @password = @password + CHAR FROM (
    SELECT TOP (12) CHAR = SUBSTRING(@upperLetters + @lowerLetters + @digits, CAST(RAND(CHECKSUM(NEWID()))*(26+26+10) AS INT)+1, 1)
    FROM Tally
    UNION ALL
    SELECT TOP (4) CHAR = 
SUBSTRING(@specials, CAST(RAND(CHECKSUM(NEWID()))*32 AS INT)+1, 1)
    FROM Tally
) t
SELECT @password AS GeneratedPassword
