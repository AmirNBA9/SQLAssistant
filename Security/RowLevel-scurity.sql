/*Row Level security*/
/*Row-Level Security enables you to use group membership or execution context to control access to rows in a database table.*/

/*سه کاربر ایجاد میکنیم*/
CREATE USER Manager WITHOUT LOGIN;  
CREATE USER Sales1 WITHOUT LOGIN;  
CREATE USER Sales2 WITHOUT LOGIN;  


/*یک جدول با یک ستون برای ذخیره سازی نام کاربرها ایجاد میکنیم*/
CREATE TABLE Sales  
    (  
    OrderID int,  
    SalesRep sysname,  
    Product varchar(10),  
    Qty int  
    );  


/*مقادیری برای مثال در جدول قرار میدهیم*/
INSERT INTO Sales VALUES (1, 'Sales1', 'Valve', 5);
INSERT INTO Sales VALUES (2, 'Sales1', 'Wheel', 2);
INSERT INTO Sales VALUES (3, 'Sales1', 'Valve', 4);
INSERT INTO Sales VALUES (4, 'Sales2', 'Bracket', 2);
INSERT INTO Sales VALUES (5, 'Sales2', 'Wheel', 5);
INSERT INTO Sales VALUES (6, 'Sales2', 'Seat', 5);
-- View the 6 rows in the table  
SELECT * FROM Sales;


/*دسترسی کاربرها را به جدول افزایش میدهیم*/
GRANT SELECT ON Sales TO Manager;  
GRANT SELECT ON Sales TO Sales1;  
GRANT SELECT ON Sales TO Sales2;  


/*یک اسکما برای موارد امنیتی ایجاد میکنیم*/
CREATE SCHEMA Security;  
GO  

/*یک تابع برای بررسی دسترسی کاربر ها تعریف میکنیم*/ 
CREATE FUNCTION Security.fn_securitypredicate(@SalesRep AS sysname)  
    RETURNS TABLE  
WITH SCHEMABINDING  
AS  
    RETURN SELECT 1 AS fn_securitypredicate_result
WHERE @SalesRep = USER_NAME() OR USER_NAME() = 'Manager';

/*سیاست امنیتی مورد نظر را بر روی جدول مورد نظر تعریف میکنیم*/
CREATE SECURITY POLICY SalesFilter  
ADD FILTER PREDICATE Security.fn_securitypredicate(SalesRep)
ON dbo.Sales  
WITH (STATE = ON);  

/*دسترسی کاربرها را برای این تنظیم تعریف مینماییم*/
GRANT SELECT ON security.fn_securitypredicate TO Manager;  
GRANT SELECT ON security.fn_securitypredicate TO Sales1;  
GRANT SELECT ON security.fn_securitypredicate TO Sales2;  


/*خروجی را برای کاربرهای مورد نظر تست میکنیم*/
EXECUTE AS USER = 'Sales1';  
SELECT * FROM Sales;
REVERT;  
  
EXECUTE AS USER = 'Sales2';  
SELECT * FROM Sales;
REVERT;  
  
EXECUTE AS USER = 'Manager';  
SELECT * FROM Sales;
REVERT;  

/*2*/
/*غیرفعال کردن*/
ALTER SECURITY POLICY SalesFilter  
WITH (STATE = OFF);  

/*منابع ایجاد شده را حذف میکنم تا دیتابیس تمیز شود.*/
DROP USER Sales1;
DROP USER Sales2;
DROP USER Manager;
/*سیاست های تعریف شده را حذف میکنیم*/
DROP SECURITY POLICY SalesFilter;
DROP TABLE Sales;
DROP FUNCTION Security.fn_securitypredicate;
DROP SCHEMA Security;

/*3.سناریو جدید*/
/**/
CREATE TABLE Sales2 (  
    OrderId int,  
    AppUserId int,  
    Product varchar(10),  
    Qty int  
);
/**/
INSERT Sales2 VALUES
    (1, 1, 'Valve', 5),
    (2, 1, 'Wheel', 2),
    (3, 1, 'Valve', 4),  
    (4, 2, 'Bracket', 2),
    (5, 2, 'Wheel', 5),
    (6, 2, 'Seat', 5);

/*Create a low-privileged user that the application will use to connect.*/
-- Without login only for demo  
CREATE USER AppUser WITHOUT LOGIN;
GRANT SELECT, INSERT, UPDATE, DELETE ON Sales2 TO AppUser;  
  
-- Never allow updates on this column  
DENY UPDATE ON Sales2(AppUserId) TO AppUser;

/**/
CREATE SCHEMA Security;  
GO  
  
CREATE FUNCTION Security.fn_securitypredicate2(@AppUserId int)  
    RETURNS TABLE  
    WITH SCHEMABINDING  
AS  
    RETURN SELECT 1 AS fn_securitypredicate_result  
    WHERE  
        DATABASE_PRINCIPAL_ID() = DATABASE_PRINCIPAL_ID('AppUser')
        AND CAST(SESSION_CONTEXT(N'UserId') AS int) = @AppUserId;
GO

/**/
CREATE SECURITY POLICY Security.SalesFilter2  
    ADD FILTER PREDICATE Security.fn_securitypredicate2(AppUserId)
        ON dbo.Sales2,  
    ADD BLOCK PREDICATE Security.fn_securitypredicate2(AppUserId)
        ON dbo.Sales2 AFTER INSERT
    WITH (STATE = ON);


/**/
EXECUTE AS USER = 'AppUser';  
EXEC sp_set_session_context @key=N'UserId', @value=1;  
SELECT * FROM Sales2;  
GO  
  
/* Note: @read_only prevents the value from changing again until the connection is closed (returned to the connection pool)*/
EXEC sp_set_session_context @key=N'UserId', @value=2, @read_only=1;
  
SELECT * FROM Sales2;  
GO  
  
INSERT INTO Sales2 VALUES (7, 1, 'Seat', 12); -- error: blocked from inserting row for the wrong user ID  
GO  
  
REVERT;  
GO

/*حذف*/
DROP USER AppUser;

DROP SECURITY POLICY Security.SalesFilter;
DROP TABLE Sales2;
DROP FUNCTION Security.fn_securitypredicate2;
DROP SCHEMA Security;