--date:		98/08/06
--Authore:	a.ghasemi
--readme:	Find column for compare whith number of  column
/*در این کوئری میتوانید بطور دستی انتخاب کنید که چند نوع جدولی را میخواهید مقایسه کنید تا تعداد آن را بیابید.*/
Declare @Obj varchar(5) = '3',						--Set obeject 1.all object 2.table 3.view
		@sql nvarchar(1000),
		/*مرحله ریز تر جستجو*/
		@tbl varchar(50)='vw_BuySub',			--ویوو یا جدول را وارد نمایید.
		@adv int=1								--برای مشاهده لیست ستون ها از جدول منتخب این مقدار یک شود
-----------------------------------------------------------------------------------------------	
if (@adv=0)	
BEGIN
	set @Obj = (select top 1 case @Obj when  1 then '%%' when 2 then 'tbl_%' when 3 then 'vw_%' end)
	Set @sql = '
	with t as(
	select isc.TABLE_NAME ,Row_number()over(partition by isc.table_name order by isc.column_name) as row1,isc.COLUMN_NAME
	from INFORMATION_SCHEMA.COLUMNS  isc 
	where isc.TABLE_NAME like  '''+@obj+''')
	select Max(row1)as N''تعداد ستون'',table_name as N''نام جدول'' from t
	Group by table_name'
	exec sp_executesql @sql
end
else if (@adv= 1)
BEGIN
	set @Obj = (select top 1 case @Obj when  1 then '%%' when 2 then 'tbl_%' when 3 then 'vw_%' end)
	Set @sql = '
	select isc.COLUMN_NAME N''نام همه ستون ها''
	from INFORMATION_SCHEMA.COLUMNS  isc 
	where isc.TABLE_NAME = '''+@tbl+''''
	exec sp_executesql @sql
End