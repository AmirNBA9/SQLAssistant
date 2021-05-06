Create database Encrypt_Test
GO
Create table Person(
	 ID int not null identity
	,FirstName Nvarchar(50) null
	,LastName Nvarchar(50) null
	,Phone	nvarchar(30) null
	)
GO

Insert into Person (FirstName,LastName,Phone)
	values(N'علی',N'محمدی','09121212112'),(N'ساناز',N'کرمی','09121313113'),(N'سیاوش',N'قلی زاده','09121515115')
/*Encrypt a Column of Data*/
-- ایجاد یک کلید اصلی برای دیتابیس
Use Encrypt_Test
GO
CREATE MASTER KEY ENCRYPTION BY   
PASSWORD = '123!@#AaB1.@__Gg'; 

/*2*/
-- مشاهده وضعبت کلید
Select	 name
		,principal_id					-- ID of the database principal who owns the key
		,symmetric_key_id				-- ID of the key. Unique within the database.
		,key_length						-- Length of the key in bits.
		,key_algorithm					-- Algorithm used with the key: R2 = RC2,R4 = RC4,D = DES,D3 = Triple DES,DT = TRIPLE_DES_3KEY,DX = DESX,A1 = AES 128,A2 = AES 192,A3 = AES 256,NA = EKM Key
		,algorithm_desc					-- Description of the algorithm used with the key:RC2,RC4,DES,Triple_DES,TRIPLE_DES_3KEY,DESX,AES_128,AES_192,AES_256,NULL (Extensible Key Management algorithms only)
		,create_date					-- Date the key was created.
		,modify_date					-- Date the key was modified.
		,key_guid						-- Globally unique identifier (GUID) associated with the key. It is auto-generated for persisted keys. GUIDs for temporary keys are derived from the user-supplied pass phrase.
		,key_thumbprint					-- SHA-1 hash of the key. The hash is globally unique. For non-Extensible Key Management keys this value will be NULL.
		,provider_type					-- Type of cryptographic provider: CRYPTOGRAPHIC PROVIDER = Extensible Key Management keys ,NULL = Non-Extensible Key Management keys
		,cryptographic_provider_guid	-- GUID for the cryptographic provider. For non-Extensible Key Management keys this value will be NULL.
		,cryptographic_provider_algid	-- Algorithm ID for the cryptographic provider. For non-Extensible Key Management keys this value will be NULL.
from sys.symmetric_keys

/*OPEN MASTER KEY*/
-- در زمان مورد نظر دیکریپت انجام میشود
OPEN MASTER KEY DECRYPTION BY PASSWORD = '123!@#AaB1.@__Gg'  

GO  
CLOSE MASTER KEY; 

/*ALTER MASTER KEY*/
ALTER MASTER KEY REGENERATE WITH ENCRYPTION BY PASSWORD = 'dsjdkflJ435907NnmM#sX003';
GO

/*DROP MASTER KEY*/
DROP MASTER KEY 


/*Cret*/
CREATE CERTIFICATE PhoneNumber  
   WITH SUBJECT = 'Customer Phone Numbers';
GO
CREATE SYMMETRIC KEY PhoneNumber_Key256 
 WITH ALGORITHM = AES_256  
 ENCRYPTION BY CERTIFICATE PhoneNumber; 
GO

ALTER TABLE Person   
    ADD PhoneNumber varbinary(160);

GO

OPEN SYMMETRIC KEY PhoneNumber_Key256  
   DECRYPTION BY CERTIFICATE PhoneNumber;  

-- Encrypt the value in column CardNumber using the  
-- symmetric key CreditCards_Key11.  
-- Save the result in column CardNumber_Encrypted.    
UPDATE Person
SET PhoneNumber = EncryptByKey(Key_GUID('PhoneNumber_Key256')  
    , Phone, 1, HashBytes('SHA1', CONVERT( varbinary  
    , Phone)));  
GO

Select * from Person

/**/
-- Verify the encryption.  
-- First, open the symmetric key with which to decrypt the data.  

OPEN SYMMETRIC KEY PhoneNumber_Key256  
   DECRYPTION BY CERTIFICATE PhoneNumber;  
GO  

-- Now list the original card number, the encrypted card number,  
-- and the decrypted ciphertext. If the decryption worked,  
-- the original number will match the decrypted number.  

SELECT Phone, PhoneNumber  AS 'Encrypted PhoneNumber'
	, CONVERT(nvarchar,DecryptByKey(PhoneNumber, 1 , HashBytes('SHA1', CONVERT(varbinary, Phone))))  AS 'Decrypted card number' 
	FROM Person;  
GO  



/*ذوش دوم*/
CREATE CERTIFICATE MobileNumber  
   WITH SUBJECT = 'Customer cell phone number';  
GO  

CREATE SYMMETRIC KEY SSN_Key_01  
    WITH ALGORITHM = AES_256  
    ENCRYPTION BY CERTIFICATE MobileNumber;  
GO  



-- Create a column in which to store the encrypted data.  
ALTER TABLE Person
    ADD Mobile varbinary(128);   
GO  

-- Open the symmetric key with which to encrypt the data.  
OPEN SYMMETRIC KEY SSN_Key_01  
   DECRYPTION BY CERTIFICATE MobileNumber;  

-- Encrypt the value in column NationalIDNumber with symmetric   
-- key SSN_Key_01. Save the result in column EncryptedNationalIDNumber.  
UPDATE Person  
SET Mobile = EncryptByKey(Key_GUID('SSN_Key_01'), Phone);  
GO  

-- Verify the encryption.  
-- First, open the symmetric key with which to decrypt the data.  
OPEN SYMMETRIC KEY SSN_Key_01  
   DECRYPTION BY CERTIFICATE Person;  
GO  

-- Now list the original ID, the encrypted ID, and the   
-- decrypted ciphertext. If the decryption worked, the original  
-- and the decrypted ID will match.  
SELECT Phone, mobile AS 'Encrypted ID Number',  
    CONVERT(nvarchar, DecryptByKey(Mobile)) AS 'Decrypted ID Number'  
    FROM Person
GO  