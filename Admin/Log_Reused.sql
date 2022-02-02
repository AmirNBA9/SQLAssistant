/*
Why log is growth up
0- NOTHING : we don't have problem for growthup log
1- CHECKPOINT : Checkpoint (When a database has a memory-optimized data filegroup, you should expect to see the log_reuse_wait column indicate checkpoint or xtp_checkpoint)
2- LOG_BACKUP :
3- Active backup or restore
4- ACTIVE_TRANSACTION :
5- Database mirroring
6- REPLICATION :
7- DATABASE_SNAPSHOT_CREATION : Database snapshot creation
8- LOG_SCAN
9- AVAILABILITY_REPLICA : An Always On Availability Groups secondary replica is applying transaction log records of this database to a corresponding secondary database. 
10-12 For internal use only
13- Oldest page
14- Other 
15- XTP_CHECKPOINT : (When a database has a memory-optimized data filegroup, you should expect to see the log_reuse_wait column indicate checkpoint or xtp_checkpoint)
16- SLOG_SCAN : sLog scanning when Accelerated Database Recovery is used
* Log backup needs to be run (or if you could lose a day’s worth of data, throw this little fella in simple recovery mode)
* Active backup running – because the full backup needs the transaction log to be able to restore to a specific point in time
* Active transaction – somebody typed BEGIN TRAN and locked their workstation for the weekend
* Database mirroring, replication, or AlwaysOn Availability Groups – because these features need to hang onto transaction log data to send to another replica

*/

with fs
as
(
    select database_id, type, size * 8.0 / 1024 size
    from sys.master_files
)
select top 10
    name,
    (select sum(size) from fs where type = 0 and fs.database_id = db.database_id) DataFileSizeMB,
    (select sum(size) from fs where type = 1 and fs.database_id = db.database_id) LogFileSizeMB,
    log_reuse_wait_desc,
    is_cdc_enabled,
    replica_id,
    is_read_only
from sys.databases db
where database_id > 4
  -- AND log_reuse_wait <> 0
order by DataFileSizeMB desc


/*And then Check this*/

DBCC OPENTRAN;

DBCC SQLPERF(LOGSPACE);

EXEC sp_replcounters;


