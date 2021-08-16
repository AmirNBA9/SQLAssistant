--authore: ah.ghasemi
--date: 98/03/20

Declare @tablename varchar(20)='tbl_factor',					---- نام جدول مورد نظر را بنویسید
		@DBname sysname ='OfficeDB.INFORMATION_SCHEMA.COLUMNS'	---- مسیر دیتابیس مقصد را با نام آن بنویسید
Declare	@sql nvarchar(max)='
declare @tablename varchar(20)='''+@tablename+''';
Select	FDB.TABLE_NAME+''.''+FDB.COLUMN_NAME as [name1],FDB.DATA_TYPE,FDB.CHARACTER_MAXIMUM_LENGTH,
		SDB.TABLE_NAME+''.''+SDB.COLUMN_NAME as [name2],SDB.DATA_TYPE,SDB.CHARACTER_MAXIMUM_LENGTH
from OMEGADB.INFORMATION_SCHEMA.COLUMNS FDB 
		left outer join '+@DBname+' SDB on FDB.TABLE_NAME+''.''+FDB.COLUMN_NAME=SDB.TABLE_NAME+''.''+SDB.COLUMN_NAME
where SDB.TABLE_NAME+''.''+SDB.COLUMN_NAME is null and FDB.TABLE_NAME= @tablename'
--print @sql
exec (@sql)


--with t as(
--Select	FDB.TABLE_NAME as name1,count(FDB.COLUMN_NAME) as count1,
--		SDB.TABLE_NAME as name2,count(SDB.COLUMN_NAME) as count2
--FROM OMEGADB.INFORMATION_SCHEMA.COLUMNS FDB 
--		full outer join OfficeDB.INFORMATION_SCHEMA.COLUMNS SDB on FDB.TABLE_NAME+'.'+FDB.COLUMN_NAME=SDB.TABLE_NAME+'.'+SDB.COLUMN_NAME
--group by  FDB.TABLE_NAME,SDB.TABLE_NAME)

--select * from t 
--where count1!=count2

