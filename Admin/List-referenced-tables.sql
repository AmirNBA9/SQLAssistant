--------------------------------------------------------------------
/*
لیست جداول همراه با تعداد ارجاعات (پر ارجاع ترین جداول)

Table: نام جدول به همراه نام شمای آن
References: تعداد Foreign keyهایی که به این جدول ارجاع داده‌اند
Referencing_tables: تعداد جداول متمایزی که به این جدول ارجاع داده اند .گاهی اوقات ممکن است یک جدول از طریق چندین فیلد به یک جدول ارجاع داده شود, مانند جدول DimDate در DatawareHouseها
*/
--------------------------------------------------------------------
select schema_name(tab.schema_id) + '.' + tab.name as [table],
count(fk.name) as [references],
count(distinct fk.parent_object_id) as referencing_tables
from sys.tables as tab
left join sys.foreign_keys as fk
on tab.object_id = fk.referenced_object_id
group by schema_name(tab.schema_id), tab.name
having count(fk.name) <> 0
order by 2 desc
