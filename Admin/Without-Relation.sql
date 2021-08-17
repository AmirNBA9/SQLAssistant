--------------------------------------------------------------------
/*
 درصد جداول Loner – تعداد جداول فاقد ارتباط

Table_Count: تعداد جداول یک دیتابیس
Loner_Tables: تعداد Loner_Tablesهای دیتابیس
Loner_Ratio: نسبت جداول Loner به کل جداول
*/
--------------------------------------------------------------------
select count(*) [table_count],
sum(case when fks.cnt + refs.cnt = 0 then 1 else 0 end)
as [loner_tables],
cast(cast(100.0 * sum(case when fks.cnt + refs.cnt = 0 then 1 else 0 end)
/ count(*) as decimal(36, 1)) as varchar) + '%' as [loner_ratio]
from (select schema_name(tab.schema_id) + '.' + tab.name as tab,
count(fk.name) cnt
from sys.tables as tab
left join sys.foreign_keys as fk
on tab.object_id = fk.parent_object_id
group by schema_name(tab.schema_id), tab.name) fks
inner join
(select schema_name(tab.schema_id) + '.' + tab.name as tab,
count(fk.name) cnt
from sys.tables as tab
left join sys.foreign_keys as fk
on tab.object_id = fk.referenced_object_id
group by schema_name(tab.schema_id), tab.name) refs
on fks.tab = refs.tab