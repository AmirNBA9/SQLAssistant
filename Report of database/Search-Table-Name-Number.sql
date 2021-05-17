--------------------------------------------------------------------
/*
جستجوی جداولی که در نامشان عدد وجود دارد

*/
--------------------------------------------------------------------
select schema_name(t.schema_id) as schema_name,
t.name as table_name
from sys.tables t
where t.name like '%[0-9]%'
order by schema_name,
table_name;