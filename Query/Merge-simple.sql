
/*Syntax*/

MERGE target_table USING source_table

ON merge_condition

WHEN MATCHED

THEN update_statement

WHEN NOT MATCHED

THEN insert_statement

WHEN NOT MATCHED BY SOURCE

THEN DELETE;


/*Step1*/

IF DB_ID ('[sample]') > 0
BEGIN

    ALTER DATABASE [sample] SET SINGLE_USER WITH ROLLBACK IMMEDIATE;

    DROP DATABASE [sample];

END;

GO
/*Step2*/

CREATE DATABASE [sample]
ON PRIMARY (NAME = [sample], FILENAME = 'C:\TEMP1\sample_DATA.MDF', SIZE = 100MB, MAXSIZE = 200MB, FILEGROWTH = 64536KB)
LOG ON (NAME = [sample_log], FILENAME = 'C:\TEMP1\sample_log.LDF', SIZE = 100MB, MAXSIZE = 200MB, FILEGROWTH = 64536KB);

GO
/*Step3*/
CREATE SCHEMA sales;

GO
/*Step4*/
CREATE TABLE sales.category (category_id INT PRIMARY KEY,
    category_name VARCHAR(255) NOT NULL,
    amount DECIMAL(10, 2));

CREATE TABLE sales.Category_staging (category_id INT PRIMARY KEY,
    category_name VARCHAR(255) NOT NULL,
    amount DECIMAL(10, 2));
/*Step5*/
INSERT INTO sales.category (category_id, category_name, amount)
VALUES (1, 'Children Bicycles', 15000),
    (2, 'Comfort Bicycles', 25000),
    (3, 'Cruisers Bicycles', 13000),
    (4, 'Cyclocross Bicycles', 10000);

GO

INSERT INTO sales.Category_staging (category_id, category_name, amount)
VALUES (1, 'Children Bicycles', 15000),
    (3, 'Cruisers Bicycles', 13000),
    (4, 'Cyclocross Bicycles', 20000),
    (5, 'Electric Bikes', 10000),
    (6, 'Mountain Bikes', 10000);

GO

SELECT  *
  FROM  sales.category;

SELECT  *
  FROM  sales.category_staging;

/*Step 6*/
MERGE sales.category t
USING sales.category_staging s
   ON (s.category_id = t.category_id)
 WHEN MATCHED
    THEN UPDATE SET t.category_name = s.category_name, t.amount = s.amount
 WHEN NOT MATCHED BY TARGET
    THEN INSERT (category_id, category_name, amount)
         VALUES (s.category_id, s.category_name, s.amount)
 WHEN NOT MATCHED BY SOURCE
    THEN DELETE;