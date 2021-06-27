-- A database snapshot is a read-only, static view of a SQL Server database (the source database). It is similar to
-- backup, but it is available as any other database so client can query snapshot database.
CREATE DATABASE MyDatabase_morning -- name of the snapshot
ON  (NAME = MyDatabase_data, -- logical name of the data file of the source database
    FILENAME = 'C:\SnapShots\MySnapshot_Data.ss' -- snapshot file;
    ) AS SNAPSHOT OF MyDatabase; -- name of source database

-- You can also create snapshot of database with multiple files:
CREATE DATABASE MyMultiFileDBSnapshot
ON  (NAME = MyMultiFileDb_ft, FILENAME = 'C:\SnapShots\MyMultiFileDb_ft.ss'),
    (NAME = MyMultiFileDb_sys, FILENAME = 'C:\SnapShots\MyMultiFileDb_sys.ss'),
    (NAME = MyMultiFileDb_data, FILENAME = 'C:\SnapShots\MyMultiFileDb_data.ss'),
    (NAME = MyMultiFileDb_indx, FILENAME = 'C:\SnapShots\MyMultiFileDb_indx.ss') AS SNAPSHOT OF MultiFileDb;

-- Restore a database snapshot
/* If data in a source database becomes damaged or some wrong data is written into database, in some cases,
reverting the database to a database snapshot that predates the damage might be an appropriate alternative to
restoring the database from a backup.*/
RESTORE DATABASE MYDATABASE FROM DATABASE_SNAPSHOT = 'MyDatabase_morning';

-- DELETE Snapshot
DROP DATABASE Mydatabase_morning;