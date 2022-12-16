-- simple
--01
CREATE CERTIFICATE MobileNumber  
WITH SUBJECT = 'Customer cell phone number'; 
GO  

CREATE SYMMETRIC KEY SSN_Key_01  
WITH ALGORITHM = AES_256  
ENCRYPTION BY CERTIFICATE MobileNumber;

--02
ALTER TABLE Person    
ADD Mobile varbinary(128);

--03
OPEN SYMMETRIC KEY SSN_Key_01     
DECRYPTION BY CERTIFICATE MobileNumber;  
GO

UPDATE Person  
SET Mobile = EncryptByKey(Key_GUID('SSN_Key_01'), Phone);  
GO  

--04
OPEN SYMMETRIC KEY SSN_Key_01  
   DECRYPTION BY CERTIFICATE Person;  
GO  

SELECT   Phone, 
                Mobile AS 'Encrypted ID Number',  
                CONVERT(nvarchar, DecryptByKey(Mobile)) AS 'Decrypted ID Number'  
FROM Person

