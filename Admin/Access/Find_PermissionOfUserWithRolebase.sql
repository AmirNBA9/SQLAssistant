/*Find permission of users with role*/
SELECT 'Role' AS UserType, 'Role Members' AS DatabaseUserName, DP2.name AS LoginName, DP1.name AS Role, 'SELECT' AS PermissionType, 'GRANT' AS PermissionState, 'Table' AS ObjectType,
       'dbo' AS [Schema], 'All Tables' AS ObjectName, NULL AS ColumnName
  FROM sys.database_role_members AS DRM
       RIGHT OUTER JOIN sys.database_principals AS DP1 ON DRM.role_principal_id = DP1.principal_id
       LEFT OUTER JOIN sys.database_principals AS DP2 ON DRM.member_principal_id = DP2.principal_id
 WHERE DP1.type = 'R'
   AND DP2.name IS NOT NULL;