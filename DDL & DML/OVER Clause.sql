-- Cumulative Sum
/*
Using the Item Sales Table, we will try to find out how the sales of our items are increasing through dates. To do so
we will calculate the Cumulative Sum of total sales per Item order by the sale date.
*/
SELECT item_id, sale_Date,
    SUM(quantity * price) OVER(PARTITION BY item_id ORDER BY sale_Date ROWS BETWEEN UNBOUNDED PRECEDING) AS SalesTotal
  FROM SalesTable
GO
-- Using Aggregation functions with OVER
SELECT  CustomerId, SUM (TotalCost) OVER (PARTITION BY CustomerId) AS Total, AVG (TotalCost) OVER (PARTITION BY CustomerId) AS Avg,
    COUNT (TotalCost) OVER (PARTITION BY CustomerId) AS Count, MIN (TotalCost) OVER (PARTITION BY CustomerId) AS Min, MAX (TotalCost) OVER (PARTITION BY CustomerId) AS Max
  FROM  CarsTable
 WHERE  Status = 'READY';
/*
The duplicated row(s) may not be that useful for reporting purposes.
If you wish to simply aggregate data, you will be better off using the GROUP BY clause along with the appropriate
aggregate functions Eg:
*/
SELECT  CustomerId, SUM (TotalCost) AS Total, AVG (TotalCost) AS Avg, COUNT (TotalCost) AS Count, MIN (TotalCost) AS Min, MAX (TotalCost) AS Max
  FROM  CarsTable
 WHERE  Status = 'READY'
 GROUP BY CustomerId;

-- Dividing Data into equally-partitioned buckets using NTILE
/*Let's say that you have exam scores for several exams and you want to divide them into quartiles per exam.*/
-- Setup data:
DECLARE @values TABLE (Id INT IDENTITY(1, 1) PRIMARY KEY,
    [Value] FLOAT,
    ExamId INT);
INSERT INTO @values ([Value], ExamId)
VALUES (65, 1),
    (40, 1),
    (99, 1),
    (100, 1),
    (90, 1), -- Exam 1 Scores
    (91, 2),
    (88, 2),
    (83, 2),
    (91, 2),
    (78, 2),
    (67, 2),
    (77, 2); -- Exam 2 Scores
-- Separate into four buckets per exam:
SELECT  ExamId, NTILE (4) OVER (PARTITION BY ExamId ORDER BY [Value] DESC) AS Quartile, Value, Id
  FROM  @values
 ORDER BY ExamId, Quartile;

-- Using Aggregation funtions to find the most recent records
/*
Using the Library Database, we try to find the last book added to the database for each author. For this simple
example we assume an always incrementing Id for each record added.
*/
SELECT  MostRecentBook.Name, MostRecentBook.Title
  FROM  (   SELECT  Authors.Name, Books.Title, RANK () OVER (PARTITION BY Authors.Id ORDER BY Books.Id DESC) AS NewestRank
              FROM  Authors
                    JOIN Books ON Books.AuthorId = Authors.Id) MostRecentBook
 WHERE  MostRecentBook.NewestRank = 1;
/*
Instead of RANK, two other functions can be used to order. In the previous example the result will be the same, but
they give different results when the ordering gives multiple rows for each rank.
1. RANK(): duplicates get the same rank, the next rank takes the number of duplicates in the previous rank into account
2. DENSE_RANK(): duplicates get the same rank, the next rank is always one higher than the previous
3. ROW_NUMBER(): will give each row a unique 'rank', 'ranking' the duplicates randomly

For example, if the table had a non-unique column CreationDate and the ordering was done based on that, the
following query:

*/
SELECT Authors.Name, Books.Title, Books.CreationDate,
 RANK() OVER (PARTITION BY Authors.Id ORDER BY Books.CreationDate DESC) AS RANK,
 DENSE_RANK() OVER (PARTITION BY Authors.Id ORDER BY Books.CreationDate DESC) AS DENSE_RANK,
 ROW_NUMBER() OVER (PARTITION BY Authors.Id ORDER BY Books.CreationDate DESC) AS ROW_NUMBER,
FROM Authors
	JOIN Books ON Books.AuthorId = Authors.Id