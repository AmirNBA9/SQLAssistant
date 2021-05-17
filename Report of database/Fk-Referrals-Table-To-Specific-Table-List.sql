--------------------------------------------------------------------
/*
لیست جداول ارجاع کننده به یک جدول خاص (توسط FK)

Foreign_Table: نام جدول خارجی به همراه Schema
Rel: نماد ارتباط, مشخص کننده Foreign Key و جهت ارتباط
Primary_Table: نام جدول اصلی (مورد ارجاع) به همراه Schema; جدولی که به عنوان پارامتر داده شده است
*/
--------------------------------------------------------------------
select distinct
schema_name(fk_tab.schema_id) + '.' + fk_tab.name as foreign_table,
'>-' as rel,
schema_name(pk_tab.schema_id) + '.' + pk_tab.name as primary_table
from sys.foreign_keys fk
inner join sys.tables fk_tab
on fk_tab.object_id = fk.parent_object_id
inner join sys.tables pk_tab
on pk_tab.object_id = fk.referenced_object_id
where pk_tab.[name] = 'Your table' -- enter table name here
-- and schema_name(pk_tab.schema_id) = 'Your table schema name'
order by schema_name(fk_tab.schema_id) + '.' + fk_tab.name,
schema_name(pk_tab.schema_id) + '.' + pk_tab.name