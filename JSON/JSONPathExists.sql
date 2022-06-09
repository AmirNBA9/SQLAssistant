DECLARE @jsonInfo NVARCHAR(MAX)

SET @jsonInfo=N'{"info":{"address":[{"town":"Paris"},{"town":"London"}]}}';

SELECT JSON_PATH_EXISTS(@jsonInfo,'$.info.address') AS [True Path] -- 1
	  ,JSON_PATH_EXISTS(@jsonInfo,'$.info.addresses') AS [False Path] -- 0
	  ,JSON_PATH_EXISTS(@jsonInfo,'$.info.town') AS [False Path] -- 0