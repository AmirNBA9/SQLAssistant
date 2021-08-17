
select isnull(db1.table_name, db2.table_name) as [table],
isnull(db1.column_name, db2.column_name) as [column],
db1.column_name as database1,
db2.column_name as database2
from
(select schema_name(tab.schema_id) + '.' + tab.name as table_name,
col.name as column_name
from AhooraDB.sys.tables as tab
inner join AhooraDB.sys.columns as col
on tab.object_id = col.object_id) db1
full outer join
(select schema_name(tab.schema_id) + '.' + tab.name as table_name,
col.name as column_name
from [AhooraDB990626].sys.tables as tab
inner join [AhooraDB990626].sys.columns as col
on tab.object_id = col.object_id) db2
on db1.table_name = db2.table_name
and db1.column_name = db2.column_name
where (db1.column_name is null or db2.column_name is null)
order by 1, 2, 3