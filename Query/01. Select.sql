/*
STANDARD STATEMENT:

Select [<Predicate>] <Expression list>
From <TableName>|<Viewname>|<DerivedTable>|<CTE>|<Table Valued fanction>|<Synonym>
[Where <Boolean Expression>]
[Group By<Expression list>]
[Having <Boolean Expression>]
[Order By<Expression list>]

*/

SELECT ProductID, ProductName, UnitPrice, UnitPrice * 0.09 AS Tax, Maliat = UnitPrice * 0.09
  FROM Products;

/*
دستوری بنویسید که نام و. نام خانوادگی را در کنار هم نمایش دهد
*/
SELECT EmployeeID, FirstName + N' ' + LastName AS Fullname
  FROM Employees;

-- Conversion
SELECT CONVERT (NVARCHAR(10), EmployeeID) + N') ' + FirstName + N' ' + Lastname AS Fullname
  FROM Employees;

-- Implicit conversion تبدیل ضمنی
SELECT 'a' + 'a';

SELECT 2 + 'a';

-- Type of select
SELECT GETDATE ();

SELECT LEFT(N'abcdefghij', 5);

SELECT RIGHT(N'abcdefghij', 4);

SELECT LEFT(N'فراتر از دانش', 5);

SELECT RIGHT(N'فراتر از دانش', 5);

SELECT SUBSTRING (N'فراتر از دانش', 7, 2);

SELECT FLOOR (3.85);

SELECT CEILING (3.85);

SELECT REVERSE (123456);

-- Use function on tables
SELECT orderid, SUBSTRING (CONVERT (NVARCHAR(10), OrderID), 3, 2)
  FROM Orders;

-- Use function and concatenate 
SELECT LEFT(firstname, 1) + N'. ' + Lastname AS fullname
  FROM Employees;

-- Use revers function manually
CREATE FUNCTION fn_Reverse (@inputstr nvarchar(4000))
RETURNS nvarchar(4000)
AS
    BEGIN
        DECLARE @outputsrt NVARCHAR(4000) = N'';
        DECLARE @Len INT = LEN (@inputstr);
        DECLARE @i INT = @Len;

        WHILE @i >= 1
            BEGIN
                SET @outputsrt = @outputsrt + SUBSTRING (@inputstr, @i, 1);
                SET @i = @i - 1;
            END;

        RETURN @outputsrt;
    END;
GO

SELECT dbo.fn_Reverse (N'abcd');
GO

SELECT ProductID, ProductName, dbo.fn_Reverse (ProductName) AS RN
  FROM products;

--
SELECT ProductID, ProductName, UnitPrice, --
       CASE
           WHEN unitprice < 10 THEN N'ارزان'
           WHEN UnitPrice >= 10
            AND UnitPrice <= 50 THEN N'متوسط'
           ELSE N'گران'
       END AS Pricerange
  FROM Products;

--
SELECT ProductID, ProductName, --
       CASE
           WHEN Discontinued = 1 THEN N'فعال'
           WHEN Discontinued = 0 THEN N'غیر فعال'
           ELSE N'تعیین نشده'
       END AS Status
  FROM products;

--
SELECT ProductID, ProductName, CategoryID, --
       CASE Categoryid
           WHEN 1 THEN N'aaaa'
           WHEN 2 THEN N'bbbb'
           WHEN 3 THEN N'cccc'
           WHEN 4 THEN N'dddd'
           WHEN 5 THEN N'eeee'
           ELSE N'Unknown'
       END AS Categoryname
  FROM Products;

--
SELECT ProductID, ProductName, CategoryID, --
       CASE
           WHEN Categoryid = 1 THEN N'aaaa'
           WHEN Categoryid = 2 THEN N'bbbb'
           WHEN Categoryid = 3 THEN N'cccc'
           WHEN Categoryid = 4 THEN N'dddd'
           WHEN Categoryid = 5 THEN N'eeee'
           ELSE N'Unknown'
       END AS Categoryname
  FROM Products;

--
CREATE TABLE personel (personelid INT          NOT NULL PRIMARY KEY,
                       firstname  NVARCHAR(50) NOT NULL,
                       Lastname   NVARCHAR(50) NOT NULL,
                       Age        INT          NOT NULL,
                       Gender     NCHAR(1)     NOT NULL CHECK (Gender = 'M'
                                                            OR Gender = 'F'),
                       DinID      INT          NULL CHECK (DinID BETWEEN 1 AND 4));
GO

SELECT personelid, firstname, Lastname, --
       CASE Gender
           WHEN N'M' THEN N'مرد'
           ELSE N'زن'
       END AS N'جنسیت', --
       CASE
           WHEN Age < 40 THEN N'جوان'
           WHEN Age <= 60 THEN N'میانسال'
           ELSE N'مسن'
       END AS Agerange, --
       CASE DinID
           WHEN 1 THEN N'مسلمان'
           WHEN 2 THEN N'مسیحی'
           WHEN 3 THEN N'کلیمی'
           WHEN 4 THEN N'زرتشی'
           ELSE N'نامشخص'
       END AS DinName --
  FROM personel;

