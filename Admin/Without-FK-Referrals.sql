--------------------------------------------------------------------
/*
 لیست جداولی که توسط هیچ FK مورد ارجاع قرار نگرفته‌اند
*/
--------------------------------------------------------------------
select 'No FKs >-' foreign_keys,
schema_name(fk_tab.schema_id) as schema_name,
fk_tab.name as table_name
from sys.tables fk_tab
left outer join sys.foreign_keys fk
on fk_tab.object_id = fk.referenced_object_id
where fk.object_id is null
order by schema_name(fk_tab.schema_id),
fk_tab.name