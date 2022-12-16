-- 1
CREATE DATABASE [DEMO]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'DEMO', 
  FILENAME = N'E:\DATA\DEMO.mdf' ,
  SIZE = 4096KB , FILEGROWTH = 1024KB )
 LOG ON 
( NAME = N'DEMO_log', 
  FILENAME = N'E:\DATA\DEMO_log.ldf', 
  SIZE = 1024KB , FILEGROWTH = 10%)
GO

-- 2
/*
- Always encryption keys
--- Create Column Master keys
--- Column encryption keys
*/

-- 3
use demo
go

CREATE TABLE dbo.Demo_Always_Encrypted 
(
   ID INT IDENTITY(1,1) PRIMARY KEY,

   LastName NVARCHAR(45),
   FirstName NVARCHAR(45),
   BirthDate DATE ENCRYPTED WITH 
    (
        ENCRYPTION_TYPE = RANDOMIZED, 
        ALGORITHM = 'AEAD_AES_256_CBC_HMAC_SHA_256', 
        COLUMN_ENCRYPTION_KEY = DemoTest
    ),
SSN CHAR(10) COLLATE Latin1_General_BIN2 
  ENCRYPTED WITH 
  (
     ENCRYPTION_TYPE = DETERMINISTIC, 
     ALGORITHM = 'AEAD_AES_256_CBC_HMAC_SHA_256', 
     COLUMN_ENCRYPTION_KEY = DemoTest
   ) );

    
-- 4 Insert a record with out set BrithDate
SELECT * FROM dbo.Demo_Always_Encrypted 

-- 5.0
INSERT INTO dbo.Demo_Always_Encrypted ([LastName],[FirstName],[BirthDate],[SSN])
VALUES ('Moradi','Ali',GETDATE(),'1234567890')

-- 5.1
DECLARE @LastName NVARCHAR(50) = 'Karimi'
DECLARE @FirstName NVARCHAR(50) = 'Amirhossein'
DECLARE @BrithDate DATE = GETDATE()
DECLARE @SSN VARCHAR(10) = '1234567890'

INSERT INTO dbo.Demo_Always_Encrypted ([LastName],[FirstName],[BirthDate],[SSN])
VALUES (@LastName,@FirstName,@BrithDate,@SSN)


-- 6
CREATE TABLE dbo.Demo_Always_Encrypted 
(
   ID INT IDENTITY(1,1) PRIMARY KEY,

   LastName NVARCHAR(45),
   FirstName NVARCHAR(45),
   BirthDate DATE ,
   SSN CHAR(10) COLLATE Latin1_General_BIN2 
 );

-- 7 
ALTER TABLE dbo.Demo_Always_Encrypted
ALTER COLUMN   BirthDate DATE ENCRYPTED WITH 
    (
        ENCRYPTION_TYPE = RANDOMIZED, 
        ALGORITHM = 'AEAD_AES_256_CBC_HMAC_SHA_256', 
        COLUMN_ENCRYPTION_KEY = DemoTest
    )



/*
We need API and always on full cenario for give result
*/