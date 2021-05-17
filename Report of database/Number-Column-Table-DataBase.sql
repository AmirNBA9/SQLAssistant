--------------------------------------------------------------------
/*
بدست آوردن تعداد ستون‌های موجود در دیتابیس

Columns: مجموع تعداد ستون‌های یک دیتابیس
Tables : تعداد جداول یک دیتابیس
Average_Column_Count: میانگین تعداد ستون‌های موجود در جداول یک دیتابیس
*/
--------------------------------------------------------------------
select [columns],
[tables],
CONVERT(DECIMAL(10,2),1.0*[columns]/[tables]) as average_column_count
from (
select count(*) [columns],
count(distinct schema_name(tab.schema_id) + tab.name) as [tables]
from sys.tables as tab
inner join sys.columns as col
on tab.object_id = col.object_id
) q