/*Grant access on schema scale*/

USE DB
GO

GRANT SELECT	ON SCHEMA :: dbo to LinkedServerUser
GRANT UPDATE	ON SCHEMA :: dbo to LinkedServerUser
GRANT EXECUTE	ON SCHEMA :: dbo to LinkedServerUser
GRANT INSERT	ON SCHEMA :: dbo to LinkedServerUser


/*Grant access on object scale*/
GRANT SELECT	ON dbo.tablename to LinkedServerUser


/*Run Grant for all databases*/
EXEC sp_msForEachDB 
'IF ''?'' != ''TempDB'' and ''?'' != ''Master'' and ''?'' != ''Model'' and ''?'' != ''Model'' and ''?'' != ''msdb''
	Print ''? add SLELECT access for target user''
	GRANT SELECT	ON SCHEMA :: dbo to LinkedServerUser
	Print ''? add UPDATE access for target user''
	GRANT UPDATE	ON SCHEMA :: dbo to LinkedServerUser
	Print ''? add EXECUTE access for target user''
	GRANT EXECUTE	ON SCHEMA :: dbo to LinkedServerUser
	Print ''? add INSERT access for target user''
	GRANT INSERT	ON SCHEMA :: dbo to LinkedServerUser
'