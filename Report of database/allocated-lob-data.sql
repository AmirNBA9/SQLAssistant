--------------------------------------------------------------------
/*
Allocation_type: نوع فضای تخصیص یافته
	LOB Data: فضای تخصیصی به ستون‌های داده ای LOB
	Regular Data: فضای تخصیصی به سایر ستون‌ها

Used_mb: فضای استفاده شده (به مگابایت)
Allocated_mb: فضای تخصیص یافته (به مگابایت)
*/
--------------------------------------------------------------------
select case when spc.type in (1, 3) then 'Regular data'
else 'LOB data' end as allocation_type,
cast(sum(spc.used_pages * 8) / 1024.00 as numeric(36, 2)) as used_mb,
cast(sum(spc.total_pages * 8) / 1024.00 as numeric(36, 2)) as allocated_mb
from sys.tables tab
inner join sys.indexes ind
on tab.object_id = ind.object_id
inner join sys.partitions part
on ind.object_id = part.object_id and ind.index_id = part.index_id
inner join sys.allocation_units spc
on part.partition_id = spc.container_id
group by case when spc.type in (1, 3) then 'Regular data'
else 'LOB data' end