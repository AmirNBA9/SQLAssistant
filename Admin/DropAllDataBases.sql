EXEC sp_MSforeachdb '
IF DB_ID(''?'') > 4
BEGIN
EXEC(''
ALTER DATABASE [?] SET SINGLE_USER WITH ROLLBACK IMMEDIATE
DROP DATABASE [?]
'')
END'