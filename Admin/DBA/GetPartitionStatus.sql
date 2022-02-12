IF OBJECT_ID('[dba].[GetPartitionStatus]') IS NOT NULL
	DROP PROCEDURE [dba].[GetPartitionStatus];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE       PROCEDURE [dba].[GetPartitionStatus]
AS
BEGIN
    SELECT  OBJECT_NAME(i.object_id) AS Object_Name, p.partition_number, fg.name AS Filegroup_Name, rows, au.total_pages,
        CASE boundary_value_on_right
            WHEN 1
                THEN 'less than' ELSE 'less than or equal to'
        END AS 'comparison', value
      FROM  sys.partitions p
            JOIN sys.indexes i ON p.object_id = i.object_id AND p.index_id = i.index_id
            JOIN sys.partition_schemes ps ON ps.data_space_id = i.data_space_id
            JOIN sys.partition_functions f ON f.function_id = ps.function_id
            LEFT JOIN sys.partition_range_values rv ON f.function_id = rv.function_id AND   p.partition_number = rv.boundary_id
            JOIN sys.destination_data_spaces dds ON dds.partition_scheme_id = ps.data_space_id AND  dds.destination_id = p.partition_number
            JOIN sys.filegroups fg ON dds.data_space_id = fg.data_space_id
            JOIN (   SELECT container_id, SUM(total_pages) AS total_pages
                       FROM sys.allocation_units
                      GROUP BY container_id) AS au ON au.container_id = p.partition_id
     WHERE  i.index_id < 2;

    SELECT  DB_NAME() AS 'DatabaseName', OBJECT_NAME(p.object_id) AS 'TableName', p.index_id AS 'IndexId', CASE
                                                                                                               WHEN p.index_id = 0
                                                                                                                   THEN 'HEAP' ELSE i.name
                                                                                                           END AS 'IndexName',
        p.partition_number AS 'PartitionNumber', prv_left.value AS 'LowerBoundary', prv_right.value AS 'UpperBoundary', ps.name AS PartitionScheme,
        pf.name AS PartitionFunction, CASE
                                          WHEN fg.name IS NULL
                                              THEN ds.name ELSE fg.name
                                      END AS 'FileGroupName', CAST(p.used_page_count * 0.0078125 AS NUMERIC(18, 2)) AS 'UsedPages_MB',
        CAST(p.in_row_data_page_count * 0.0078125 AS NUMERIC(18, 2)) AS 'DataPages_MB',
        CAST(p.reserved_page_count * 0.0078125 AS NUMERIC(18, 2)) AS 'ReservedPages_MB', CASE
                                                                                             WHEN p.index_id IN ( 0, 1 )
                                                                                                 THEN p.row_count ELSE 0
                                                                                         END AS 'RowCount', CASE
                                                                                                                WHEN p.index_id IN ( 0, 1 )
                                                                                                                    THEN 'data' ELSE 'index'
                                                                                                            END 'Type'
      FROM  sys.dm_db_partition_stats p
            INNER JOIN sys.indexes i ON i.object_id = p.object_id AND   i.index_id = p.index_id
            INNER JOIN sys.data_spaces ds ON ds.data_space_id = i.data_space_id
            LEFT OUTER JOIN sys.partition_schemes ps ON ps.data_space_id = i.data_space_id
            LEFT OUTER JOIN sys.partition_functions pf ON ps.function_id = pf.function_id
            LEFT OUTER JOIN sys.destination_data_spaces dds ON dds.partition_scheme_id = ps.data_space_id AND   dds.destination_id = p.partition_number
            LEFT OUTER JOIN sys.filegroups fg ON fg.data_space_id = dds.data_space_id
            LEFT OUTER JOIN sys.partition_range_values prv_right ON prv_right.function_id = ps.function_id AND  prv_right.boundary_id = p.partition_number
            LEFT OUTER JOIN sys.partition_range_values prv_left ON prv_left.function_id = ps.function_id AND prv_left.boundary_id = p.partition_number - 1
     WHERE  OBJECTPROPERTY(p.object_id, 'ISMSSHipped') = 0 AND  p.index_id IN ( 0, 1 );

END;
GO
