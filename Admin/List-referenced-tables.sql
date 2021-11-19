--------------------------------------------------------------------
/*
لیست جداول همراه با تعداد ارجاعات (پر ارجاع ترین جداول)

Table: نام جدول به همراه نام شمای آن
References: تعداد Foreign keyهایی که به این جدول ارجاع داده‌اند
Referencing_tables: تعداد جداول متمایزی که به این جدول ارجاع داده اند .گاهی اوقات ممکن است یک جدول از طریق چندین فیلد به یک جدول ارجاع داده شود, مانند جدول DimDate در DatawareHouseها
*/
--------------------------------------------------------------------
SELECT
	SCHEMA_NAME(tab.schema_id) + '.' + tab.Name AS [table]
   ,COUNT(fk.Name) AS [references]
   ,COUNT(DISTINCT fk.parent_object_id) AS referencing_tables
FROM sys.tables AS tab
	LEFT JOIN sys.foreign_keys AS fk ON tab.object_id = fk.referenced_object_id
GROUP BY SCHEMA_NAME(tab.schema_id) ,tab.Name
HAVING COUNT(fk.Name) <> 0
ORDER BY 2 DESC
