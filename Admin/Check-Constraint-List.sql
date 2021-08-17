--------------------------------------------------------------------
/*
لیست تمامی Check Constraintهای تعریف شده در یک دیتابیس


Constraint_Name: نام Constraint
Table: نام Schema و جدولی که Constraint روی آن ایجاد شده است
Column_Name: نام ستون در مورد Check Constraint های تعریف شده در سطح ستون; برای Constraint های ایجادی در سطح جدول (table-level) مقدار null نمایش داده می‌شود.
Definition: عبارتی که برای این Check Constraint تعریف شده است
 Status: وضعیت Constraint
o ‘Active’ در صورتی که Constraint فعال باشد.
o ‘Disabled’ برای Constraintهای غیرفعال
*/
--------------------------------------------------------------------
select con.[name] as constraint_name,
    schema_name(t.schema_id) + '.' + t.[name]  as [table],
    col.[name] as column_name,
    con.[definition],
    case when con.is_disabled = 0 
        then 'Active' 
        else 'Disabled' 
        end as [status]
from sys.check_constraints con
    left outer join sys.objects t
        on con.parent_object_id = t.object_id
    left outer join sys.all_columns col
        on con.parent_column_id = col.column_id
        and con.parent_object_id = col.object_id
order by con.name

