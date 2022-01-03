--------------------------------------------------------------------
/*
نام دیتابیس های یک instance
*/
--------------------------------------------------------------------
SELECT [name] AS database_name,
       database_id,
       create_date
FROM sys.databases
ORDER BY name;