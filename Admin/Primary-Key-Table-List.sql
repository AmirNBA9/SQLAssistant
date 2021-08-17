--------------------------------------------------------------------
/*
Table: نام جدول به همراه نام schema
Relationships: تعداد ارتباطات (FK ها و FK reference ها)
Foreign_Keys: تعداد FK های یک جدول
References: تعداد FK reference ها از جداول دیگر
Related_Tables: تعداد جداول متمایز شرکت کننده در relation (فارق از نوع ارتباط)
referenced_tables: تعداد جداول متمایزی که جدول مورد نظر توسط FK ها به آنها رجوع کرده است (Primary Table) (توجه داشته باشید که یک جدول ممکن است چندین بار توسط جدولی مورد ارجاع قرار گیرد بنابراین تعداد FK ها و تعداد جداول مورد ارجاع میتواند یکسان نباشد)
Referencing_Tables: تعداد جداول متمایزی که به جدول مورد نظر ارجاع داده اند
*/
--------------------------------------------------------------------
select schema_name(tab.schema_id) as [schema_name],
tab.[name] as table_name,
pk.[name] as pk_name,
substring(column_names, 1, len(column_names)-1) as [columns]
from sys.tables tab
left outer join sys.indexes pk
on tab.object_id = pk.object_id
and pk.is_primary_key = 1
cross apply (select col.[name] + ', '
from sys.index_columns ic
inner join sys.columns col
on ic.object_id = col.object_id
and ic.column_id = col.column_id
where ic.object_id = tab.object_id
and ic.index_id = pk.index_id
order by col.column_id
for xml path ('') ) D (column_names)
order by schema_name(tab.schema_id),
tab.[name]