/*------------------------------------------------------
-- Author:	Ah.ghasemi								----
-- Date:	1398/01/24								----
-- Note:	READ COMMITTED SNAPSHOT ON				----
------------------------------------------------------*/

Declare	@sql	nvarchar(4000)=N'',					--مجری کوئری فعال سازی
		@DBname	sysname = DB_NAME();				--نام دیتابیس جاری

Set @sql =	'Use Master
			Alter database ['+@DBname+']
			Set single_user with rollback immediate;

			ALTER DATABASE ['+@DBname+'] 
			SET READ_COMMITTED_SNAPSHOT ON;

			Alter database ['+@DBname+']
			Set Multi_user;'

Exec (@sql)

SELECT	name N'نام دیتابیس' ,
		case is_read_committed_snapshot_on	when 0 then N'غیرفعال'
											when 1 then N'فعال'
											end N'ReadCommitedSnapshot'   --تعیین وضعیت برای اسنپ شات
FROM sys.databases
WHERE name= @DBname