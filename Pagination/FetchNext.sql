/*01. Pagination by OffsetFetch*/
-- OFFSET FETCH clause is more advanced version of TOP. It enables you to skip N1 rows and take next N2 rows:
SELECT *
FROM sys.objects
ORDER BY object_id
OFFSET 50 ROWS FETCH NEXT 10 ROWS ONLY

-- You can use OFFSET without fetch to just skip first 50 rows:
SELECT *
FROM sys.objects
ORDER BY object_id
OFFSET 50 ROWS

