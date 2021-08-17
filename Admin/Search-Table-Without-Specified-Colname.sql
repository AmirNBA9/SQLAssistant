--------------------------------------------------------------------
/*
جستجوی جداول که دارای ستونی با نام مشخص نباشند

 Schema_Name: نام Schema جدول پیدا شده
 Table_Name: نام جدول پیدا شده
*/
--------------------------------------------------------------------
select schema_name(t.schema_id) as schema_name,
t.name as table_name
from sys.tables t
where t.object_id not in
(select c.object_id
from sys.columns c
where c.name = 'ModifiedDate')
order by schema_name,
table_name;