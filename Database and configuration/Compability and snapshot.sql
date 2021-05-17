/*------------------------------------------------------
-- Author:	Ah.ghasemi								----
-- Date:	1397/12/16								----
-- Note:	Chang Compability level for DB			----
			and Active Snapshot
-- Script Code: 122									----
------------------------------------------------------*/


declare @level nvarchar(5) = '130',					---سطح مورد نظر بنویسید 100,120,110,130,150--مدنظر ما فعلا 130 است
		@DBname sysname = DB_name(),				---متغییر نام دیتابیس، نیاز به تغییر ندارد
		@Command nvarchar(400),						---خط فرمان دستور مورد نظر
		@Command2 nvarchar(400)
/*--Command--*/
Set @Command =	'
				ALTER DATABASE ['+(@DBname)+']
				SET COMPATIBILITY_LEVEL = '+@level+'
				'
Set @Command2 = '
				use master
				Alter database ['+@DBname+']
					Set single_user with rollback immediate

				ALTER DATABASE ['+@DBname+']
					SET READ_COMMITTED_SNAPSHOT ON  
				
				Alter database ['+@DBname+']
					Set Multi_user
				'

Exec sp_executesql	@command
Exec sp_executesql	@command2

/*--Checking All database--*/
Select Case when is_read_committed_snapshot_on=1 then N'با موفقیت فعال شد'
			when is_read_committed_snapshot_on=0 then N'تنظیم پیش فرض' 
					end as N'وضعیت!',
		 [name] as N'نام دیتابیس'
from sys.databases
order by is_read_committed_snapshot_on desc


Select is_read_committed_snapshot_on,snapshot_isolation_state,snapshot_isolation_state_desc,* 
from sys.databases

