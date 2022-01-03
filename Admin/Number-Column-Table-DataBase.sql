--------------------------------------------------------------------
/*
بدست آوردن تعداد ستون‌های موجود در دیتابیس

Columns: مجموع تعداد ستون‌های یک دیتابیس
Tables : تعداد جداول یک دیتابیس
Average_Column_Count: میانگین تعداد ستون‌های موجود در جداول یک دیتابیس
*/
--------------------------------------------------------------------
SELECT [columns],
       [tables],
       CONVERT(DECIMAL(10, 2), 1.0 * [columns] / [tables]) AS average_column_count
FROM
(
    SELECT COUNT(*) [columns],
           COUNT(DISTINCT SCHEMA_NAME(tab.schema_id) + tab.name) AS [tables]
    FROM sys.tables AS tab
        INNER JOIN sys.columns AS col
            ON tab.object_id = col.object_id
) q;