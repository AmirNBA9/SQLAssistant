--------------------------------------------------------------------
/*
جستجوی جداول با عبارتی مشخص در نام


*/
--------------------------------------------------------------------
select schema_name(t.schema_id) as schema_name,
t.name as table_name
from sys.tables t
where t.name like '%product%'
order by table_name,
schema_name;