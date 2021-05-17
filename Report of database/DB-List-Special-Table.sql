--------------------------------------------------------------------
/*
لیست دیتابیس‌های دارای یک جدول خاص
*/
--------------------------------------------------------------------
select [name] as [database_name] from sys.databases
where
case when state_desc = 'ONLINE'
then object_id(quotename([name]) + '.[product].[products]', 'U')
end is not null
order by 1