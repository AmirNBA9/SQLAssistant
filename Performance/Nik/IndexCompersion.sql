EXEC sys.sp_estimate_data_compression_savings @schema_name = 'dbo', @object_name = <TableName>, @index_id = NULL, @partition_number = NULL, @data_compression = 'ROW';

EXEC sys.sp_estimate_data_compression_savings @schema_name = 'dbo', @object_name = <TableName>, @index_id = NULL, @partition_number = NULL, @data_compression = 'PAGE';

--
GO

ALTER TABLE dbo.<TableName> REBUILD WITH (DATA_COMPRESSION = PAGE);

------------------
GO

SELECT SCHEMA_NAME (t.schema_id) + '.' + t.name AS table_view, CASE
                                                                   WHEN t.type = 'U' THEN 'Table'
                                                                   WHEN t.type = 'V' THEN 'View'
                                                               END AS object_type, i.index_id, CASE
                                                                                                   WHEN i.is_primary_key = 1 THEN 'Primary key'
                                                                                                   WHEN i.is_unique = 1 THEN 'Unique'
                                                                                                   ELSE 'Not unique'
                                                                                               END AS type, i.name AS index_name, SUBSTRING (D.column_names, 1, LEN (D.column_names) - 1) AS columns,
       CASE
           WHEN i.type = 1 THEN 'Clustered index'
           WHEN i.type = 2 THEN 'Nonclustered unique index'
           WHEN i.type = 3 THEN 'XML index'
           WHEN i.type = 4 THEN 'Spatial index'
           WHEN i.type = 5 THEN 'Clustered columnstore index'
           WHEN i.type = 6 THEN 'Nonclustered columnstore index'
           WHEN i.type = 7 THEN 'Nonclustered hash index'
       END AS index_type
  FROM sys.objects t
       INNER JOIN sys.indexes i ON t.object_id = i.object_id
       CROSS APPLY (SELECT col.name + ', '
                      FROM sys.index_columns ic
                           INNER JOIN sys.columns col ON ic.object_id = col.object_id
                                                     AND ic.column_id = col.column_id
                     WHERE ic.object_id = t.object_id
                       AND ic.index_id = i.index_id
                     ORDER BY col.column_id
                   FOR XML PATH ('')) D(column_names)
 WHERE t.is_ms_shipped <> 1
   AND i.index_id > 0
   AND t.name = 'AcceptedMoneyTransaction'
 ORDER BY SCHEMA_NAME (t.schema_id) + '.' + t.name, i.index_id;