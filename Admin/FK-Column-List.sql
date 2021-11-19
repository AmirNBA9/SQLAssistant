--------------------------------------------------------------------
/*
لیست ستون‌های یک جدول به همراه Foreign Key‌های آنها

Table: نام جدول به همراه نام schema
Column_ID: شماره(id) ستون
Column_Name: نام ستون
Rel: نماد ارتباط , مشخص کننده Foreign Key و جهت ارتباط
Primary_Table: جدول مرجع (اصلی)
Pk_Column_Name: نام ستون ارجاع شده (عامل ارتباط) در جدول اصلی
No: شماره (id) ستون در foreign key ایجاد شده
Fk_Constraint_Name: نام constraint مربوط به این foreign key

*/
--------------------------------------------------------------------
SELECT
	SCHEMA_NAME(tab.schema_id) + '.' + tab.Name AS [table]
   ,col.column_id
   ,col.Name AS column_name
   ,CASE
		WHEN fk.object_id IS NOT NULL THEN '>-'
		ELSE NULL
	END AS rel
   ,SCHEMA_NAME(pk_tab.schema_id) + '.' + pk_tab.Name AS primary_table
   ,pk_col.Name AS pk_column_name
   ,fk_cols.constraint_column_id AS no
   ,fk.Name AS fk_constraint_name
FROM sys.tables tab
	INNER JOIN sys.columns col ON col.object_id = tab.object_id
	LEFT OUTER JOIN sys.foreign_key_columns fk_cols ON fk_cols.parent_object_id = tab.object_id AND fk_cols.parent_column_id = col.column_id
	LEFT OUTER JOIN sys.foreign_keys fk ON fk.object_id = fk_cols.constraint_object_id
	LEFT OUTER JOIN sys.tables pk_tab ON pk_tab.object_id = fk_cols.referenced_object_id
	LEFT OUTER JOIN sys.columns pk_col ON pk_col.column_id = fk_cols.referenced_column_id AND pk_col.object_id = fk_cols.referenced_object_id
ORDER BY SCHEMA_NAME(tab.schema_id) + '.' + tab.Name, col.column_id