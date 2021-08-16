-- Simple Grouping
-- -- When grouping by a specific column, only unique values of this column are returned.
SELECT  customerId
  FROM  orders
 GROUP BY customerId;

-- Aggregate functions like count() apply to each group and not to the complete table:
SELECT  customerId, COUNT (productId) AS numberOfProducts, SUM (price) AS totalPrice
  FROM  orders
 GROUP BY customerId;

-- GROUP BY multiple columns
-- -- One might want to GROUP BY more than one column
DECLARE @temp TABLE (age INT,
    name VARCHAR(15));
INSERT INTO @temp
SELECT  18, 'matt'
UNION ALL
SELECT  21, 'matt'
UNION ALL
SELECT  21, 'matt'
UNION ALL
SELECT  18, 'luke'
UNION ALL
SELECT  18, 'luke'
UNION ALL
SELECT  21, 'luke'
UNION ALL
SELECT  18, 'luke'
UNION ALL
SELECT  21, 'luke';

SELECT  age, name, COUNT (1) count
  FROM  @temp
 GROUP BY age, name;

