SELECT
	table_name
   ,column_name
   ,*
FROM INFORMATION_SCHEMA.COLUMNS
WHERE column_name LIKE '%CU_%'