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
SELECT t.name AS data_type,
       COUNT(*) AS [columns],
       CAST(100.0 * COUNT(*) /
            (
                SELECT COUNT(*)
                FROM sys.tables tab
                    INNER JOIN sys.columns AS col
                        ON tab.object_id = col.object_id
            ) AS NUMERIC(36, 1)) AS percent_columns,
       COUNT(DISTINCT tab.object_id) AS [tables],
       CAST(100.0 * COUNT(DISTINCT tab.object_id) /
            (
                SELECT COUNT(*) FROM sys.tables
            ) AS NUMERIC(36, 1)) AS percent_tables
FROM sys.tables AS tab
    INNER JOIN sys.columns AS col
        ON tab.object_id = col.object_id
    LEFT JOIN sys.types AS t
        ON col.user_type_id = t.user_type_id
GROUP BY t.name
ORDER BY COUNT(*) DESC;