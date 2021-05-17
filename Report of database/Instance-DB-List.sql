--------------------------------------------------------------------
/*
نام دیتابیس های یک instance
*/
--------------------------------------------------------------------
select [name] as database_name,
database_id,
create_date
from sys.databases
order by name