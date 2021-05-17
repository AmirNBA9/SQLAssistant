--------------------------------------------------------------------
/*
لیست جداول با بیشترین تعداد Foreign Key

Table: نام جدول به همراه نام Schema
Foreign_keys: تعداد Foreign Keyهای جدول
Referenced_Tables: تعداد جداول مورد ارجاع. این عدد ممکن است الزاما با تعداد FKها برابر نباشد. ممکن است در یک جدول چندین FK به یک جدول ارجاع داده شوند, همانند ارجاعات چندگانه یک جدول به جدول DimDate
*/
--------------------------------------------------------------------
select schema_name(fk_tab.schema_id) + '.' + fk_tab.name as [table],
count(*) foreign_keys,
count (distinct referenced_object_id) referenced_tables
from sys.foreign_keys fk
inner join sys.tables fk_tab
on fk_tab.object_id = fk.parent_object_id
group by schema_name(fk_tab.schema_id) + '.' + fk_tab.name
order by count(*) desc