/*
SQL Server Alias Registry Settings
You could (with appropriate permissions) try to write to the registry with T-SQL
*/

USE [master]
GO

DECLARE @HostName NVARCHAR(300)
DECLARE @DBMSSCN_IP_Port NVARCHAR(100)

SET @HostName = N'AmirNBA9'
SET @DBMSSCN_IP_Port = N'DBMSSOCN,192.168.0.2,1433'

EXEC xp_regwrite N'HKEY_LOCAL_MACHINE', N'Software\Microsoft\MSSQLServer\Client\ConnectTo', @HostName, REG_SZ, @DBMSSCN_IP_Port
EXEC xp_regwrite N'HKEY_LOCAL_MACHINE', N'Software\Wow6432Node\Microsoft\MSSQLServer\Client\ConnectTo', @HostName, REG_SZ, @DBMSSCN_IP_Port