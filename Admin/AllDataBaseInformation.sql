/*
Find all database recomended detail on a server is active
*/
DECLARE @ServerVersion INT = (LEFT(CONVERT (VARCHAR(128), SERVERPROPERTY ('ProductVersion')), 2));

IF @ServerVersion >= 14
BEGIN
	EXEC ('SELECT	SERVERPROPERTY (''ServerName'') AS ServerName, DB.database_id AS DatabaseId, DB.[name] AS DatabaseName, DF.DataFilesCount AS DataFilesCount, DF.DataSize_GB AS DataSize_GB,
		   DF.LogFilesCount AS LogFilesCount, DF.LogSize_GB AS LogSize_GB, DB.user_access_desc AS UserAccessType, DB.state_desc AS DatabaseState, DB.recovery_model_desc AS RecoveryModel,
		   DB.page_verify_option_desc AS PageVerifyOption, DB.[compatibility_level] AS CompatibilityLevel, DB.create_date AS CreateDate, DB.collation_name AS CollationNameDataBase,
		   DB.catalog_collation_type_desc AS CatalogCollationType, DB.snapshot_isolation_state_desc AS SnapshotIsolationStateDescription, DB.is_ansi_nulls_on AS IsAnsiNull,
		   DB.is_ansi_warnings_on AS IsAnsiWarning, DB.is_fulltext_enabled AS FullTextState, DB.is_trustworthy_on AS TrustWorthyState, DB.is_master_key_encrypted_by_server AS MasterKeyServer,
		   DB.is_distributor AS Distreibutor, DB.is_read_committed_snapshot_on AS IsReadCommitedSnapshot, DB.is_auto_shrink_on AS IsAutoShrinkOn, DB.is_auto_create_stats_on AS IsAutoCreateStatsOn,
		   DB.is_auto_create_stats_incremental_on AS IsAutoCreateStatsIncrementalOn, -- Starting with SQL Server 2014 (12.x)
		   DB.is_auto_update_stats_on AS IsAutoUpdateStatsOn, DB.is_auto_update_stats_async_on AS IsAutoUpdateStatsAsyncOn, DB.is_published AS IsPublishedInReplication,
		   DB.is_temporal_history_retention_enabled AS TemporalHistpryRetention, DB.is_memory_optimized_enabled AS MemoryOptimized, DB.log_reuse_wait_desc AS LogReuseWait,
		   DB.is_cdc_enabled AS IsCdcEnabled,
		   CASE
			   WHEN group_database_id IS NULL -- Starting with SQL Server 2012 (11.x) and Azure SQL Database
		   THEN
				   0
			   ELSE 1
		   END AS IsPartOfAvailabilityGroup, is_accelerated_database_recovery_on AS IsAcceleratedDatabaseRecoveryOn -- Starting with SQL Server 2019 (15.x) and Azure SQL Database
  FROM	   sys.databases AS DB
		   CROSS APPLY (SELECT	COUNT (CASE WHEN [type] = 0 THEN [type] END) AS DataFilesCount,
								CAST(ROUND (CAST(SUM (CASE WHEN [type] = 0 THEN size END) AS DECIMAL(19, 2)) * 8.0 / 1024.0 / 1024.0, 2) AS DECIMAL(19, 2)) AS DataSize_GB,
								COUNT (CASE WHEN [type] = 1 THEN [type] END) AS LogFilesCount,
								CAST(ROUND (CAST(SUM (CASE WHEN [type] = 1 THEN size END) AS DECIMAL(19, 2)) * 8.0 / 1024.0 / 1024.0, 2) AS DECIMAL(19, 2)) AS LogSize_GB
						  FROM	sys.master_files AS MF
						  WHERE MF.database_id = DB.database_id) AS DF
  WHERE
		   DB.source_database_id IS NULL -- database snapshot has id for source database
	AND	   DB.is_read_only = 0
  ORDER BY DatabaseId ASC;');
END;
ELSE
BEGIN
	EXEC ('SELECT	SERVERPROPERTY (''ServerName'') AS ServerName, DB.database_id AS DatabaseId, DB.[name] AS DatabaseName, DF.DataFilesCount AS DataFilesCount, DF.DataSize_GB AS DataSize_GB,
		   DF.LogFilesCount AS LogFilesCount, DF.LogSize_GB AS LogSize_GB, DB.user_access_desc AS UserAccessType, DB.state_desc AS DatabaseState, DB.recovery_model_desc AS RecoveryModel,
		   DB.page_verify_option_desc AS PageVerifyOption, DB.[compatibility_level] AS CompatibilityLevel, DB.create_date AS CreateDate, DB.collation_name AS CollationNameDataBase,
		   ''NOT COMPATIBLE'' AS CatalogCollationType, DB.snapshot_isolation_state_desc AS SnapshotIsolationStateDescription, DB.is_ansi_nulls_on AS IsAnsiNull,
		   DB.is_ansi_warnings_on AS IsAnsiWarning, DB.is_fulltext_enabled AS FullTextState, DB.is_trustworthy_on AS TrustWorthyState, DB.is_master_key_encrypted_by_server AS MasterKeyServer,
		   DB.is_distributor AS Distreibutor, DB.is_read_committed_snapshot_on AS IsReadCommitedSnapshot, DB.is_auto_shrink_on AS IsAutoShrinkOn, DB.is_auto_create_stats_on AS IsAutoCreateStatsOn,
		   DB.is_auto_create_stats_incremental_on AS IsAutoCreateStatsIncrementalOn, -- Starting with SQL Server 2014 (12.x)
		   DB.is_auto_update_stats_on AS IsAutoUpdateStatsOn, DB.is_auto_update_stats_async_on AS IsAutoUpdateStatsAsyncOn, DB.is_published AS IsPublishedInReplication,
		   ''NOT COMPATIBLE'' AS TemporalHistpryRetention, ''NOT COMPATIBLE'' AS MemoryOptimized, DB.log_reuse_wait_desc AS LogReuseWait,
		   DB.is_cdc_enabled AS IsCdcEnabled,
		   CASE
			   WHEN group_database_id IS NULL -- Starting with SQL Server 2012 (11.x) and Azure SQL Database
		   THEN
				   0
			   ELSE 1
		   END AS IsPartOfAvailabilityGroup, ''NOT COMPATIBLE'' AS IsAcceleratedDatabaseRecoveryOn -- Starting with SQL Server 2019 (15.x) and Azure SQL Database
  FROM	   sys.databases AS DB
		   CROSS APPLY (SELECT	COUNT (CASE WHEN [type] = 0 THEN [type] END) AS DataFilesCount,
								CAST(ROUND (CAST(SUM (CASE WHEN [type] = 0 THEN size END) AS DECIMAL(19, 2)) * 8.0 / 1024.0 / 1024.0, 2) AS DECIMAL(19, 2)) AS DataSize_GB,
								COUNT (CASE WHEN [type] = 1 THEN [type] END) AS LogFilesCount,
								CAST(ROUND (CAST(SUM (CASE WHEN [type] = 1 THEN size END) AS DECIMAL(19, 2)) * 8.0 / 1024.0 / 1024.0, 2) AS DECIMAL(19, 2)) AS LogSize_GB
						  FROM	sys.master_files AS MF
						  WHERE MF.database_id = DB.database_id) AS DF
  WHERE
		   DB.source_database_id IS NULL -- database snapshot has id for source database
	AND	   DB.is_read_only = 0
  ORDER BY DatabaseId ASC;');
END;
GO