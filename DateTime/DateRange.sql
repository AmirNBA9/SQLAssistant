-- With Recursive CTE
DECLARE @FromDate DATE = '2014-04-21', @ToDate DATE = '2014-05-02';
WITH DateCte (Date)
    AS (SELECT  @FromDate
        UNION ALL
        SELECT  DATEADD (DAY, 1, Date)
          FROM  DateCte
         WHERE  Date < @ToDate)
SELECT  Date
  FROM  DateCte
OPTION (MAXRECURSION 0);


-- Date Range With a Tally Table
DECLARE @FromDate DATE = '2014-04-21', @ToDate DATE = '2014-05-02';
WITH E1 (N)
    AS (SELECT  1
          FROM  (VALUES (1), (1), (1), (1), (1), (1), (1), (1), (1), (1)) DT (N) ), E2 (N)
    AS (SELECT  1
          FROM  E1 A
                CROSS JOIN E1 B), E4 (N)
    AS (SELECT  1
          FROM  E2 A
                CROSS JOIN E2 B), E6 (N)
    AS (SELECT  1
          FROM  E4 A
                CROSS JOIN E2 B), Tally (N)
    AS (SELECT  ROW_NUMBER () OVER (ORDER BY (SELECT    NULL))
          FROM  E6)
SELECT  DATEADD (DAY, N - 1, @FromDate) Date
  FROM  Tally
 WHERE  N <= DATEDIFF (DAY, @FromDate, @ToDate) + 1;