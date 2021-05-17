--------------------------------------------------------------------
/*
لیست جداول با بیشترین ارتباطات (Relationship)

Table: نام جدول به همراه نام schema
Relationships: تعداد ارتباطات (FK ها و FK reference ها)
Foreign_Keys: تعداد FK های یک جدول
References: تعداد FK reference ها از جداول دیگر
Related_Tables: تعداد جداول متمایز شرکت کننده در relation (فارق از نوع ارتباط)
referenced_tables: تعداد جداول متمایزی که جدول مورد نظر توسط FK ها به آنها رجوع کرده است (Primary Table) (توجه داشته باشید که یک جدول ممکن است چندین بار توسط جدولی مورد ارجاع قرار گیرد بنابراین تعداد FK ها و تعداد جداول مورد ارجاع میتواند یکسان نباشد)
Referencing_Tables: تعداد جداول متمایزی که به جدول مورد نظر ارجاع داده اند
*/
--------------------------------------------------------------------
select tab as [table],
count(distinct rel_name) as relationships,
count(distinct fk_name) as foreign_keys,
count(distinct ref_name) as [references],
count(distinct rel_object_id) as related_tables,
count(distinct referenced_object_id) as referenced_tables,
count(distinct parent_object_id) as referencing_tables
from
(select schema_name(tab.schema_id) + '.' + tab.name as tab,
fk.name as rel_name,
fk.referenced_object_id as rel_object_id,
fk.name as fk_name,
fk.referenced_object_id,
null as ref_name,
null as parent_object_id
from sys.tables as tab
left join sys.foreign_keys as fk
on tab.object_id = fk.parent_object_id
union all
select schema_name(tab.schema_id) + '.' + tab.name as tab,
fk.name as rel_name,
fk.parent_object_id as rel_object_id,
null as fk_name,
null as referenced_object_id,
fk.name as ref_name,
fk.parent_object_id
from sys.tables as tab
left join sys.foreign_keys as fk
on tab.object_id = fk.referenced_object_id) q
group by tab
order by count(distinct rel_name) desc
