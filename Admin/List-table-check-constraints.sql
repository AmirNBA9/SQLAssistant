
select schema_name(t.schema_id) + '.' + t.[name] as [table],
col.column_id,
col.[name] as column_name,
con.[definition],
case when con.is_disabled = 0
then 'Active'
else 'Disabled'
end as [status],
con.[name] as constraint_name
from sys.check_constraints con
left outer join sys.objects t
on con.parent_object_id = t.object_id
left outer join sys.all_columns col
on con.parent_column_id = col.column_id
and con.parent_object_id = col.object_id
order by schema_name(t.schema_id) + '.' + t.[name],
col.column_id