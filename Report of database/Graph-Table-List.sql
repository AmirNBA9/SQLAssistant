--------------------------------------------------------------------
/*

*/
--------------------------------------------------------------------
select case when is_node = 1 then 'Node'
when is_edge = 1 then 'Edge'
end table_type,
schema_name(schema_id) as schema_name,
name as table_name
from sys.tables
where is_node = 1 or is_edge = 1
order by is_edge, schema_name, table_name