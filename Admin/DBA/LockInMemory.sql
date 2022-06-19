/*LOCK PAGE IN MEMORY*/

--Check Lock Pages in Memory
/*We can see the output shows 0 which means this setting is not enabled for SQL Server*/
SELECT a.memory_node_id, node_state_desc, a.locked_page_allocations_kb
FROM sys.dm_os_memory_nodes a
INNER JOIN sys.dm_os_nodes b ON a.memory_node_id = b.memory_node_id


--Check Lock Pages in Memory
SELECT sql_memory_model, sql_memory_model_desc
FROM sys.dm_os_sys_info
/*
1 means "Conventional Memory Model" is being used
2 means "Lock Pages in Memory" is being used and enabled
3 means "Large Pages in Memory" is configured
*/

--For activate this feature
/*
1. Computer Configurations >> Windows Settings >> Security Settings >> User Rights Assignment
2. Double click  Lock Pages in Memory
3. Add User or Groups
*/