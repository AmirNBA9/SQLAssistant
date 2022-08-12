# SQL Server error log entry

Raised when an error log entry above a defined severity is written to the error log.

## Error severity levels

Note that a user may have explicitly caused an error to be written to the log using RAISERROR. Manually raised errors can be given any severity level, and the descriptions below will not necessarily apply.

**0-10:** Information messages only.

**11-16:** Errors caused by users that can be corrected by users, for example, "table does not exist in database."

**17: Insufficient resources.** Insufficient resources to carry out the statement, for example, run out of locks or no more disk space for the database.

**18: Non-fatal internal error.** An internal error, that does not cause the connection to terminate, for example, stack overflow during compilation. Level 18 errors may occur, for example, when the SQL Server query processor detects an internal error during query optimization.

**19: SQL Server resource problem.** A nonconfigurable internal limit has been exceeded (for example, log file is full) and the current batch is terminated. Severity level 19 errors occur rarely, but must be corrected. Note: Errors with a severity level of 19 or higher terminate the current batch.

Severity levels 20-25 indicate system problems; these are fatal errors, indicating that the process is no longer running. The process records information about what occurred before terminating, and the client connection to SQL Server closes. Error messages in this range may affect all of the processes in the database, and may indicate that a database or object is damaged.

**20: Fatal error on current connection.** The current process has encountered a problem; this does not usually mean that database is damaged. Refer to Microsoft support sites for more information about your specific error.

**21: Fatal error on database.** An error has occurred which affects all processes in current database. A severity level of 21 usually does not mean any database is damaged. You might have to review the contents of system tables and the configuration options to resolve errors of this severity.

**22: Table integrity fatal error.** Not encountered very often; indicates that table integrity is suspect. Usually related to hardware, but the problem may exist in cache only, rather than on disk. Run DBCC CHECKDB to examine the integrity of all tables. Running DBCC CHECKDB with the REPAIR option may fix the problem. If restarting does not help, the problem is on the disk. Sometimes destroying the object specified in the error message can solve the problem. For example, if the message tells you that SQL Server has found a row with a length of 0 in a nonclustered index, delete the index and rebuild it.

**23: Database integrity fatal error.** Problem with the integrity of the entire database; the database will be marked suspect. Run DBCC CHECKDB. These types of errors are usually caused by hardware issues. More than likely you will have to restore the database from backup. Run DBCC CHECKDB after restoring to ensure that the database is not corrupt.

**24: Media failure.** Indicates some kind of hardware failure; you might have to reload the database from backup. Run DBCC CHECKDB to check database consistency first. You might also wish to contact your hardware vendor.
