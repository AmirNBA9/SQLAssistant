--------------------------------------------------------------------
/*

*/
--------------------------------------------------------------------
select schema_name(tab.schema_id) as [schema_name],
pk.[name] as pk_name,
substring(column_names, 1, len(column_names)-1) as [columns],
tab.[name] as table_name
from sys.tables tab
inner join sys.indexes pk
on tab.object_id = pk.object_id
and pk.is_primary_key = 1
cross apply (select col.[name] + ', '
from sys.index_columns ic
inner join sys.columns col
on ic.object_id = col.object_id
and ic.column_id = col.column_id
where ic.object_id = tab.object_id
and ic.index_id = pk.index_id
order by col.column_id
for xml path ('') ) D (column_names)
order by schema_name(tab.schema_id),
pk.[name]