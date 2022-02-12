DECLARE @DataBase NVARCHAR(100) = DB_NAME ();

CREATE TABLE dbo.TempTB (ParentObject NVARCHAR(MAX) NULL,
                         Object       NVARCHAR(MAX) NULL,
                         Field        NVARCHAR(MAX) NULL,
                         VALUE        NVARCHAR(MAX) NULL) ON [PRIMARY];

INSERT INTO dbo.TempTB
EXEC ('DBCC PAGE(''' + @DataBase + ''' , 1 , 75339 , 3) WITH TABLERESULTS ');

-------------------------------------------------
DECLARE @cols NVARCHAR(MAX);

SELECT @cols = STUFF ((   SELECT DISTINCT TOP 100 PERCENT '],[' + t2.Field
                            FROM dbo.TempTB AS t2
                           WHERE t2.Object LIKE 'slot%Column%'
                           ORDER BY '],[' + t2.Field
                          FOR XML PATH ('')), 1, 2, '') + N']';

DECLARE @query NVARCHAR(MAX);

SET @query =
    N'SELECT ParentObject, ' + @cols + N'
FROM
(SELECT  t1.ParentObject,t1.Field,T1.VAlue
FROM    dbo.TempTB  AS t1
where object like ''slot%Column%'') p
PIVOT
(
max(VALUE) for Field in (' + @cols + N')
) AS pvt';

EXEC (@query);

DROP TABLE dbo.TempTB;