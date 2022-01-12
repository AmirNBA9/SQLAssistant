--------------------------------------------------------------------
/*
لیست دیتابیس‌های دارای یک جدول خاص
*/
--------------------------------------------------------------------
SELECT	   [name] AS [database_name]
  FROM	   sys.databases
  WHERE	   CASE
			   WHEN state_desc = 'ONLINE' THEN OBJECT_ID (QUOTENAME ([name]) + '.[product].[products]', 'U')
		   END IS NOT NULL
  ORDER BY 1;