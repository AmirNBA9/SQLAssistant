--------------------------------------------------------------------
/*
 جستجوی جداول توسط نام با شروع عبارتی مشخص
*/
--------------------------------------------------------------------
select schema_name(t.schema_id) as schema_name,
t.name as table_name
from sys.tables t
where t.name like 'pr%'
order by table_name,
schema_name;