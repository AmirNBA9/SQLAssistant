--------------------------------------------------------------------
/*
لیست جداول بدون ارتباط Loner Tables
*/
--------------------------------------------------------------------
select 'No FKs >-' refs,
fks.tab as [table],
'>- no FKs' fks
from
(select schema_name(tab.schema_id) + '.' + tab.name as tab,
count(fk.name) as fk_cnt
from sys.tables as tab
left join sys.foreign_keys as fk
on tab.object_id = fk.parent_object_id
group by schema_name(tab.schema_id), tab.name) fks
inner join
(select schema_name(tab.schema_id) + '.' + tab.name as tab,
count(fk.name) ref_cnt
from sys.tables as tab
left join sys.foreign_keys as fk
on tab.object_id = fk.referenced_object_id
group by schema_name(tab.schema_id), tab.name) refs
on fks.tab = refs.tab
where fks.fk_cnt + refs.ref_cnt = 0