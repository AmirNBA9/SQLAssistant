

	Select * from Product.Descriptions D
		LEFT OUTER JOIN CONTAINSTABLE(Product.Descriptions, (ProductName,KeyWords1 ,ProductInfo), N'"*غذایی*"') AS DC ON D.DescriptionID = DC.[key]
	ORDER BY [Rank] DESC
			--contains (ProductName, N'"*اسة*"')  OR contains (ProductInfo, N'"*غذایی*"') OR contains (KeyWords1, N'"*غذایی*"')




SELECT object_id, property_list_id, stoplist_id,*
FROM sys.fulltext_indexes  
Where object_id = object_id('Product.Descriptions');   


Select *
From sys.sysfulltextcatalogs

Select * from sys.fulltext_catalogs

Select *
From sys.fulltext_index_columns

Select *
From sys.fulltext_stopwords


SELECT
 I.document_id,
 I.display_term,
 I.occurrence_count
FROM sys.dm_fts_index_keywords_by_document(DB_ID(DB_NAME()), OBJECT_ID(N'Product.Descriptions')) AS I
INNER JOIN Product.Descriptions D
ON D.DescriptionID = I.document_id
Order by 1

Declare @OriginalSearchText nvarchar(50) = N''

DECLARE @SearchText NVARCHAR(100) = ' "' + @OriginalSearchText + '" ' --For matching exact phrase
DECLARE @SearchTextWords NVARCHAR(100) = ' "' + REPLACE(@OriginalSearchText, ' ', '" OR "') + '" ' --For matching on words in phrase


	Select * from Product.Descriptions D
		LEFT OUTER JOIN CONTAINSTABLE(Product.Descriptions, (ProductName,KeyWords1,Productinfo), '"*را لوبیا*"') AS DC ON D.DescriptionID = DC.[Key]
	WHERE ISNULL(DC.[Rank], 0)  > 0
	ORDER BY [Rank] DESC


/*2*/
SELECT  k.[RANK],
    *
FROM [Product].[Descriptions] AS t 
INNER JOIN FREETEXTTABLE([Product].[Descriptions] , (ProductName,Keywords1,Productinfo), '"*را لوبیا*"') as k ON t.DescriptionID = k.[key]
ORDER BY k.[RANK] DESC


SELECT  k.[RANK],
    *
FROM [Product].[Descriptions] AS t 
INNER JOIN CONTAINSTABLE([Product].[Descriptions] , (ProductName,Keywords1,Productinfo), '"را*"') as k ON t.DescriptionID = k.[key]
ORDER BY k.[RANK] DESC

sp_configure 'show advanced options', 0;  
RECONFIGURE;  
GO  
sp_configure 'transform noise words', 0;  
RECONFIGURE;  
GO 

/*3.Stoplist-test*/
select * from sys.fulltext_stopwords
select * from sys.fulltext_stoplists
SELECT * FROM sys.dm_fts_index_keywords(DB_ID('AhooraDB'), 1866489728)

Select * from sys.tables where name = 'Descriptions'
select fulltext_catalog_id,stoplist_id, * from sys.fulltext_indexes;

ALTER FULLTEXT INDEX ON CremeSearchFT SET STOPLIST = OFF --غیرفعال کردن

ALTER FULLTEXT INDEX ON [Product].[Descriptions] SET STOPLIST = ON

ALTER FULLTEXT INDEX ON [Product].[Descriptions]  Set StopList StopListCustome --افزودن لیست توقف کلمه

SELECT * from sys.dm_fts_parser('query_string', 0, 0, 1)