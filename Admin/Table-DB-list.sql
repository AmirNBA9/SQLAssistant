--------------------------------------------------------------------
/*
لیست جداول یک دیتابیس
*/
--------------------------------------------------------------------
select schema_name(t.schema_id) as schema_name,
       t.name as table_name,
       t.create_date,
       t.modify_date
from sys.tables t
order by schema_name,
         table_name;
