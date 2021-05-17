--------------------------------------------------------------------
/*
لیست Schemaهای موجود در یک دیتابیس
*/
--------------------------------------------------------------------
select s.name as schema_name,
s.schema_id,
u.name as schema_owner
from sys.schemas s
inner join sys.sysusers u
on u.uid = s.principal_id
order by s.name