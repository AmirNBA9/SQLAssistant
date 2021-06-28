-- CREATE Indexed VIEW
-- To create a view with an index, the view must be created using the WITH SCHEMABINDING keywords:
/*01*/
CREATE VIEW view_EmployeeInfo
WITH SCHEMABINDING
AS
SELECT  EmployeeID, FirstName, LastName, HireDate
  FROM  [dbo].Employee;
GO
       /*02*/ -- Any clustered or non-clustered indexes can be now be created:
CREATE UNIQUE CLUSTERED INDEX IX_view_EmployeeInfo ON view_EmployeeInfo (EmployeeID ASC);
GO
-- There Are some limitations to indexed Views:
/*
1. The view definition can reference one or more tables in the same database.
2. Once the unique clustered index is created, additional nonclustered indexes can be created against the view.
3. You can update the data in the underlying tables – including inserts, updates, deletes, and even truncates.
4. You can’t modify the underlying tables and columns. The view is created with the WITH SCHEMABINDING option.
5. It can’t contain COUNT, MIN, MAX, TOP, outer joins, or a few other keywords or elements.
*/

-- CREATE VIEW With Encryption
CREATE VIEW view_EmployeeInfo
WITH ENCRYPTION
AS
SELECT  EmployeeID, FirstName, LastName, HireDate
  FROM  Employee;
GO

-- Grouped VIEWs
CREATE VIEW BigSales (state_code,
    sales_amt_total)
AS
SELECT  state_code, MAX (sales_amt)
  FROM  Sales
 GROUP BY state_code;
GO

-- UNION-ed VIEWs
CREATE VIEW DepTally2 (emp_nbr,
    dependent_cnt)
AS(
  SELECT    emp_nbr, COUNT (*)
    FROM    Dependents
   GROUP BY emp_nbr)
  UNION
  (SELECT   emp_nbr, 0
     FROM   Personnel AS P2
    WHERE   NOT EXISTS (SELECT  * FROM  Dependents AS D2 WHERE  D2.emp_nbr = P2.emp_nbr));
GO

-- Create a view with schema binding
CREATE VIEW dbo.PersonsView
WITH SCHEMABINDING
AS
SELECT  name, address
  FROM  dbo.PERSONS; -- database schema must be specified when WITH SCHEMABINDING is present