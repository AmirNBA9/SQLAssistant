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
SELECT	   con.[name] AS constraint_name, SCHEMA_NAME (t.schema_id) + '.' + t.[name] AS [table], col.[name] AS column_name, con.[definition], --
		   CASE
			   WHEN con.is_disabled = 0 THEN 'Active'
			   ELSE 'Disabled'
		   END AS [status]
  FROM	   sys.check_constraints con
		   LEFT OUTER JOIN sys.objects t ON con.parent_object_id = t.object_id
		   LEFT OUTER JOIN sys.all_columns col ON con.parent_column_id = col.column_id
											  AND con.parent_object_id = col.object_id
  ORDER BY con.name;
