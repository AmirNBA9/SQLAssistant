sp_configure 'clr enabled', 1  
GO  
RECONFIGURE  
GO

EXEC sp_configure 'show advanced options', 1
RECONFIGURE;
EXEC sp_configure 'clr strict security', 0;
RECONFIGURE;
GO

CREATE ASSEMBLY CLR_Shamsidate 
from 'C:\My file\Learning\SqlServer\3. T-sql\session 11\11\myCLRFunctions\myCLRFunctions\myCLRFunctions\bin\Debug\myCLRFunctions.dll' 
WITH PERMISSION_SET = SAFE;
GO

