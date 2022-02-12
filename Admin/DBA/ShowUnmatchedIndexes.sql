IF OBJECT_ID('[dba].[ShowUnmatchedIndexes]') IS NOT NULL
	DROP PROCEDURE [dba].[ShowUnmatchedIndexes];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE         PROCEDURE [dba].[ShowUnmatchedIndexes]
AS
BEGIN;
    WITH PlanCached
        AS (SELECT  qp.query_plan, qt.text, statement_start_offset, statement_end_offset, creation_time, last_execution_time, execution_count,
                total_worker_time, last_worker_time, min_worker_time, max_worker_time, total_physical_reads, last_physical_reads, min_physical_reads,
                max_physical_reads, total_logical_writes, last_logical_writes, min_logical_writes, max_logical_writes, total_logical_reads, last_logical_reads,
                min_logical_reads, max_logical_reads, total_elapsed_time, last_elapsed_time, min_elapsed_time, max_elapsed_time, total_rows, last_rows,
                min_rows, max_rows
              FROM  sys.dm_exec_query_stats
                    CROSS APPLY sys.dm_exec_sql_text(sql_handle) qt
                    CROSS APPLY sys.dm_exec_query_plan(plan_handle) qp
             WHERE  qp.dbid = DB_ID())
    SELECT  [text], query_plan.value('((//UnmatchedIndexes)[1]/Parameterization/Object/@Schema)[1]', 'varchar(100)') AS [Schema],
        query_plan.value('((//UnmatchedIndexes)[1]/Parameterization/Object/@Table)[1]', 'varchar(100)') AS [Table],
        query_plan.value('((//UnmatchedIndexes)[1]/Parameterization/Object/@Index)[1]', 'varchar(100)') AS [Index]
      FROM  PlanCached
     WHERE  query_plan.exist('//UnmatchedIndexes') = 1;

END;

GO
