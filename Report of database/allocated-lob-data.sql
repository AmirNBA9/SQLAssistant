--------------------------------------------------------------------
/*
Allocation_type: نوع فضای تخصیص یافته
	LOB Data: فضای تخصیصی به ستون‌های داده ای LOB
	Regular Data: فضای تخصیصی به سایر ستون‌ها

Used_mb: فضای استفاده شده (به مگابایت)
Allocated_mb: فضای تخصیص یافته (به مگابایت)
*/
--------------------------------------------------------------------
SELECT CASE
           WHEN spc.type IN ( 1, 3 ) THEN
               'Regular data'
           ELSE
               'LOB data'
       END AS allocation_type,
       CAST(SUM(spc.used_pages * 8) / 1024.00 AS NUMERIC(36, 2)) AS used_mb,
       CAST(SUM(spc.total_pages * 8) / 1024.00 AS NUMERIC(36, 2)) AS allocated_mb
FROM sys.tables tab
    INNER JOIN sys.indexes ind
        ON tab.object_id = ind.object_id
    INNER JOIN sys.partitions part
        ON ind.object_id = part.object_id
           AND ind.index_id = part.index_id
    INNER JOIN sys.allocation_units spc
        ON part.partition_id = spc.container_id
GROUP BY CASE
             WHEN spc.type IN ( 1, 3 ) THEN
                 'Regular data'
             ELSE
                 'LOB data'
         END;