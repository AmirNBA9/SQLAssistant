/*Retrieve Basic Server Information*/

--Returns the version of MS SQL Server running on the instance.
SELECT @@VERSION

-- Returns the name of the MS SQL Server instance.
SELECT @@SERVERNAME

-- Returns the name of the Windows service MS SQL Server is running as.
SELECT @@SERVICENAME

-- Returns the physical name of the machine where SQL Server is running. Useful to identify the node in a failover cluster.
SELECT serverproperty('ComputerNamePhysicalNetBIOS');

-- In a failover cluster returns every node where SQL Server can run on. It returns nothing if not a cluster.
SELECT * FROM fn_virtualservernodes();

