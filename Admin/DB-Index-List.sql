--------------------------------------------------------------------
/*
لیست تمامی Indexهای تعریف شده در یک دیتابیس

 Index_Name: نام ایندک• Columns:
Column: لیست اسامی ستون های شرکت کننده در ایند
Index_Type
– Clustered index
– Nonclustered unique index
– XML index
– Spatial index
– Clustered columnstore index
– Nonclustered columnstore index
– Nonclustered hash index

Unique: آیا ایندکس Unique است یا نه؟
– Unique
– Not Unique

Table_View: نام جدول یا View مرتبط با ایندکس به همراه نام Schema
Object_Type: نوع Object ای که ایندکس برای آن تعریف شده است
– Table
– View
*/
--------------------------------------------------------------------
select i.[name] as index_name,
substring(column_names, 1, len(column_names)-1) as [columns],
case when i.[type] = 1 then 'Clustered index'
when i.[type] = 2 then 'Nonclustered unique index'
when i.[type] = 3 then 'XML index'
when i.[type] = 4 then 'Spatial index'
when i.[type] = 5 then 'Clustered columnstore index'
when i.[type] = 6 then 'Nonclustered columnstore index'
when i.[type] = 7 then 'Nonclustered hash index'
end as index_type,
case when i.is_unique = 1 then 'Unique'
else 'Not unique' end as [unique],
schema_name(t.schema_id) + '.' + t.[name] as table_view,
case when t.[type] = 'U' then 'Table'
when t.[type] = 'V' then 'View'
end as [object_type]
from sys.objects t
inner join sys.indexes i
on t.object_id = i.object_id
cross apply (select col.[name] + ', '
from sys.index_columns ic
inner join sys.columns col
on ic.object_id = col.object_id
and ic.column_id = col.column_id
where ic.object_id = t.object_id
and ic.index_id = i.index_id
order by col.column_id
for xml path ('') ) D (column_names)
where t.is_ms_shipped <> 1
and index_id > 0
order by i.[name]