--------------------------------------------------------------------
/*
لیست ستون‌های شرکت کننده در Foreign Key Constraintهای یک دیتابیس

Foreign_Table: نام جدول دارای FK به همراه نام schema
 Rel: نماد نشان دهنده ارتباط
 Primary_Table: نام جدول اصلی (referenced table)همراه با نام schema
 no :ID مربوط به این ستون در Fk ایجاد شده . این شماره برای کلیدهایی که تنها شامل یک ستون باشند همواره برابر 1 و برای کلیدهای ترکیبی به ازای هر ستون از کلید دارای مقادیر 1 , 2 و … خواهد بود
 FK_Column_Name: نام ستون در جدول خارجی
 Join: نماد نشان دهنده ارتباط بین هر جفت از ستون ها
 Pk_Column_Name: نام ستون در جدول اصلی
 FK_Constraint_Name: نام Foreign Key Constraint
*/
--------------------------------------------------------------------
select schema_name(fk_tab.schema_id) + '.' + fk_tab.name as foreign_table,
'>-' as rel,
schema_name(pk_tab.schema_id) + '.' + pk_tab.name as primary_table,
fk_cols.constraint_column_id as no,
fk_col.name as fk_column_name,
' = ' as [join],
pk_col.name as pk_column_name,
fk.name as fk_constraint_name
from sys.foreign_keys fk
inner join sys.tables fk_tab
on fk_tab.object_id = fk.parent_object_id
inner join sys.tables pk_tab
on pk_tab.object_id = fk.referenced_object_id
inner join sys.foreign_key_columns fk_cols
on fk_cols.constraint_object_id = fk.object_id
inner join sys.columns fk_col
on fk_col.column_id = fk_cols.parent_column_id
and fk_col.object_id = fk_tab.object_id
inner join sys.columns pk_col
on pk_col.column_id = fk_cols.referenced_column_id
and pk_col.object_id = pk_tab.object_id
order by schema_name(fk_tab.schema_id) + '.' + fk_tab.name,
schema_name(pk_tab.schema_id) + '.' + pk_tab.name,
fk_cols.constraint_column_id