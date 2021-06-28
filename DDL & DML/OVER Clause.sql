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