--
/*
Predicate:
		1) All (default)
		2) DISTINCT
		3) TOP <n>
*/


SELECT ALL *
  FROM products
 WHERE UnitPrice > 50;


--
SELECT country
  FROM Customers;

SELECT DISTINCT country
  FROM Customers;

SELECT DISTINCT city
  FROM Customers;

SELECT DISTINCT country, city
  FROM Customers;

SELECT DISTINCT customerid, Country
  FROM Customers;

--
SELECT TOP 5 productid, ProductName, UnitPrice
  FROM Products
 ORDER BY UnitPrice DESC;

--
SELECT Country, city, CustomerID, CompanyName
  FROM Customers
 --order by country,City,CustomerID, CompanyName
 ORDER BY CustomerID, Country;

--
SELECT *
  FROM products
 ORDER BY CategoryID ASC, UnitPrice DESC;

--
SELECT TOP 12 WITH TIES *
  FROM Products
 ORDER BY UnitPrice, UnitsInStock DESC;

--
SELECT TOP 10 PERCENT *
  FROM Products
 ORDER BY UnitPrice;

SELECT TOP 10 PERCENT *
  FROM Products
 WHERE CategoryID = 1
 ORDER BY UnitPrice;

--
SELECT 2 + 5;

SELECT productid;

--
/*
<ServerName>.<DatabaseName>.<SchemaName>.<ObjectName>
*/

SELECT @@SERVERNAME;

SELECT *
  FROM [TeacherA-PC].Northwind.dbo.products;

--
SELECT *
  FROM [A1-PC].Northwind.dbo.products AS p
       INNER JOIN [TeacherA-PC].Northwind.dbo.Categories AS c ON p.CategoryID = c.CategoryID;

--
SELECT *
  FROM ora.northwind.dbo.products;

SELECT *
  FROM OPENQUERY (ora, 'Select * from Northwind.dbo.[Products]');

--
SELECT *
  FROM Northwind.dbo.Products;

--
USE Northwind;
GO

CREATE VIEW V_USCustomers
AS
SELECT CustomerID, CompanyName, Country, City
  FROM Customers
 WHERE country = N'USA';
GO

--
USE Northwind;
GO

/*******Object: View [dbo].[V_USCustomers]
Script date 9/7/2018 5:12:52 PM***********/
SET ANSI_NULLS ON;
GO

SET QUOTED_IDENTIFIER ON;
GO

ALTER VIEW dbo.V_USCustomers
AS
SELECT CustomerID, CompanyName, Country, City
  FROM Customers
 WHERE country = N'USA';
GO
--
SELECT *
  FROM V_USCustomers;

--
USE Northwind;
GO

CREATE VIEW V_ActiveCustomers
AS

SELECT *
  FROM Customers
 WHERE CustomerID IN (   SELECT CustomerID
                           FROM Orders
                          WHERE DATEDIFF (DAY, OrderDate, GETDATE ()) < 180 );
GO

SELECT *
  FROM V_ActiveCustomers AS C
       INNER JOIN Orders AS O ON C.CustomerID = O.CustomerID;

--
USE northwind;
GO

SELECT *
  FROM (SELECT * FROM customers WHERE country = N'USA') AS USC;

--
USE northwind;
GO

SELECT *
  FROM (SELECT * FROM customers WHERE country = N'USA') AS USC;

--
SELECT TOP 1 *
  FROM (SELECT TOP 5 * FROM Products ORDER BY UnitPrice ASC) AS T5
 ORDER BY T5.UnitPrice DESC;

--
WITH USC
AS
    (SELECT CustomerID, CompanyName, Country, City
       FROM Customers
      WHERE Country = N'USA')
SELECT *
  FROM USC;

--
WITH USC
AS
    (SELECT CustomerID, CompanyName, Country, City
       FROM Customers
      WHERE Country = 'usa'), Ord2016
AS
    (SELECT OrderID, OrderDate, CustomerID, Freight
       FROM Orders
      WHERE YEAR (orderdate) = 2016)
SELECT *
  FROM USC
       INNER JOIN Ord2016 ON USC.CustomerID = Ord2016.CustomerID;

--
WITH P1
AS
    (SELECT *
       FROM products
      WHERE CategoryID = 1), P2
AS
    (SELECT *
       FROM P1
      WHERE UnitPrice > 50)
SELECT *
  FROM P2;

--
CREATE FUNCTION fn_customerlist (@country nvarchar(40))
RETURNS TABLE
AS
RETURN (   SELECT CustomerID, CompanyName, Country, City
             FROM Customers
            WHERE country = @country);
GO

SELECT *
  FROM fn_customerlist ('Sweden') AS C
       INNER JOIN orders AS O ON C.CustomerID = O.CustomerID;

--
WITH T
AS
    (SELECT TOP 5 *
       FROM products
      ORDER BY UnitPrice ASC)
SELECT TOP 1 *
  FROM T
 ORDER BY UnitPrice DESC;

