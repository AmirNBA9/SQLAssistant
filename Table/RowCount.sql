SELECT o.name, i.rowcnt
  FROM sys.sysindexes AS i
       INNER JOIN sys.sysobjects AS o ON i.id = o.id
 WHERE i.indid < 2
   AND OBJECTPROPERTY (o.id, 'IsMSShipped') = 0
 ORDER BY i.rowcnt DESC;
