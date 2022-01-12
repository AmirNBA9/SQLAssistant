/*------------------------------------------------------
-- Author:	Ah.ghasemi								----
-- Date:	1397/08/21								----
-- Note:	Create BackUp							----
------------------------------------------------------*/

DECLARE @sql NVARCHAR(4000) = N'', --مجری کوئری بکاپ گیری
		@DB	 sysname		= DB_NAME (); --نام دیتابیس جاری، برای بکاپ گیری

SET @sql
	= N'
BACKUP DATABASE ' + @DB + N'
TO DISK = ''D:\SupportBackups\' + @DB + N'ScriptBackup_' + CONVERT (NVARCHAR(50), GETDATE (), 112)
	  + N'.bak'' 
   WITH stop_on_error,FORMAT, compression, init,checksum,
      MEDIANAME = ''D_KaraScriptRunBackups'',  
      NAME = ''Full Backup of Database'';';

EXEC (@sql);
--BACKUP DATABASE [KaraDB]   ---نام دیتابیس---DB name
--TO DISK = 'D:\SupportBackups\KaraDB970819after.Bak'  ---مسیر را ایجاد و نام فایل بکاپ را مشخص نمایید---Create Folders and set B.K name
--   WITH stop_on_error,FORMAT, compression, init,checksum,
--      MEDIANAME = 'D_KaraSupportBackups',  
--      NAME = 'Full Backup of Database';  
--GO

--USE [master]
--RESTORE DATABASE [KaraDB1394-ForVATChange] 
--FROM  DISK = N'D:\SupportBackups\KaraDB1394-ForVATChange970918.Bak'
--WITH  FILE = 1,  NOUNLOAD,  STATS = 5
--GO
