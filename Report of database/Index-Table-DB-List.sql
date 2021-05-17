--------------------------------------------------------------------
/*
لیست Indexهای جداول یک دیتابیس

 Table_Vew: نام جدول یا View مرتبط با ایندکس
 Object_Type: نوع Objectای که ایندکس برای آن تعریف شده
-Table
– View

 iIndex_id: id مربوط به ایندکس (این شماره در هر جدول یکتا می باشد)
 Type:
– Primary Key
– Unique
– Not Unique

 Index_Name: نام ایندکس
 Columns: لیست اسامی ستون‌ شرکت کننده در ایندکس
 Index_Type: نوع ایندکس
– Clustered index
– Nonclustered unique index
– XML index
– Spatial index
– Clustered columnstore index
– Nonclustered columnstore index
– Nonclustered hash index
*/
--------------------------------------------------------------------
select schema_name(t.schema_id) + '.' + t.[name] as table_view,
case when t.[type] = 'U' then 'Table'
when t.[type] = 'V' then 'View'
end as [object_type],
i.index_id,
case when i.is_primary_key = 1 then 'Primary key'
when i.is_unique = 1 then 'Unique'
else 'Not unique' end as [type],
i.[name] as index_name,
substring(column_names, 1, len(column_names)-1) as [columns],
case when i.[type] = 1 then 'Clustered index'
when i.[type] = 2 then 'Nonclustered unique index'
when i.[type] = 3 then 'XML index'
when i.[type] = 4 then 'Spatial index'
when i.[type] = 5 then 'Clustered columnstore index'
when i.[type] = 6 then 'Nonclustered columnstore index'
when i.[type] = 7 then 'Nonclustered hash index'
end as index_type
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
order by schema_name(t.schema_id) + '.' + t.[name], i.index_id