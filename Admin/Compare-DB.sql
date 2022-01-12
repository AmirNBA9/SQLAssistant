
DECLARE @DataBase1 NVARCHAR(100) = N'test'
DECLARE @DataBase2 NVARCHAR(100) = N'test2'

EXEC ('SELECT	   ISNULL (db1.table_name, db2.table_name) AS [table], ISNULL (db1.column_name, db2.column_name) AS [column], db1.column_name AS database1, db2.column_name AS database2
  FROM	   (SELECT SCHEMA_NAME (tab.schema_id) + ''.'' + tab.name AS table_name, col.name AS column_name
			  FROM '+@DataBase1+'.sys.tables AS tab
				   INNER JOIN '+@DataBase1+'.sys.columns AS col ON tab.object_id = col.object_id) db1
		   FULL OUTER JOIN (SELECT SCHEMA_NAME (tab.schema_id) + ''.'' + tab.name AS table_name, col.name AS column_name
							  FROM '+@DataBase2+'.sys.tables AS tab
								   INNER JOIN '+@DataBase2+'.sys.columns AS col ON tab.object_id = col.object_id) db2 ON db1.table_name = db2.table_name
																													   AND db1.column_name = db2.column_name
  WHERE	   (db1.column_name IS NULL OR db2.column_name IS NULL)
  ORDER BY 1, 2, 3');