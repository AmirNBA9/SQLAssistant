--02
USE tempdb
GO
--بررسی جهت وجود جدول 
IF OBJECT_ID('SalesOrderHeader2')>0
	DROP TABLE SalesOrderHeader2
GO
--تهیه کپی از جدول
SELECT * INTO SalesOrderHeader2 FROM AdventureWorks2012.Sales.SalesOrderHeader
GO
--ایجاد یک کلاستر ایندکس
CREATE CLUSTERED INDEX Clustered_Index ON SalesOrderHeader2(SalesOrderID)
GO
CREATE INDEX IX01 ON SalesOrderHeader2(CustomerID)
CREATE INDEX IX02 ON SalesOrderHeader2(CustomerID,OrderDate)
CREATE INDEX IX03 ON SalesOrderHeader2(OrderDate,CustomerID)
GO
--------------------------------------------------------------------------------------------------------------
--نوع اول
--------------------------------------------------------------------------------------------------------------
;with ind as (
    select  a.object_id
    ,       a.index_id
    ,       cast(col_list.list as varchar(max)) as list
    from    (
            select  distinct object_id
            ,       index_id
            from    sys.index_columns
            ) a
    cross apply
            (
            select  cast(column_id as varchar(16)) + ',' as [text()]
            from    sys.index_columns b
            where   a.object_id = b.object_id
                    and a.index_id = b.index_id
            for xml path(''), type
            ) col_list (list)
)
select  object_name(a.object_id) as TableName
,       asi.name as FatherIndex
,       bsi.name as RedundantIndex
from    ind a
join    sys.sysindexes asi
on      asi.id = a.object_id
        and asi.indid = a.index_id
join    ind b
on      a.object_id = b.object_id
        and a.object_id = b.object_id
        and len(a.list) > len(b.list)
        and left(a.list, LEN(b.list)) = b.list
join    sys.sysindexes bsi
on      bsi.id = b.object_id
        and bsi.indid = b.index_id
--------------------------------------------------------------------------------------------------------------
--نوع دوم
--------------------------------------------------------------------------------------------------------------




WITH IndexColumns AS
(
    SELECT I.object_id AS TableObjectId, OBJECT_SCHEMA_NAME(I.object_id) + '.' + OBJECT_NAME(I.object_id) AS TableName, I.index_id AS IndexId, I.name AS IndexName
        , (IndexUsage.user_seeks + IndexUsage.user_scans + IndexUsage.user_lookups) AS IndexUsage
        , IndexUsage.user_updates AS IndexUpdates

       , (SELECT CASE is_included_column WHEN 1 THEN NULL ELSE column_id END AS [data()]
        FROM sys.index_columns AS IndexColumns
        WHERE IndexColumns.object_id = I.object_id
          AND IndexColumns.index_id = I.index_id
        ORDER BY index_column_id, column_id
        FOR XML PATH('')
       ) AS ConcIndexColumnNrs

       ,(SELECT CASE is_included_column WHEN 1 THEN NULL ELSE COL_NAME(I.object_id, column_id) END AS [data()]
        FROM sys.index_columns AS IndexColumns
        WHERE IndexColumns.object_id = I.object_id
          AND IndexColumns.index_id = I.index_id
        ORDER BY index_column_id, column_id
        FOR XML PATH('')
       ) AS ConcIndexColumnNames

       ,(SELECT CASE is_included_column WHEN 1 THEN column_id ELSE NULL END AS [data()]
        FROM sys.index_columns AS IndexColumns
        WHERE IndexColumns.object_id = I.object_id
        AND IndexColumns.index_id = I.index_id
        ORDER BY column_id
        FOR XML PATH('')
       ) AS ConcIncludeColumnNrs

       ,(SELECT CASE is_included_column WHEN 1 THEN COL_NAME(I.object_id, column_id) ELSE NULL END AS [data()]
        FROM sys.index_columns AS IndexColumns
        WHERE IndexColumns.object_id = I.object_id
          AND IndexColumns.index_id = I.index_id
        ORDER BY column_id
        FOR XML PATH('')
       ) AS ConcIncludeColumnNames
    FROM sys.indexes AS I
       LEFT OUTER JOIN sys.dm_db_index_usage_stats AS IndexUsage
        ON IndexUsage.object_id = I.object_id
          AND IndexUsage.index_id = I.index_id
          AND IndexUsage.Database_id = db_id() 
)
SELECT
  C1.TableName
  , C1.IndexName AS 'Index1'
  , C2.IndexName AS 'Index2'
  , CASE WHEN (C1.ConcIndexColumnNrs = C2.ConcIndexColumnNrs) AND (C1.ConcIncludeColumnNrs = C2.ConcIncludeColumnNrs) THEN 'Exact duplicate'
        WHEN (C1.ConcIndexColumnNrs = C2.ConcIndexColumnNrs) THEN 'Different includes'
        ELSE 'Overlapping columns' END
--  , C1.ConcIndexColumnNrs
--  , C2.ConcIndexColumnNrs
  , C1.ConcIndexColumnNames
  , C2.ConcIndexColumnNames
--  , C1.ConcIncludeColumnNrs
--  , C2.ConcIncludeColumnNrs
  , C1.ConcIncludeColumnNames
  , C2.ConcIncludeColumnNames
  , C1.IndexUsage
  , C2.IndexUsage
  , C1.IndexUpdates
  , C2.IndexUpdates
  , 'DROP INDEX ' + C2.IndexName + ' ON ' + C2.TableName AS Drop2
  , 'DROP INDEX ' + C1.IndexName + ' ON ' + C1.TableName AS Drop1
FROM IndexColumns AS C1
  INNER JOIN IndexColumns AS C2 
    ON (C1.TableObjectId = C2.TableObjectId)
    AND (
         -- exact: show lower IndexId as 1
            (C1.IndexId < C2.IndexId
            AND C1.ConcIndexColumnNrs = C2.ConcIndexColumnNrs
            AND C1.ConcIncludeColumnNrs = C2.ConcIncludeColumnNrs)
         -- different includes: show longer include as 1
         OR (C1.ConcIndexColumnNrs = C2.ConcIndexColumnNrs
            AND LEN(C1.ConcIncludeColumnNrs) > LEN(C2.ConcIncludeColumnNrs))
         -- overlapping: show longer index as 1
         OR (C1.IndexId <> C2.IndexId
            AND C1.ConcIndexColumnNrs <> C2.ConcIndexColumnNrs
            AND C1.ConcIndexColumnNrs like C2.ConcIndexColumnNrs + ' %')
    )
ORDER BY C1.TableName, C1.ConcIndexColumnNrs