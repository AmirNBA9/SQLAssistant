/*
1. Server with single NUMA node	Less than or equal to 8 logical processors	Keep MAXDOP at or below # of logical processors
2. Server with single NUMA node	Greater than 8 logical processors	Keep MAXDOP at 8

*/
EXEC sp_configure 'show advanced options', 1;  
GO  
RECONFIGURE WITH OVERRIDE;  
GO  
EXEC sp_configure 'max degree of parallelism', 16;  
GO  
RECONFIGURE WITH OVERRIDE;  
GO