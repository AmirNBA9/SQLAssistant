--------------------------------------------------------------------
/*
List of graph table
*/
--------------------------------------------------------------------
SELECT
	CASE
		WHEN is_node = 1 THEN 'Node'
		WHEN is_edge = 1 THEN 'Edge'
	END table_type
   ,SCHEMA_NAME(schema_id) AS schema_name
   ,Name AS table_name
FROM sys.tables
WHERE is_node = 1
	OR is_edge = 1 
ORDER BY is_edge, schema_name, table_name