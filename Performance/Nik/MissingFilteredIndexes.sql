WITH A
AS
    (SELECT T.object_id, C.name AS ColName, T.name AS TblName, C.is_nullable
       FROM sys.columns AS C
            INNER JOIN sys.types AS T2 ON T2.user_type_id = C.user_type_id
            INNER JOIN sys.tables AS T ON T.object_id = C.object_id
      WHERE C.name LIKE N'%Is%'
        AND T2.name = 'bit'), B
AS
    (SELECT A.object_id, A.ColName, A.TblName, A.is_nullable
       FROM sys.indexes AS I
            INNER JOIN A ON A.object_id = I.object_id
      WHERE I.filter_definition LIKE '%' + A.ColName + '%')
SELECT A.ColName, A.TblName, A.is_nullable
  FROM A
       LEFT JOIN B ON B.object_id = A.object_id
 WHERE B.object_id IS NULL;