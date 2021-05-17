--------------------------------------------------------------------
/*
 خلاصه‌ای از Default Constraint‍ های تعریف شده در یک دیتابیس
 
Default_Definition: مقدار/فرمول تعیین شده برای Default Constraint; برای ستون‎های فاقد این نوع Constraint مقدار Null نمایش داده خواهد شد.
Tables: تعداد جداول دارای این نوع Cconstraint (در مورد سطر Null در جواب دستور: تعداد جداولی که دارای ستونی فاقد Constraint هستند نمایش می‌دهد).
Columns: تعداد ستون‌هایی که دارای این نوع Constraint می‌باشند (برای مقدار Null: تعداد ستون‌های فاقد ژonstraint نمایش می‌دهد).
*/
--------------------------------------------------------------------
select
con.[definition] as default_definition,
count(distinct t.object_id) as [tables],
count(col.column_id) as [columns]
from sys.objects t
inner join sys.all_columns col
on col.object_id = t.object_id
left outer join sys.default_constraints con
on con.parent_object_id = t.object_id
and con.parent_column_id = col.column_id
where t.type = 'U'
group by con.[definition]
order by [columns] desc, [tables] desc