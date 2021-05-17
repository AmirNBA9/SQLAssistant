

Select	schema_name(schema_id) as schema_name,
		[name] as table_name,
		Case	when is_external = 1 then 'External table'
				when is_node = 1 then 'Graph node table'
				when is_edge = 1 then 'Graph edge table'
				when temporal_type = 2 then 'System versioned table'
				when temporal_type = 1 then 'History table'
				when is_filetable = 1 then 'File table'
				else 'Regular table'
		end as table_type
from sys.tables
order by schema_name, table_name