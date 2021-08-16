/*
--Author: A.ghasemi
--Date: 1398-04-14
--Readme: اصلاح حروف عربی و فارسی
*/
if OBJECT_ID('tempdb..#User_Tables') is not null drop table #User_Tables --بدست آوردن نام جداول
select name
into #User_Tables
from sys.all_objects
where type_desc = 'user_table'
and name <> 'sysdiagrams'

if OBJECT_ID('tempdb..#LitteralFields') is not null drop table #LitteralFields --بدست آوردن ستون های کاراکتری
SELECT newid() Id, TABLE_NAME, COLUMN_NAME
into #LitteralFields
FROM	INFORMATION_SCHEMA.COLUMNS
		inner join #User_Tables on #User_Tables.name = TABLE_NAME
where (DATA_TYPE = 'char' or
		DATA_TYPE = 'nchar' or
		DATA_TYPE = 'nvarchar' or
		DATA_TYPE = 'varchar') --and COLUMN_NAME <> ''

declare @Id				uniqueidentifier			--شماره انخصاری
declare @TABLE_NAME		varchar(100)				--نام جدول
declare @COLUMN_NAME	varchar(100)				--نام ستون
declare @tsql			nvarchar(1000)				--مجری اول
declare @tsqls			table (tsql nvarchar(4000))	-- مجری دوم

while (select COUNT(*) from #LitteralFields) <> 0
begin
	select top 1 @Id = Id, @TABLE_NAME = TABLE_NAME, @COLUMN_NAME = COLUMN_NAME
	from #LitteralFields
	
	set @tsql = 'Update ' + @TABLE_NAME + ' Set ' + @COLUMN_NAME + ' = REPLACE(REPLACE(REPLACE(' + @COLUMN_NAME + N', N''ي'', N''ی''), N''ك'', N''ک''), '' '', N'' '')'
	begin try
		exec sp_executesql @tsql
	end try
	begin catch
	end catch
	insert into @tsqls values (@tsql)
	
	delete from #LitteralFields
	where Id = @Id
end

if OBJECT_ID('tempdb..#tsqls') is not null drop table #tsqls
select * into #tsqls from @tsqls
go