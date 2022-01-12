USE [master];
GO

/****** Object:  LinkedServer [91.98.33.151,16070]    Script Date: 2019/10/28 5:23:14 PM ******/
EXEC master.dbo.sp_addlinkedserver @server = N'91.98.33.151,16070', @srvproduct = N'SQL Server';

/* For security reasons the linked server remote logins password is changed with ######## */
EXEC master.dbo.sp_addlinkedsrvlogin @rmtsrvname = N'91.98.33.151,16070', @useself = N'False', @locallogin = NULL, @rmtuser = N'omega2', @rmtpassword = '########';
GO

EXEC master.dbo.sp_serveroption @server = N'91.98.33.151,16070', @optname = N'collation compatible', @optvalue = N'false';
GO

EXEC master.dbo.sp_serveroption @server = N'91.98.33.151,16070', @optname = N'data access', @optvalue = N'true';
GO

EXEC master.dbo.sp_serveroption @server = N'91.98.33.151,16070', @optname = N'dist', @optvalue = N'false';
GO

EXEC master.dbo.sp_serveroption @server = N'91.98.33.151,16070', @optname = N'pub', @optvalue = N'false';
GO

EXEC master.dbo.sp_serveroption @server = N'91.98.33.151,16070', @optname = N'rpc', @optvalue = N'false';
GO

EXEC master.dbo.sp_serveroption @server = N'91.98.33.151,16070', @optname = N'rpc out', @optvalue = N'false';
GO

EXEC master.dbo.sp_serveroption @server = N'91.98.33.151,16070', @optname = N'sub', @optvalue = N'false';
GO

EXEC master.dbo.sp_serveroption @server = N'91.98.33.151,16070', @optname = N'connect timeout', @optvalue = N'0';
GO

EXEC master.dbo.sp_serveroption @server = N'91.98.33.151,16070', @optname = N'collation name', @optvalue = NULL;
GO

EXEC master.dbo.sp_serveroption @server = N'91.98.33.151,16070', @optname = N'lazy schema validation', @optvalue = N'false';
GO

EXEC master.dbo.sp_serveroption @server = N'91.98.33.151,16070', @optname = N'query timeout', @optvalue = N'0';
GO

EXEC master.dbo.sp_serveroption @server = N'91.98.33.151,16070', @optname = N'use remote collation', @optvalue = N'true';
GO

EXEC master.dbo.sp_serveroption @server = N'91.98.33.151,16070', @optname = N'remote proc transaction promotion', @optvalue = N'true';
GO