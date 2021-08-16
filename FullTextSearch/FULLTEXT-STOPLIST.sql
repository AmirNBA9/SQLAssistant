-- Stop list

ALTER FULLTEXT STOPLIST CombinedFunctionWordList ADD 'en' LANGUAGE 'Spanish';   1025

--View Stoplist word
SELECT w.stoplist_id,
   l.name,
   w.stopword,
   w.language
FROM sys.fulltext_stopwords AS w
   INNER JOIN sys.fulltext_stoplists AS l
     ON w.stoplist_id = l.stoplist_id;

-- Stopwords list
CREATE FULLTEXT STOPLIST StopListCustome;
GO

-- Add a stopword
ALTER FULLTEXT STOPLIST StopListCustome 
	ADD 'از' LANGUAGE 'Neutral';

ALTER FULLTEXT STOPLIST StopListCustome 
	ADD 'و' LANGUAGE 'Neutral';
	ALTER FULLTEXT STOPLIST StopListCustome 
	ADD 'چگونه' LANGUAGE 'Neutral';
	ALTER FULLTEXT STOPLIST StopListCustome 
	ADD 'چرا' LANGUAGE 'Neutral';
	ALTER FULLTEXT STOPLIST StopListCustome 
	ADD 'زیرا' LANGUAGE 'Neutral';

	ADD 'است' LANGUAGE 'Neutral';

	ADD 'و' LANGUAGE 'Neutral';

Create table StopListCustome (StopListCustome nvarchar(50))

BULK INSERT dbo.StopListCustome
FROM '\\SystemX\DiskZ\Sales\data\StopList.csv'
WITH ( FORMAT='CSV');

SELECT 'ALTER FULLTEXT STOPLIST MyStoplist ADD ' + 
	quotename(StopListCustome, '''') + ' LANGUAGE ''English'''
FROM  StopListCustome