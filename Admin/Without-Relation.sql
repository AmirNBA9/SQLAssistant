--------------------------------------------------------------------
/*
 درصد جداول Loner – تعداد جداول فاقد ارتباط

Table_Count: تعداد جداول یک دیتابیس
Loner_Tables: تعداد Loner_Tablesهای دیتابیس
Loner_Ratio: نسبت جداول Loner به کل جداول
*/
--------------------------------------------------------------------
SELECT COUNT(*) [table_count],
       SUM(   CASE
                  WHEN fks.cnt + refs.cnt = 0 THEN
                      1
                  ELSE
                      0
              END
          ) AS [loner_tables],
       CAST(CAST(100.0 * SUM(   CASE
                                    WHEN fks.cnt + refs.cnt = 0 THEN
                                        1
                                    ELSE
                                        0
                                END
                            ) / COUNT(*) AS DECIMAL(36, 1)) AS VARCHAR) + '%' AS [loner_ratio]
FROM
(
    SELECT SCHEMA_NAME(tab.schema_id) + '.' + tab.name AS tab,
           COUNT(fk.name) cnt
    FROM sys.tables AS tab
        LEFT JOIN sys.foreign_keys AS fk
            ON tab.object_id = fk.parent_object_id
    GROUP BY SCHEMA_NAME(tab.schema_id),
             tab.name
) fks
    INNER JOIN
    (
        SELECT SCHEMA_NAME(tab.schema_id) + '.' + tab.name AS tab,
               COUNT(fk.name) cnt
        FROM sys.tables AS tab
            LEFT JOIN sys.foreign_keys AS fk
                ON tab.object_id = fk.referenced_object_id
        GROUP BY SCHEMA_NAME(tab.schema_id),
                 tab.name
    ) refs
        ON fks.tab = refs.tab;