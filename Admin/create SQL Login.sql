--------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------
--------------------------Replace AppPoolName With Real Name--------------------------
-----------------------Replace DOMAIN\USER With Real Admin Login----------------------
--------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------

IF  EXISTS (SELECT * FROM sys.server_principals WHERE name = N'IIS APPPOOL\AppPoolName')
DROP LOGIN [IIS APPPOOL\AppPoolName]
GO
IF NOT EXISTS (SELECT * FROM sys.server_principals WHERE name = N'IIS APPPOOL\AppPoolName')
CREATE LOGIN [IIS APPPOOL\AppPoolName] FROM WINDOWS WITH DEFAULT_DATABASE=[master], DEFAULT_LANGUAGE=[us_english]
GO
EXEC sys.sp_addsrvrolemember @loginame = N'IIS APPPOOL\AppPoolName', @rolename = N'sysadmin'
GO

if object_id('tempdb..#Tsqls') is not null drop table #Tsqls
SELECT 'Use ' + Name + '
GO
EXEC sp_changedbowner ''sa''
GO' tsql into #Tsqls FROM sys.databases
where suser_sname( owner_sid ) = 'DOMAIN\USER'
go
if (select Count(*) from #Tsqls) <> 0
begin
	select N'این کد ها را اجرا کنید'
	select * from #Tsqls
end
GO

ALTER LOGIN [sa] WITH PASSWORD=N'fjD@@w2eH4j5J5fK&6U7be__8w8M@9D245'
GO