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
SELECT	   SCHEMA_NAME (t.schema_id) + '.' + t.[Name] AS [table], col.column_id, col.[Name] AS column_name, con.[definition], --
		   CASE
			   WHEN con.is_disabled = 0 THEN 'Active'
			   ELSE 'Disabled'
		   END AS [status], con.[Name] AS constraint_name
  FROM	   sys.check_constraints con
		   LEFT OUTER JOIN sys.objects t ON con.parent_object_id = t.object_id
		   LEFT OUTER JOIN sys.all_columns col ON con.parent_column_id = col.column_id
											  AND con.parent_object_id = col.object_id
  ORDER BY SCHEMA_NAME (t.schema_id) + '.' + t.[Name], col.column_id;
