--------------------------------------------------------------------
/*
لیست جداول بدون ارتباط Loner Tables
*/
--------------------------------------------------------------------
SELECT 'No FKs >-' AS refs,
       fks.tab AS [table],
       '>- no FKs' AS fks
FROM
(
    SELECT SCHEMA_NAME(tab.schema_id) + '.' + tab.name AS tab,
           COUNT(fk.name) AS fk_cnt
    FROM sys.tables AS tab
        LEFT JOIN sys.foreign_keys AS fk
            ON tab.object_id = fk.parent_object_id
    GROUP BY SCHEMA_NAME(tab.schema_id),
             tab.name
) fks
    INNER JOIN
    (
        SELECT SCHEMA_NAME(tab.schema_id) + '.' + tab.name AS tab,
               COUNT(fk.name) ref_cnt
        FROM sys.tables AS tab
            LEFT JOIN sys.foreign_keys AS fk
                ON tab.object_id = fk.referenced_object_id
        GROUP BY SCHEMA_NAME(tab.schema_id),
                 tab.name
    ) refs
        ON fks.tab = refs.tab
WHERE fks.fk_cnt + refs.ref_cnt = 0;