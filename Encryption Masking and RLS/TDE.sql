-- 1 
/*
 1- ایجاد Data Master Key : 
 DMK یا Database Master Key
 به ازای هر بانک اطلاعاتی به طور جداگانه وجود دارد و اطمینان می‌دهد که از کلیه کلیدهای موجود در بانک اطلاعاتی
 (Symmetric Key, Asymmetric Key, Certificate ) 
 توسط آن محافظت خواهد شد. 
 DMK 
 با استفاده از الگوریتم
 Triple DES 
 و Passwordی که کاربر تعیین می‌کند محافظت می‌شود.
 */
USE master;
GO

--Master Key ایجاد
CREATE MASTER KEY ENCRYPTION BY PASSWORD = 'DMK_Password';
GO

-- 2
/*
2- ایجاد Certificate:
همانگونه که قبلاً اشاره شد 
Certificate مورد نیاز
TDE 
باید در بانک اطلاعاتی 
Master باشد.
*/

USE master;
GO

--TDECert با نام Certificate ایجاد
CREATE CERTIFICATE TDECert
WITH SUBJECT = 'MyCert';
GO

-- 3
/*
3- ایجاد Database Encryption Key :DEK 
کلید مخصوص 
Encryption داده‌ها می‌باشد. محل ایجاد
DEK بر روی بانک اطلاعاتی مورد نظر شما می‌باشد.
DEK با استفاده از یک الگوریتم که توسط کاربر تعیین می‌شود عملیات
Encryption را انجام می‌دهد.این الگوریتم می‌تواند یکی از الگوریتم‌های
AES_192, AES_128, AES_256, Triple_DES_3KEY محقق کند.
*/

USE SecureDB;
GO

CREATE DATABASE ENCRYPTION KEY
WITH ALGORITHM = AES_256 --AES_192,AES_128,TRIPLE_DES_3KEY
ENCRYPTION BY SERVER CERTIFICATE TDECert;
GO

-- 4
/*
فعال‌سازی TDE بر روی بانک اطلاعاتی : زمانیکه
TDE را بر روی بانک اطلاعاتی خود فعال کنید
SQL Server به طور خودکار کلیه اطلاعات موجود در بانک اطلاعاتی شما را با استفاده از 
Database Encryption Key (DEK) رمزگذاری می‌کند. مدت زمان
Encryption با توجه به حجم بانک اطلاعاتی و قدرت سخت‌افزار شما ممکن است کوتاه و یا طولانی باشد. طی انجام عملیات
Encryption باید در نظر داشته باشید که سرویس
SQL را از دسترس خارج ننماید تا عملیات 
Encryption به طور کامل انجام شود. لازم به ذکر است در صورت انجام اینکار عملیات 
Encryption ادامه خواهد یافت.
*/

USE SecureDB;
GO

--برای بانک اطلاعاتیTDE فعال سازی قابلیت
ALTER DATABASE SecureDB SET ENCRYPTION ON;
GO

-->> FINISH <<--

/*Transfer database files to other servers*/
-- 1 Backup
--در سرور مبدا SMK تهیه نسخه پشتیبان از

BACKUP SERVICE MASTER KEY
TO FILE = 'C:\TDE_TEST\SMK.bak'
ENCRYPTION BY PASSWORD = 'SMK_Password';
GO

--در سرور مبدا DMK تهیه نسخه پشتیبان از
BACKUP MASTER KEY
TO FILE = 'C:\TDE_TEST\DMK.bak'
ENCRYPTION BY PASSWORD = 'DMK_Password_Backup';
GO

USE SecureDB;
GO

--در سرور مبدا Certificate تهیه نسخه پشتیبان از
BACKUP CERTIFICATE TDECert TO FILE = 'C:\TDE_Test\CertBackup.bak'
WITH PRIVATE KEY (FILE = 'C:\TDE_Test\PrivateKey.bak', ENCRYPTION BY PASSWORD = 'Cert_Password_Backup');
GO

--2 Restore
--در سرور مقصد SMK بازیابی نسخه پشتیبان

RESTORE SERVICE MASTER KEY
FROM FILE = 'C:\TDE_Test\SMK.bak'
DECRYPTION BY PASSWORD = 'SMK_Password';
GO

--در سرور مقصد DMK بازیابی نسخه پشتیبان
RESTORE MASTER KEY FROM FILE = 'C:\TDE_Test\DMK.bak' 
DECRYPTION BY PASSWORD = 'DMK_Password_Backup' 
ENCRYPTION BY PASSWORD = 'DMK_Password';
GO

--در سرور مقصد DMK باز کردن
OPEN MASTER KEY DECRYPTION BY PASSWORD = 'DMK_Password';

--در سرور مقصد Certificate بازیابی نسخه پشتیبان
CREATE CERTIFICATE TDECert
FROM FILE = 'C:\TDE_Test\CertBackup.bak'
WITH PRIVATE KEY (FILE = 'C:\TDE_Test\PrivateKey.bak', DECRYPTION BY PASSWORD = 'Cert_Password_Backup');
GO

EXEC sp_attach_db 'SecureDB', 'C:\TDE_TEST\YourDB.dmf';