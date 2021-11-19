--------------------------------------------------------------------
/*
لیست تمامی constraintهای تعریف شده روی جداول یک دیتابیس (PK,UK,FK,Check,Default)

 Table_View: نام جدول یا View به همراه نام Schema
 Object_Type: نوع Object
– Table
– View

Constraint_Type: نوع Constraint
– Primary key
– Unique key
– Foregin key
– Check constraint
– Default constraint

Constraint_Name: نام Constraint یا ایندکس
 Details: جزییات این Constraint
– Primary key – شامل اسامی ستون های شرکت کننده در PK
– Unique key – شامل اسامی ستون های شرکت کننده در UK
– Foregin key – نام جدول اصلی
– Check constraint – عبارت(فرمول) تعریف شده برای constraint
– Default constraint – نام ستون و مقدار/عبارت تعریف شده برای constrain
*/
--------------------------------------------------------------------
SELECT
	table_view
   ,object_type
   ,constraint_type
   ,constraint_name
   ,details
FROM (SELECT
		SCHEMA_NAME(t.schema_id) + '.' + t.[Name] AS table_view
	   ,CASE
			WHEN t.[type] = 'U' THEN 'Table'
			WHEN t.[type] = 'V' THEN 'View'
		END AS [object_type]
	   ,CASE
			WHEN c.[type] = 'PK' THEN 'Primary key'
			WHEN c.[type] = 'UQ' THEN 'Unique constraint'
			WHEN i.[type] = 1 THEN 'Unique clustered index'
			WHEN i.type = 2 THEN 'Unique index'
		END AS constraint_type
	   ,ISNULL(c.[Name], i.[Name]) AS constraint_name
	   ,SUBSTRING(column_names, 1, LEN(column_names) - 1) AS [details]
	FROM sys.objects t
	LEFT OUTER JOIN sys.indexes i
		ON t.object_id = i.object_id
	LEFT OUTER JOIN sys.key_constraints c
		ON i.object_id = c.parent_object_id
		AND i.index_id = c.unique_index_id
	CROSS APPLY (SELECT
			col.[Name] + ', '
		FROM sys.index_columns ic
		INNER JOIN sys.columns col
			ON ic.object_id = col.object_id
			AND ic.column_id = col.column_id
		WHERE ic.object_id = t.object_id
		AND ic.index_id = i.index_id
		ORDER BY col.column_id
		FOR XML PATH ('')) D (column_names)
	WHERE is_unique = 1
	AND t.is_ms_shipped <> 1
	UNION ALL
	SELECT
		SCHEMA_NAME(fk_tab.schema_id) + '.' + fk_tab.Name AS foreign_table
	   ,'Table'
	   ,'Foreign key'
	   ,fk.Name AS fk_constraint_name
	   ,SCHEMA_NAME(pk_tab.schema_id) + '.' + pk_tab.Name
	FROM sys.foreign_keys fk
	INNER JOIN sys.tables fk_tab
		ON fk_tab.object_id = fk.parent_object_id
	INNER JOIN sys.tables pk_tab
		ON pk_tab.object_id = fk.referenced_object_id
	INNER JOIN sys.foreign_key_columns fk_cols
		ON fk_cols.constraint_object_id = fk.object_id
	UNION ALL
	SELECT
		SCHEMA_NAME(t.schema_id) + '.' + t.[Name]
	   ,'Table'
	   ,'Check constraint'
	   ,con.[Name] AS constraint_name
	   ,con.[definition]
	FROM sys.check_constraints con
	LEFT OUTER JOIN sys.objects t
		ON con.parent_object_id = t.object_id
	LEFT OUTER JOIN sys.all_columns col
		ON con.parent_column_id = col.column_id
		AND con.parent_object_id = col.object_id
	UNION ALL
	SELECT
		SCHEMA_NAME(t.schema_id) + '.' + t.[Name]
	   ,'Table'
	   ,'Default constraint'
	   ,con.[Name]
	   ,col.[Name] + ' = ' + con.[definition]
	FROM sys.default_constraints con
	LEFT OUTER JOIN sys.objects t
		ON con.parent_object_id = t.object_id
	LEFT OUTER JOIN sys.all_columns col
		ON con.parent_column_id = col.column_id
		AND con.parent_object_id = col.object_id) a
ORDER BY table_view, constraint_type, constraint_name