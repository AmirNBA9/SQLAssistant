--------------------------------------------------------------------
/*
 جستجوی جداول دارای ستونی با نام مشخص


*/
--------------------------------------------------------------------
select schema_name(t.schema_id) as schema_name,
t.name as table_name
from sys.tables t
where t.object_id in
(select c.object_id
from sys.columns c
where c.name = 'ProductID')
order by schema_name,
table_name;