--
CREATE FUNCTION fn_NominKala (@N int)
RETURNS TABLE
AS
RETURN (
           WITH T
           AS
               (SELECT TOP (@N) *
                  FROM products
                 ORDER BY UnitPrice ASC)
           SELECT TOP 1 *
             FROM T
            ORDER BY UnitPrice DESC);
GO

SELECT *
  FROM fn_NominKala (15);
--
USE Northwind;
GO

SELECT *
  FROM Products
 WHERE UnitPrice >= 10;

SELECT *
  FROM Products
 WHERE UnitPrice <= 20;

SELECT *
  FROM Products
 WHERE UnitPrice >= 10
   AND UnitPrice <= 20;

SELECT *
  FROM Products
 WHERE UnitPrice <= 10
    OR UnitPrice <= 20;

--
SELECT *
  FROM Products
 WHERE NOT (   (   Categoryid = 1
                OR CategoryID = 3)
           AND UnitPrice < 10);

SELECT *
  FROM Products
 WHERE (   CategoryID != 1
       AND CategoryID != 3)
    OR UnitPrice >= 10;

--
SELECT *
  FROM Products
 WHERE NOT (   UnitPrice >= 10
           AND UnitPrice <= 20);

SELECT *
  FROM Products
 WHERE NOT (UnitPrice >= 10)
    OR NOT (UnitPrice <= 20);

SELECT *
  FROM Products
 WHERE UnitPrice < 10
    OR UnitPrice > 20;

--
IF NULL >= 0
    PRINT 'OK';
ELSE
    PRINT 'NOT OK';

--
SELECT *
  FROM Customers
 WHERE Region IS NOT NULL;

--
DECLARE @myRegion NVARCHAR(10);

SET @myRegion = NULL;

IF @myRegion IS NOT NULL
    SELECT *
      FROM Customers
     WHERE region = @myRegion;
ELSE
    SELECT *
      FROM Customers
     WHERE Region IS NULL;

--
SET ANSI_NULLS OFF;

SELECT *
  FROM customers
 WHERE region = NULL;

--
SELECT *
  FROM Products
 WHERE (UnitPrice BETWEEN 10 AND 20);

SELECT *
  FROM Products
 WHERE (UnitPrice NOT BETWEEN 10 AND 20);

--
SELECT *
  FROM products
 --where CategoryID=1 or CategoryID=3 or CategoryID=7
 WHERE CategoryID IN ( 1, 3, 7 );

SELECT *
  FROM Products
 WHERE CategoryID != 1
   AND CategoryID != 3
   AND CategoryID != 7;

SELECT *
  FROM Products
 WHERE CategoryID NOT IN ( 1, 3, 7 );

--
SELECT *
  FROM Customers
 WHERE Country IN ( 'uk', 'usa', 'germany', 'france' );

--
SELECT *
  FROM Products
 WHERE ProductName = N'Chai' COLLATE Persian_100_CS_AS;

--
SELECT *
  FROM Employees
 WHERE FirstName = LastName COLLATE Persian_100_CS_AS;

--
SELECT *
  FROM Products
 --where productname like N'S%'
 --where productname like N'Sir%'
 --where productname like N'%es'
 --where productname like N'%es' and ProductName like N'%er%'
 --where productname like N'%er%es%'
 --where productname like N'%er' or productname like N'es%' 
 --where productname like N'%e[r-t]%'
 --where productname like N'[a-c]%[es]'
 --where productname like N'_a____v%'
 --where productname like N'__a%' and ProductName not like N'_____[ae]%'
 --where ProductName like N'__a__[^ae]%'
 --where ProductName like N'%a[_]b%'
 WHERE ProductName LIKE N'%a#_b%' ESCAPE '#';

--
SELECT *
  FROM Employees
 WHERE lastname LIKE N'%ع';

SELECT *
  FROM Employees
 WHERE lastname LIKE N'ع%';

--
SELECT *
  FROM orders
 WHERE orderid LIKE N'_1_5%';

--
SELECT *
  FROM students
 WHERE StudentID LIKE N'95___3%';

--
SELECT COUNT (customerID), COUNT (companyname), COUNT (region)
  FROM Customers
 WHERE Country = N'uk';

SELECT COUNT (ProductID)
  FROM Products
 WHERE unitprice > 100;

SELECT COUNT (customerID)
  FROM Customers
 WHERE country = N'uk'
   AND Region IS NOT NULL;

SELECT COUNT (*)
  FROM customers
 WHERE country = N'uk';

--
SELECT COUNT (OrderID) AS ordercount
  FROM Orders
 WHERE employeeID = 1
   AND YEAR (orderdate) = 2018;

--
SELECT sum (unitsinstock) as totalStock
  FROM Products
 WHERE Discontinued = 0;

--
SELECT SUM (Quantity) AS TotalQuantity, SUM (unitprice * Quantity) AS TotalSale, SUM (unitprice * Quantity) / SUM (Quantity) AS AVGsalePrice, AVG (unitprice) AS average
  FROM [Order Details];