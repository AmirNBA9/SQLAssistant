--------------------------------------------------------------------
/*
پرکاربردترین Data Typeها در یک دیتابیس

Data_Type: انواع داده‌ای Built-In و یا تعریف شده توسط کاربر(User-Defined) بدون ذکر طول و دقت نوع داده‌ای, به طور مثال Int ,Varchar یا Date
 Columns: تعداد ستون‌های یک دیتابیس با این نوع داده‌ای خاص
 Percent_Columns: نسبت تعداد ستون‌هایی با این نوع داده‌ای خاص به کل ستون‌های دیتابیس(مجموع این ستون برابر 100 خواهد بود).
 Tables: تعداد جداول موجود در یک دیتابیس که از این Data Type خاص استفاده کرده‌اند
 Percent_Tables: نسبت تعداد جداول دارای ستون‌‍هایی با این نوع داده‌ای خاص به کل جداول دیتابیس
*/
--------------------------------------------------------------------
select t.name as data_type,
count(*) as [columns],
cast(100.0 * count(*) /
(select count(*) from sys.tables tab inner join
sys.columns as col on tab.object_id = col.object_id)
as numeric(36, 1)) as percent_columns,
count(distinct tab.object_id) as [tables],
cast(100.0 * count(distinct tab.object_id) /
(select count(*) from sys.tables) as numeric(36, 1)) as percent_tables
from sys.tables as tab
inner join sys.columns as col
on tab.object_id = col.object_id
left join sys.types as t
on col.user_type_id = t.user_type_id
group by t.name
order by count(*) desc