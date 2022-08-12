# Log backup overdue

This alert is raised when entries for a transaction log backup in the [msdb].[dbo].[backupset] system table are older than the time you specify.

This alert is only raised for databases set to the Full Recovery or Bulk-Logged Recovery models. It will not be raised for the master database.

## Availability groups

If a database belongs to an availability group, the alert is only raised on the copy of the database on the primary replica.

The alert is raised when the most recent log backup of the database (including all its copies) is older than a specified time threshold. This is the threshold specified for the copy of the database on the primary replica.

No alert is raised if at least one copy of the database has had a log backup within this time threshold.

## What is the transaction log?

A database's transaction log (the LDF file) is a critical component of SQL Server and is used to record all DML changes (INSERT, UPDATE, DELETE) and DDL (database structure) changes immediately after they occur, even before these changes are written permanently to the database (the MDF file).

The transaction log is used to help ensure database consistency should a server failure occur. It allows incomplete transactions to be rolled back, or completed transactions to be rolled-forward, when the database comes back online and completes the recovery process. Transaction log activity occurs automatically and cannot be turned off.

## Recovery models

If a database is set to the Simple Recovery model, the transaction log continues to work, but it cannot be backed up. This means that should a database need to be restored, then it must be restored from a full backup (or a combination of a full and differential backup), and that any changes to the database that were made after the last full or differential backup are lost. This option should not be used for production databases. If a database is set to the Full or the Bulk-Logged Recovery models, then the transaction log can be backed up, and should be backed up. For best practice, all production databases should include a backup strategy that includes a regular full backup (daily if possible), differential backups (only if necessary), and transaction log backups.

## Why run a log backup?

Log backups can be made more frequently than full or differential backups. This means that more of your data is backed up, and should you ever have to restore your backups, you reduce the amount of data that could potentially be lost.

For example, one backup strategy could be to perform a full database log backup daily, and a transaction log backup hourly. This way, should the database need to be restored, no more than an hour's worth of data would be lost.

Another important reason for performing transaction log backups is that they are required in order to prevent transaction logs from growing so large that you run out of disk space. When a database is set to the Full Recovery or Bulk-Logged Recovery model, the transaction log will continue to grow until it is backed up, manually truncated, or the disk runs out of space. Obviously, backing up the transaction log is the ideal solution, and is considered best practice.

When a transaction log is backed up and the older data is truncated from the log file, the physical size of the log file does not decrease. When a transaction log is truncated manually, or by taking a transaction log backup, the inactive data is marked so that it can be overwritten as needed, but no physical free space is created. If you need to shrink an oversized transaction log, you should manually shrink it using DBCC SHRINKFILE.

## How often to run log backups

How often you should perform transaction log backups depends on how much data you are willing to potentially lose, while taking into account the physical impact of taking the transaction log backups. While transaction log backups rarely impact production systems, it is possible that they can. Some people take transaction log backups every 4 hours, some every hour, and some every 15 minutes.
Impact of running a log backup

In most cases, transaction log backups are quick and use few server resources, but there are exceptions. If your transaction log backup takes more time and resources than you prefer, and they are negatively impacting a production system, consider using SQL Backup to backup your transaction logs. By using compression, the amount of time it takes to execute a transaction log backup can be reduced by up to 90%. 

## Full syntax

```SQL
 BACKUP LOG { database_name  @database_name_var } 
{ 
  TO < backup_device > [ ,...n ] 
  [ WITH 
    [ BLOCKSIZE = { blocksize | @blocksize_variable } ] 
    [ [ , ] DESCRIPTION = { 'text' | @text_variable } ] 
    [ [ ,] EXPIREDATE = { date | @date_var } 
    | RETAINDAYS = { days | @days_var } ] 
    [ [ , ] PASSWORD = { password | @password_variable } ] 
    [ [ , ] FORMAT | NOFORMAT ] 
    [ [ , ] { INIT | NOINIT } ] 
    [ [ , ] MEDIADESCRIPTION = { 'text' | @text_variable } ] 
    [ [ , ] MEDIANAME = { media_name | @media_name_variable } ] 
    [ [ , ] MEDIAPASSWORD = { mediapassword | @mediapassword_variable } ] 
    [ [ , ] NAME = { backup_set_name | @backup_set_name_var } ] 
    [ [ , ] NO_TRUNCATE ] 
    [ [ , ] { NORECOVERY | STANDBY = undo_file_name } ] 
    [ [ , ] { NOREWIND | REWIND } ]
    [ [ , ] { NOSKIP | SKIP } ] 
    [ [ , ] { NOUNLOAD | UNLOAD } ] 
    [ [ , ] RESTART ] 
    [ [ , ] STATS [ = percentage ] ] 
  ] 
}

< backup_device > ::= 
 { 
    { logical_backup_device_name | @logical_backup_device_name_var } 
    | 
    { DISK | TAPE } = 
      { 'physical_backup_device_name' | @physical_backup_device_name_var }
 }

< file_or_filegroup > ::= 
 { 
   FILE = { logical_file_name | @logical_file_name_var } 
   | 
   FILEGROUP = { logical_filegroup_name | @logical_filegroup_name_var } 
 }
 |
```