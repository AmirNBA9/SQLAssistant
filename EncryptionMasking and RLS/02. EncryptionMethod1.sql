-- 01
Create database Encrypt_Test
GO
Create table Person(
	 ID int not null identity
	,FirstName Nvarchar(50) null
	,LastName Nvarchar(50) null
	,Phone	nvarchar(30) null
	)
-- ثبت اطلاعات نمونه
Insert into Person (FirstName,LastName,Phone)
	values(N'علی',N'محمدی','09121212112')
		  ,(N'ساناز',N'کرمی','09121313113')
		  ,(N'سیاوش',N'قلی زاده','09121515115')



--02
Use Encrypt_Test
GO
CREATE MASTER KEY ENCRYPTION BY   
PASSWORD = 'asdfghjkl1`234567)(*&^%LKJHGF';                  --پسورد بسیار قوی ایجاد کنید

--03
Select	 name
		,principal_id					-- این آی دی برای مالک این کلید است
		,symmetric_key_id				-- آی دی منحصربفرد کلید در دیتابیس
		,key_length					-- طول کلید ایجاد شده به bit
		,key_algorithm					-- الگوریتم استفاده شده ربای ساخت کلید
		,algorithm_desc				-- تشریح الگوریتم مورد استفاده
		,create_date					-- تاریخ ایجاد
		,modify_date					-- آخرین تاریخ تغییرات
		,key_guid						-- (GUID) که خودکار تولید می شود
from sys.symmetric_keys

--04
DROP MASTER KEY;

--05
OPEN MASTER KEY DECRYPTION BY PASSWORD = 'sfj5300osdVdgwdfkli7';   
BACKUP MASTER KEY TO FILE = 'c:\temp\exportedmasterkey'        ENCRYPTION BY PASSWORD = 'sd092735kjn$&adsg';   

--06
RESTORE MASTER KEY FROM FILE = 'c:\backups\keys\AdventureWorks2012_master_key'        DECRYPTION BY PASSWORD = '3dH85Hhk003#GHkf02597gheij04'        ENCRYPTION BY PASSWORD = '259087M#MyjkFkjhywiyedfgGDFD';

--07
CREATE CERTIFICATE PhoneNumber  
WITH SUBJECT = 'Customer Phone Numbers';

GO

CREATE SYMMETRIC KEY PhoneNumber_Key256 
WITH ALGORITHM = AES_256  
ENCRYPTION BY CERTIFICATE PhoneNumber; 

--08
ALTER TABLE Person   
ADD PhoneNumber varbinary(160);

--09
UPDATE Person
SET PhoneNumber = EncryptByKey(Key_GUID('PhoneNumber_Key256') , Phone, 1, ('SHA1', CONVERT( varbinary , Phone)));  
GO

--10
OPEN SYMMETRIC KEY PhoneNumber_Key256  
DECRYPTION BY CERTIFICATE PhoneNumber;  
GO  

SELECT  Phone
              ,PhoneNumber  AS 'Encrypted PhoneNumber'	
              ,CONVERT(nvarchar,DecryptByKey(PhoneNumber, 1 , HashBytes('SHA1', CONVERT(varbinary, Phone))))  AS 'Decrypted card number' 
FROM Person;  