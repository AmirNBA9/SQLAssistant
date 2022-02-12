;WITH waits
AS
    (SELECT wait_type, 100.0 * wait_time_ms / SUM (wait_time_ms) OVER () AS percent_total_waits, 100.0 * signal_wait_time_ms / SUM (signal_wait_time_ms) OVER () AS percent_total_signal_waits,
            100.0 * signal_wait_time_ms / wait_time_ms AS RowPercentSignalWait, wait_time_ms, signal_wait_time_ms, wait_time_ms - signal_wait_time_ms AS resource_wait_time_ms,
            100.0 * (wait_time_ms - signal_wait_time_ms) / SUM (wait_time_ms) OVER () AS percent_total_resource_waits
       FROM sys.dm_os_wait_stats
      WHERE wait_time_ms > 0 -- remove zero wait_time 
        AND wait_type NOT IN -- filter out additional irrelevant waits 
 ( 'SLEEP_TASK', 'BROKER_TASK_STOP', 'BROKER_TO_FLUSH', 'SQLTRACE_BUFFER_FLUSH', 'CLR_AUTO_EVENT', 'CLR_MANUAL_EVENT', 'LAZYWRITER_SLEEP', 'SLEEP_SYSTEMTASK', 'SLEEP_BPOOL_FLUSH',
   'BROKER_EVENTHANDLER', 'XE_DISPATCHER_WAIT', 'FT_IFTSHC_MUTEX', 'CHECKPOINT_QUEUE', 'FT_IFTS_SCHEDULER_IDLE_WAIT', 'BROKER_TRANSMITTER', 'FT_IFTSHC_MUTEX', 'KSOURCE_WAKEUP', 'LAZYWRITER_SLEEP',
   'LOGMGR_QUEUE', 'ONDEMAND_TASK_QUEUE', 'REQUEST_FOR_DEADLOCK_SEARCH', 'XE_TIMER_EVENT', 'BAD_PAGE_PROCESS', 'DBMIRROR_EVENTS_QUEUE', 'BROKER_RECEIVE_WAITFOR', 'PREEMPTIVE_OS_GETPROCADDRESS',
   'PREEMPTIVE_OS_AUTHENTICATIONOPS', 'WAITFOR', 'DISPATCHER_QUEUE_SEMAPHORE', 'XE_DISPATCHER_JOIN', 'OLEDB', 'RESOURCE_QUEUE', 'TRACEWRITE', 'SQLTRACE_INCREMENTAL_FLUSH_SLEEP', 'DBMIRRORING_CMD',
   'DBMIRROR_DBM_EVENT', 'DBMIRROR_DBM_MUTEX', 'DIRTY_PAGE_POLL', 'HADR_FILESTREAM_IOMGR_IOCOMPLETION', 'SP_SERVER_DIAGNOSTICS_SLEEP', 'WAIT_XTP_OFFLINE_CKPT_NEW_LOG',
   'QDS_CLEANUP_STALE_QUERIES_TASK_MAIN_LOOP_SLEEP', 'QDS_PERSIST_TASK_MAIN_LOOP_SLEEP' ))
SELECT *
  FROM waits
 ORDER BY waits.percent_total_waits DESC;