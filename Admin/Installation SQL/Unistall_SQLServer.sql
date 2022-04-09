/*
- To uninstall SQL Server, you must be a local administrator with permissions to log on as a service.
- On a system with multiple instances of SQL Server, the SQL Server browser service is uninstalled only once the last instance of SQL Server is removed. The SQL Server Browser service can be removed manually from Programs and Features in the Control Panel.
- Uninstalling SQL Server deletes tempdb data files that were added during the install process. Files with tempdb_mssql_*.ndf name pattern are deleted if they exist in the system database directory.

## Prepare

1. Back up your data
2. Stop all SQL Server services.
3. Use an account that has the appropriate permissions.

*/

/*Uninstall Windows 10 / 2016+ */ 
/*
1. To begin the removal process navigate to Settings from the Start menu and then choose Apps.

2. Search for sql in the search box.

3. Select Microsoft SQL Server (Version) (Bit). For example, Microsoft SQL Server 2017 (64-bit).

4. Select Uninstall.

5. Select Remove on the SQL Server dialog pop-up to launch the Microsoft SQL Server installation wizard.

6. On the Select Instance page, use the drop-down box to specify an instance of SQL Server to remove, or specify the option to remove only the SQL Server shared features and management tools. To continue, select Next.

7. On the Select Features page, specify the features to remove from the specified instance of SQL Server.

8. On the Ready to Remove page, review the list of components and features that will be uninstalled. Click Remove to begin uninstalling

9. Refresh the Apps and Features window to verify the SQL Server instance has been removed successfully, and determine which, if any, SQL Server components still exist. Remove these components from this window as well, if you so choose.
*/

/*Unistall 2008-2012 R2*/
/*
1. To begin the removal process, navigate to the Control Panel and then select Programs and Features.

2. Right-click Microsoft SQL Server (Version) (Bit) and select Uninstall. For example, Microsoft SQL Server 2012 (64-bit).

3. Select Remove on the SQL Server dialog pop-up to launch the Microsoft SQL Server installation wizard.

4. On the Select Instance page, use the drop-down box to specify an instance of SQL Server to remove, or specify the option to remove only the SQL Server shared features and management tools. To continue, select Next.

5. On the Select Features page, specify the features to remove from the specified instance of SQL Server.

6. On the Ready to Remove page, review the list of components and features that will be uninstalled. Click Remove to begin uninstalling

7. Refresh the Programs and Features window to verify the SQL Server instance has been removed successfully, and determine which, if any, SQL Server components still exist. Remove these components from this window as well, if you so choose.

*/