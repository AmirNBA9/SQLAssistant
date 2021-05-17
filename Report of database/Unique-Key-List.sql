--------------------------------------------------------------------
/*
 لیست Unique Keyها و Indexهای یک دیتابیس

 Table_Vew: نام و Schema جدول و یا View
Object_Type: نوع Objectای که Index/constraint روی آن ایجاد شده است.
– Table
– View
Constraint_Type:
–  Primary key: برای Primary Keyها
–  Unique Constraint: برای Constraintهای ایجاد شده توسط دستور CONSTRAINT UNIQUE
– Unique Clustered Index :Unique Clustered Indexها بدون درنظر گرفتن Constraintهای از نوع Primary ویا Unique
–  Unique Index :unique non-clustered indexها بدون درنظر گرفتن Constraintهای از نوع Primary ویا Unique

 Constraint_Name :Constraintهای ایجاد شده بابت Primary و یا Unique Key, برای Unique Indexهای که مجزا از Constraint ایجاد شده باشند مقدار Null نمایش داده می‌شود.
 Columns: اسامی ستون‌های شرکت کننده در ایندکس که با “,” از هم جدا شده‌‍اند.
 Index_Name: نام ایندکس
 Index_Type: نوع ایندکس
– Clustered Index- Clustered Index
– Index- Non-Clustered Index
*/
--------------------------------------------------------------------
select schema_name(t.schema_id) + '.' + t.[name] as table_view,
case when t.[type] = 'U' then 'Table'
when t.[type] = 'V' then 'View'
end as [object_type],
case when c.[type] = 'PK' then 'Primary key'
when c.[type] = 'UQ' then 'Unique constraint'
when i.[type] = 1 then 'Unique clustered index'
when i.type = 2 then 'Unique index'
end as constraint_type,
c.[name] as constraint_name,
substring(column_names, 1, len(column_names)-1) as [columns],
i.[name] as index_name,
case when i.[type] = 1 then 'Clustered index'
when i.type = 2 then 'Index'
end as index_type
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
and t.is_ms_shipped <> 1order by schema_name(t.schema_id) + '.' + t.[name]