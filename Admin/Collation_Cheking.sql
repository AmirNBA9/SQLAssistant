SELECT CONVERT (VARCHAR, SERVERPROPERTY ('collation')) AS 'Server Collation';

SELECT name, collation_name
  FROM sys.databases
 WHERE name = 'master';