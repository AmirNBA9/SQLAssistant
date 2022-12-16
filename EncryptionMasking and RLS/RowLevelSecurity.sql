--==<<{{[[****** 1 ******]]}}>>==--
-- Create user
CREATE USER Manager WITHOUT LOGIN;
CREATE USER Saler_Abbasi WITHOUT LOGIN;
CREATE USER Saler_Rasouli WITHOUT LOGIN;
GO

-- Create table for hold data
CREATE SCHEMA Sales
GO
CREATE TABLE Sales.Orders
    (
    OrderID int,
    UserCreator nvarchar(50),
    Product nvarchar(50),
    Quantity smallint
    );

-- Populate the table with six rows of data, showing three orders for each sales representative.
INSERT INTO Sales.Orders  VALUES (1, 'Saler_Abbasi', N'شاهین', 5);
INSERT INTO Sales.Orders  VALUES (2, 'Saler_Abbasi', N'سمند سورن', 2);
INSERT INTO Sales.Orders  VALUES (3, 'Saler_Abbasi', N'تارا', 4);
INSERT INTO Sales.Orders  VALUES (4, 'Saler_Rasouli', N'پراید', 2);
INSERT INTO Sales.Orders  VALUES (5, 'Saler_Rasouli', N'تیبا دو اتومات', 5);
INSERT INTO Sales.Orders  VALUES (6, 'Saler_Rasouli', N'کوییک آر', 5);
INSERT INTO Sales.Orders  VALUES (7, 'Saler_Rasouli', N'تندر90', 1);

-- View the 6 rows in the table
SELECT * FROM Sales.Orders;

-- Grant read access on the table to each of the users.
GRANT SELECT ON Sales.Orders TO Manager;
GRANT SELECT ON Sales.Orders TO Saler_Abbasi;
GRANT SELECT ON Sales.Orders TO Saler_Rasouli;
GO

--
CREATE SCHEMA Security;
GO
  
CREATE FUNCTION Security.tvf_securitypredicate(@UserCreator AS nvarchar(50))
    RETURNS TABLE
WITH SCHEMABINDING
AS
    RETURN SELECT 1 AS tvf_securitypredicate_result
WHERE @UserCreator = USER_NAME() OR USER_NAME() = 'Manager';
GO

-- Create a security policy adding the function as a filter predicate. The state must be set to ON to enable the policy.
CREATE SECURITY POLICY SalesFilter
ADD FILTER PREDICATE Security.tvf_securitypredicate(UserCreator)
ON Sales.Orders
WITH (STATE = ON);
GO

-- Allow SELECT permissions to the tvf_securitypredicate function:
GRANT SELECT ON Security.tvf_securitypredicate TO Manager;
GRANT SELECT ON Security.tvf_securitypredicate TO Saler_Abbasi;
GRANT SELECT ON Security.tvf_securitypredicate TO Saler_Rasouli;

-- Now test the filtering predicate, by selected from the Sales.Orders table as each user.
EXECUTE AS USER = 'Saler_Abbasi';
SELECT * FROM Sales.Orders;
REVERT;
  
EXECUTE AS USER = 'Saler_Rasouli';
SELECT * FROM Sales.Orders;
REVERT;
  
EXECUTE AS USER = 'Manager';
SELECT * FROM Sales.Orders;
REVERT;

-- Alter the security policy to disable the policy.
ALTER SECURITY POLICY SalesFilter
WITH (STATE = OFF); 

--
DROP USER Saler_Abbasi;
DROP USER Saler_Rasouli;
DROP USER Manager;

DROP SECURITY POLICY SalesFilter;
DROP TABLE Sales.Orders;
DROP FUNCTION Security.tvf_securitypredicate;
DROP SCHEMA Security;
DROP SCHEMA Sales;