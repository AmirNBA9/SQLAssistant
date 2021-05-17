DECLARE @Command VARCHAR(MAX) = 'ALTER AUTHORIZATION ON DATABASE::[<<DatabaseName>>] TO 
[<<LoginName>>]' 

SELECT @Command = REPLACE(REPLACE(@Command 
            , '<<DatabaseName>>', SD.Name)
            , '<<LoginName>>', SL.Name)
FROM master..sysdatabases SD 
JOIN master..syslogins SL ON  SD.SID = SL.SID
WHERE  SD.Name = DB_NAME()

PRINT @Command
EXEC(@Command)