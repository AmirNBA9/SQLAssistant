IF OBJECT_ID('[dba].[PartitionDetails]') IS NOT NULL
	DROP PROCEDURE [dba].[PartitionDetails];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE       PROCEDURE [dba].[PartitionDetails]
AS
BEGIN
	SET NOCOUNT ON

    SELECT  OBJECT_SCHEMA_NAME(pstats.object_id) AS SchemaName, OBJECT_NAME(pstats.object_id) AS TableName, ps.name AS PartitionSchemeName, ds.name AS PartitionFilegroupName,
        pf.name AS PartitionFunctionName, CASE pf.boundary_value_on_right
                                              WHEN 0
                                                  THEN 'Range Left' ELSE 'Range Right'
                                          END AS PartitionFunctionRange, CASE pf.boundary_value_on_right
                                                                             WHEN 0
                                                                                 THEN 'Upper Boundary' ELSE 'Lower Boundary'
                                                                         END AS PartitionBoundary, prv.value AS PartitionBoundaryValue, c.name AS PartitionKey,
        CASE
            WHEN pf.boundary_value_on_right = 0
                THEN c.name + ' > ' + CAST(ISNULL(LAG(prv.value) OVER (PARTITION BY pstats.object_id
                                                                           ORDER BY pstats.object_id, pstats.partition_number), 'Infinity') AS VARCHAR(100)) + ' and ' + c.name
                     + ' <= ' + CAST(ISNULL(prv.value, 'Infinity') AS VARCHAR(100))ELSE
                                                                                       c.name + ' >= ' + CAST(ISNULL(prv.value, 'Infinity') AS VARCHAR(100)) + ' and ' + c.name
                                                                                       + ' < '
                                                                                       + CAST(ISNULL(
                                                                                                  LEAD(prv.value) OVER (PARTITION BY pstats.object_id
                                                                                                                            ORDER BY pstats.object_id, pstats.partition_number),
                                                                                                  'Infinity') AS VARCHAR(100))
        END AS PartitionRange, pstats.partition_number AS PartitionNumber, pstats.row_count AS PartitionRowCount, p.data_compression_desc AS DataCompression
      FROM  sys.dm_db_partition_stats AS pstats
            INNER JOIN sys.partitions AS p ON pstats.partition_id = p.partition_id
            INNER JOIN sys.destination_data_spaces AS dds ON pstats.partition_number = dds.destination_id
            INNER JOIN sys.data_spaces AS ds ON dds.data_space_id = ds.data_space_id
            INNER JOIN sys.partition_schemes AS ps ON dds.partition_scheme_id = ps.data_space_id
            INNER JOIN sys.partition_functions AS pf ON ps.function_id = pf.function_id
            INNER JOIN sys.indexes AS i ON pstats.object_id = i.object_id AND   pstats.index_id = i.index_id AND dds.partition_scheme_id = i.data_space_id AND  i.type <= 1 /* Heap or Clustered Index */
            INNER JOIN sys.index_columns AS ic ON i.index_id = ic.index_id AND  i.object_id = ic.object_id AND  ic.partition_ordinal > 0
            INNER JOIN sys.columns AS c ON pstats.object_id = c.object_id AND   ic.column_id = c.column_id
            LEFT JOIN sys.partition_range_values AS prv ON pf.function_id = prv.function_id AND pstats.partition_number = (CASE pf.boundary_value_on_right
                                                                                                                               WHEN 0
                                                                                                                                   THEN prv.boundary_id ELSE (prv.boundary_id + 1)
                                                                                                                           END)
     ORDER BY TableName, PartitionNumber;
END;
GO
