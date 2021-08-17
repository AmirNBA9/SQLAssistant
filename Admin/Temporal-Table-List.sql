--------------------------------------------------------------------
/*
Temporal_Table_Schema: نام Schema جدول Temporal
 Temporal_Table_Name: نام جدول Temporal
 History_Table_Schema: نام Schema جدول تاریخچه
 History_Table_Name: نام جدول تاریخچه
 Retention_Period: مدت زمانی که تاریخچه تغییر اطلاعات نگهداری خواهد شد. این مقدار توسط DBA مشخص خواهد شد. به عنوان مثال مقادیر INFINITE, 6 MONTHS, 30 DAYS
*/
--------------------------------------------------------------------
select schema_name(t.schema_id) as temporal_table_schema,
t.name as temporal_table_name,
schema_name(h.schema_id) as history_table_schema,
h.name as history_table_name,
case when t.history_retention_period = -1
then 'INFINITE'
else cast(t.history_retention_period as varchar) + ' ' +
t.history_retention_period_unit_desc + 'S'
end as retention_period
from sys.tables t
left outer join sys.tables h
on t.history_table_id = h.object_id
where t.temporal_type = 2order by temporal_table_schema, temporal_table_name