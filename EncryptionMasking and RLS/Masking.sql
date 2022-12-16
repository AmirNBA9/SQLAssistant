-- Find table with masking
SELECT c.name, tbl.name as table_name, c.is_masked, c.masking_function  
FROM sys.masked_columns AS c  
JOIN sys.tables AS tbl   
    ON c.[object_id] = tbl.[object_id]  
WHERE is_masked = 1;  

--==<<{{[[****** 1 ******]]}}>>==--
-- schema to contain user tables
CREATE SCHEMA Data;
GO

-- table with masked columns
CREATE TABLE Data.Membership(
    MemberID        int IDENTITY(1,1) NOT NULL PRIMARY KEY CLUSTERED,
    FirstName        varchar(100) MASKED WITH (FUNCTION = 'partial(1, "xxxx", 1)') NULL,
    LastName        varchar(100) NOT NULL,
    Phone            varchar(12) MASKED WITH (FUNCTION = 'default()') NULL,
    Email            varchar(100) MASKED WITH (FUNCTION = 'email()') NOT NULL,
    DiscountCode    smallint MASKED WITH (FUNCTION = 'random(1, 100)') NULL
    );

-- inserting sample data
INSERT INTO Data.Membership (FirstName, LastName, Phone, Email, DiscountCode)
VALUES   
(N'امیرحسین', 'قاسمی', '09122508646', 'info@siteamn.com', 10),  
(N'فاطمه', 'کریمی', '09353535135', 'fk@gmail.com', 5),  
(N'سارا', 'عبادی زاده اعلی', '09191601921', 'sara@hotmail.com', 50),  
(N'علی', 'میر', '09181818110', 'Ali@gmail.com', 40);

--
CREATE USER MaskingTestUser WITHOUT LOGIN;  

GRANT SELECT ON SCHEMA::Data TO MaskingTestUser;  
  
  -- impersonate for testing:
EXECUTE AS USER = 'MaskingTestUser';  

SELECT * FROM Data.Membership;  

REVERT;

--==<<{{[[****** 2 ******]]}}>>==--
-- Add new mask column

ALTER TABLE Data.Membership  
ALTER COLUMN LastName ADD MASKED WITH (FUNCTION = 'partial(2,"###",1)');

-- change mask
ALTER TABLE Data.Membership  
ALTER COLUMN LastName varchar(100) MASKED WITH (FUNCTION = 'default()');


--==<<{{[[****** 3 ******]]}}>>==--
-- اصلاح دسترسی یا حذف امکان

--
GRANT UNMASK TO MaskingTestUser;  

EXECUTE AS USER = 'MaskingTestUser';  

SELECT * FROM Data.Membership;  

REVERT;    
  
-- Removing the UNMASK permission  
REVOKE UNMASK TO MaskingTestUser;

--
ALTER TABLE Data.Membership   
ALTER COLUMN LastName DROP MASKED;
