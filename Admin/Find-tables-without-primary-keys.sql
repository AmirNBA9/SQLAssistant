--------------------------------------------------------------------
/*Find tables without PrimaryKey*/
--------------------------------------------------------------------
SELECT
	SCHEMA_NAME(tab.schema_id) AS [schema_name]
   ,tab.[Name] AS table_name
FROM sys.tables tab
	LEFT OUTER JOIN sys.indexes pk ON tab.object_id = pk.object_id AND pk.is_primary_key = 1
WHERE pk.object_id IS NULL
ORDER BY schema_name(tab.schema_id),tab.[Name]