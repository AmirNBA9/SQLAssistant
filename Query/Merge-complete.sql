/*The MERGE statement allows you to join a data source with a target table or view, and then perform multiple
actions against the target based on the results of that join.*/

-- MERGE to Insert / Update / Delete
MERGE INTO targetTable
USING sourceTable
   ON (targetTable.PKID = sourceTable.PKID)
 WHEN MATCHED AND (targetTable.PKID > 100)
    THEN DELETE
 WHEN MATCHED AND (targetTable.PKID <= 100)
    THEN UPDATE SET targetTable.ColumnA = sourceTable.ColumnA, targetTable.ColumnB = sourceTable.ColumnB
 WHEN NOT MATCHED
    THEN INSERT (ColumnA, ColumnB)
         VALUES (sourceTable.ColumnA, sourceTable.ColumnB)
 WHEN NOT MATCHED BY SOURCE
    THEN DELETE;


/*
MERGE INTO targetTable - table to be modified
USING sourceTable - source of data (can be table or view or table valued function)
ON ... - join condition between targetTable and sourceTable.
WHEN MATCHED - actions to take when a match is found
AND (targetTable.PKID > 100) - additional condition(s) that must be satisfied in order for the action
to be taken
THEN DELETE - delete matched record from the targetTable
THEN UPDATE - update columns of matched record specified by SET ....
WHEN NOT MATCHED - actions to take when match is not found in targetTable
WHEN NOT MATCHED BY SOURCE - actions to take when match is not found in sourceTable
*/


-- Merge Using CTE Source
WITH SourceTableCTE
    AS (SELECT  *
          FROM  SourceTable)
MERGE TargetTable AS target
USING SourceTableCTE AS source
   ON (target.PKID = source.PKID)
 WHEN MATCHED
    THEN UPDATE SET target.ColumnA = source.ColumnA
 WHEN NOT MATCHED
    THEN INSERT (ColumnA)
         VALUES (source.ColumnA);

-- Merge Example - Synchronize Source And Target Table
/*
To Illustrate the MERGE Statement, consider the following two tables -
	1. dbo.Product : This table contains information about the product that company is currently selling
	2. dbo.ProductNew: This table contains information about the product that the company will sell in the future.
The following T-SQL will create and populate these two tables
*/
IF OBJECT_ID (N'dbo.Product', N'U') IS NOT NULL
    DROP TABLE dbo.Product;
GO
CREATE TABLE dbo.Product (ProductID INT PRIMARY KEY,
    ProductName NVARCHAR(64),
    PRICE MONEY);
IF OBJECT_ID (N'dbo.ProductNew', N'U') IS NOT NULL
    DROP TABLE dbo.ProductNew;
GO
CREATE TABLE dbo.ProductNew (ProductID INT PRIMARY KEY,
    ProductName NVARCHAR(64),
    PRICE MONEY);
INSERT INTO dbo.Product
VALUES (1, 'IPod', 300),
    (2, 'IPhone', 400),
    (3, 'ChromeCast', 100),
    (4, 'raspberry pi', 50);
INSERT INTO dbo.ProductNew
VALUES (1, 'Asus Notebook', 300),
    (2, 'Hp Notebook', 400),
    (3, 'Dell Notebook', 100),
    (4, 'raspberry pi', 50);

/*
Now, Suppose we want to synchoronize the dbo.Product Target Table with the dbo.ProductNew table. Here is the
criterion for this task:GoalKicker.com – Microsoft® SQL Server® Notes for Professionals 50
1. Product that exist in both the dbo.ProductNew source table and the dbo.Product target table are updated in
the dbo.Product target table with new new Products.
2. Any product in the dbo.ProductNew source table that do not exist in the dob.Product target table are
inserted into the dbo.Product target table.
3. Any Product in the dbo.Product target table that do not exist in the dbo.ProductNew source table must be
deleted from the dbo.Product target table. Here is the MERGE statement to perform this task.
*/
MERGE dbo.Product AS SourceTbl
USING dbo.ProductNew AS TargetTbl
   ON (SourceTbl.ProductID = TargetTbl.ProductID)
 WHEN MATCHED AND SourceTbl.ProductName <> TargetTbl.ProductName OR SourceTbl.Price <> TargetTbl.Price
    THEN UPDATE SET SourceTbl.ProductName = TargetTbl.ProductName, SourceTbl.Price = TargetTbl.Price
 WHEN NOT MATCHED
    THEN INSERT (ProductID, ProductName, Price)
         VALUES (TargetTbl.ProductID, TargetTbl.ProductName, TargetTbl.Price)
 WHEN NOT MATCHED BY SOURCE
    THEN DELETE
OUTPUT $action, INSERTED.*, DELETED.*;

-- MERGE using Derived Source Table
MERGE INTO TargetTable AS Target
USING (VALUES (1, 'Value1'), (2, 'Value2'), (3, 'Value3')) AS Source (PKID, ColumnA)
   ON Target.PKID = Source.PKID
 WHEN MATCHED
    THEN UPDATE SET Target.ColumnA = Source.ColumnA
 WHEN NOT MATCHED
    THEN INSERT (PKID, ColumnA)
         VALUES (Source.PKID, Source.ColumnA);

-- Merge using EXCEPT (Use EXCEPT to prevent updates to unchanged records)
MERGE TargetTable targ
USING SourceTable AS src
   ON src.id = targ.id
 WHEN MATCHED AND EXISTS (SELECT    src.field EXCEPT SELECT targ.field)
    THEN UPDATE SET field = src.field
 WHEN NOT MATCHED BY TARGET
    THEN INSERT (id, field)
         VALUES (src.id, src.field)
 WHEN NOT MATCHED BY SOURCE
    THEN DELETE;
