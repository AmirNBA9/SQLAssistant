--------------------------------------------------------------------
/*
لیست تمامی ستون‌های یک جدول خاص
*/
--------------------------------------------------------------------
select
col.column_id as id,
col.name,
t.name as data_type,
col.max_length,
col.precision,
col.is_nullable
from sys.tables as tab
inner join sys.columns as col
on tab.object_id = col.object_id
left join sys.types as t
on col.user_type_id = t.user_type_id
where tab.name = 'main' -- enter table name here
	and schema_name(tab.schema_id) = 'Common'
order by tab.name, column_id;