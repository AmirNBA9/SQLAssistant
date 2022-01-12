--------------------------------------------------------------------
/*
Allocation_type: نوع فضای تخصیص یافته
	LOB Data: فضای تخصیصی به ستون‌های داده ای LOB
	Regular Data: فضای تخصیصی به سایر ستون‌ها

Used_mb: فضای استفاده شده (به مگابایت)
Allocated_mb: فضای تخصیص یافته (به مگابایت)
*/
--------------------------------------------------------------------
SELECT	   CASE
			   WHEN AU.type IN (1, 3) THEN 'Regular data'
			   ELSE 'LOB data'
		   END AS allocation_type, CAST(SUM (AU.used_pages * 8) / 1024.00 AS NUMERIC(36, 2)) AS Used_mb, CAST(SUM (AU.total_pages * 8) / 1024.00 AS NUMERIC(36, 2)) AS Allocated_mb
  FROM	   sys.tables T
		   INNER JOIN sys.indexes I ON T.object_id = I.object_id
		   INNER JOIN sys.partitions P ON I.object_id = P.object_id
									  AND I.index_id = P.index_id
		   INNER JOIN sys.allocation_units AU ON P.partition_id = AU.container_id
  GROUP BY CASE
			   WHEN AU.type IN (1, 3) THEN 'Regular data'
			   ELSE 'LOB data'
		   END;