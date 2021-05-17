--------------------------------------------------------------------
/*
لیست Unique Indexهای یک دیتابیس


index_name: نام ایندکس
Columns: لیست اسامی ستون های شرکت کننده در ایندکس
 Index_Type: نوع ایندکس
– Clustered unique index
– non-clustered unique index – Unique index

 Table_View: نام جدول یا view مرتبط با ایندکس به همراه نام schema
 Object_Type: نوع object ای که ایندکس یا constraint برای آن تعریف شده
– Table
– View

 constraint_type:
– Primary key- برای PK ها
– Unique constraint- برای constraint های ایجاد شده توسط دستور CONSTRAINT UNIQUE
 constraint_name: نام primary key constraint و یا unique key constraint – برای unique index های فاقد constraint مقدار null نشان داده خواهد شد
*/
--------------------------------------------------------------------
select i.[name] as index_name,
substring(column_names, 1, len(column_names)-1) as [columns],
case when i.[type] = 1 then 'Clustered unique index'
when i.type = 2 then 'Unique index'
end as index_type,
schema_name(t.schema_id) + '.' + t.[name] as table_view,
case when t.[type] = 'U' then 'Table'
when t.[type] = 'V' then 'View'
end as [object_type],
case when c.[type] = 'PK' then 'Primary key'
when c.[type] = 'UQ' then 'Unique constraint'
end as constraint_type,
c.[name] as constraint_name
from sys.objects t
left outer join sys.indexes i
on t.object_id = i.object_id
left outer join sys.key_constraints c
on i.object_id = c.parent_object_id
and i.index_id = c.unique_index_id
cross apply (select col.[name] + ', '
from sys.index_columns ic
inner join sys.columns col
on ic.object_id = col.object_id
and ic.column_id = col.column_id
where ic.object_id = t.object_id
and ic.index_id = i.index_id
order by col.column_id
for xml path ('') ) D (column_names)
where is_unique = 1
and t.is_ms_shipped <> 1
order by i.[name]