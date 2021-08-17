--------------------------------------------------------------------
/*
لیست Check Constraintهای تعریف شده روی یک جدول

 Table: نام Schema و جدول
 Column_ID :ID مربوط به آن ستون, این شماره در هر جدول یکتا می باشد
 Column_Name: نام ستون در مورد Check Constraintهای تعریف شده در سطح ستون; برای constraint های ایجادی در سطح جدول (table-level) مقدار null نمایش داده می شود
 Definition: عبارتی که برای این Check Constraint تعریف شده است
 status: وضعیت Constraint
o ‘Active’ در صورتی که Constraint فعال باشد
o ‘Disabled’ برای Constraintهای غیرفعال
 Constraint_Name: نام Constraint
*/
--------------------------------------------------------------------
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
