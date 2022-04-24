/*Find owners*/
SELECT SUSER_SNAME (owner_sid), *
  FROM sys.databases;

/*Change owner to sa*/
EXEC sys.sp_changedbowner @loginame = 'sa', @map = remap_alias_flag;