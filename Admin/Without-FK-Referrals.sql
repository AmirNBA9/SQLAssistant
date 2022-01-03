--------------------------------------------------------------------
/*
 لیست جداولی که توسط هیچ FK مورد ارجاع قرار نگرفته‌اند
*/
--------------------------------------------------------------------
SELECT 'No FKs >-' foreign_keys,
       SCHEMA_NAME(fk_tab.schema_id) AS schema_name,
       fk_tab.name AS table_name
FROM sys.tables fk_tab
    LEFT OUTER JOIN sys.foreign_keys fk
        ON fk_tab.object_id = fk.referenced_object_id
WHERE fk.object_id IS NULL
ORDER BY SCHEMA_NAME(fk_tab.schema_id),
         fk_tab.name;