DECLARE @d DATETIME = '10/01/2011';  
SELECT FORMAT ( @d, 'd', 'en-US' ) AS 'US English Result'  
      ,FORMAT ( @d, 'd', 'en-gb' ) AS 'Great Britain English Result'  
      ,FORMAT ( @d, 'd', 'de-de' ) AS 'German Result'  
      ,FORMAT ( @d, 'd', 'zh-cn' ) AS 'Simplified Chinese (PRC) Result';   
  
SELECT FORMAT ( @d, 'D', 'en-US' ) AS 'US English Result'  
      ,FORMAT ( @d, 'D', 'en-gb' ) AS 'Great Britain English Result'  
      ,FORMAT ( @d, 'D', 'de-de' ) AS 'German Result'  
      ,FORMAT ( @d, 'D', 'zh-cn' ) AS 'Chinese (Simplified PRC) Result';
GO

DECLARE @d DATETIME = GETDATE();  
SELECT FORMAT( @d, 'dd/MM/yyyy', 'en-US' ) AS 'DateTime Result'  
       ,FORMAT(123456789,'###-##-####') AS 'Custom Number Result';
GO

SELECT TOP(5)CurrencyRateID, EndOfDayRate  
            ,FORMAT(EndOfDayRate, 'N', 'en-us') AS 'Number Format'  
            ,FORMAT(EndOfDayRate, 'G', 'en-us') AS 'General Format'  
            ,FORMAT(EndOfDayRate, 'C', 'en-us') AS 'Currency Format'  
FROM Sales.CurrencyRate  
ORDER BY CurrencyRateID;
GO

SELECT FORMAT(cast('07:35' as time), N'hh.mm');   --> returns NULL  
SELECT FORMAT(cast('07:35' as time), N'hh:mm');   --> returns NULL

SELECT FORMAT(cast('07:35' as time), N'hh\.mm');  --> returns 07.35  
SELECT FORMAT(cast('07:35' as time), N'hh\:mm');  --> returns 07:35  

/*Type of culture in format*/
DECLARE @date datetimeoffset, @culture char(2); 
SET @date = '2030-05-25 23:59:30.1234567 +03:30';
SET @culture = 'fa';
-- Persian (Shamsi)
SELECT 
  FORMAT(@date, 'd', @culture) AS 'd',
  FORMAT(@date, 'D', @culture) AS 'D',
  FORMAT(@date, 'f', @culture) AS 'f',
  FORMAT(@date, 'F', @culture) AS 'F',
  FORMAT(@date, 'g', @culture) AS 'g',
  FORMAT(@date, 'G', @culture) AS 'G',
  FORMAT(@date, 'm', @culture) AS 'm',
  FORMAT(@date, 'M', @culture) AS 'M',
  FORMAT(@date, 'o', @culture) AS 'o',
  FORMAT(@date, 'O', @culture) AS 'O',
  FORMAT(@date, 'r', @culture) AS 'r',
  FORMAT(@date, 'R', @culture) AS 'R',
  FORMAT(@date, 's', @culture) AS 's',
  FORMAT(@date, 't', @culture) AS 't',
  FORMAT(@date, 'T', @culture) AS 'T',
  FORMAT(@date, 'u', @culture) AS 'u',
  FORMAT(@date, 'U', @culture) AS 'U',
  FORMAT(@date, 'y', @culture) AS 'y',
  FORMAT(@date, 'Y', @culture) AS 'Y';

-- Arabic (Hijri)
SET @culture = 'ar';
SELECT 
  FORMAT(@date, 'd', @culture) AS 'd',
  FORMAT(@date, 'D', @culture) AS 'D',
  FORMAT(@date, 'f', @culture) AS 'f',
  FORMAT(@date, 'F', @culture) AS 'F',
  FORMAT(@date, 'g', @culture) AS 'g',
  FORMAT(@date, 'G', @culture) AS 'G',
  FORMAT(@date, 'm', @culture) AS 'm',
  FORMAT(@date, 'M', @culture) AS 'M',
  FORMAT(@date, 'o', @culture) AS 'o',
  FORMAT(@date, 'O', @culture) AS 'O',
  FORMAT(@date, 'r', @culture) AS 'r',
  FORMAT(@date, 'R', @culture) AS 'R',
  FORMAT(@date, 's', @culture) AS 's',
  FORMAT(@date, 't', @culture) AS 't',
  FORMAT(@date, 'T', @culture) AS 'T',
  FORMAT(@date, 'u', @culture) AS 'u',
  FORMAT(@date, 'U', @culture) AS 'U',
  FORMAT(@date, 'y', @culture) AS 'y',
  FORMAT(@date, 'Y', @culture) AS 'Y';

-- English ()
SET @culture = 'en-us';
SELECT 
  FORMAT(@date, 'd', @culture) AS 'd',
  FORMAT(@date, 'D', @culture) AS 'D',
  FORMAT(@date, 'f', @culture) AS 'f',
  FORMAT(@date, 'F', @culture) AS 'F',
  FORMAT(@date, 'g', @culture) AS 'g',
  FORMAT(@date, 'G', @culture) AS 'G',
  FORMAT(@date, 'm', @culture) AS 'm',
  FORMAT(@date, 'M', @culture) AS 'M',
  FORMAT(@date, 'o', @culture) AS 'o',
  FORMAT(@date, 'O', @culture) AS 'O',
  FORMAT(@date, 'r', @culture) AS 'r',
  FORMAT(@date, 'R', @culture) AS 'R',
  FORMAT(@date, 's', @culture) AS 's',
  FORMAT(@date, 't', @culture) AS 't',
  FORMAT(@date, 'T', @culture) AS 'T',
  FORMAT(@date, 'u', @culture) AS 'u',
  FORMAT(@date, 'U', @culture) AS 'U',
  FORMAT(@date, 'y', @culture) AS 'y',
  FORMAT(@date, 'Y', @culture) AS 'Y';
