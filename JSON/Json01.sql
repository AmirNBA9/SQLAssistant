/*Json*/
/********************************************/
--Import a JSON document into a single column
SELECT BulkColumn
FROM OPENROWSET (BULK 'C:\Users\rpipc\Downloads\country-codes_zip\data\country-codes_json.json', SINGLE_CLOB) as j;
-- Load file contents into a variable
Declare @json Nvarchar(max)
SELECT @json = BulkColumn
 FROM OPENROWSET (BULK 'C:\Users\rpipc\Downloads\country-codes_zip\data\country-codes_json.json', SINGLE_CLOB) as j
-- Load file contents into a table 
SELECT BulkColumn
 INTO #temp 
 FROM OPENROWSET (BULK 'C:\Users\rpipc\Downloads\country-codes_zip\data\country-codes_json.json', SINGLE_CLOB) as j;

/********************************************/
-- Find in one row
Declare @V Nvarchar(max)
SELECT @V = [value]
FROM OPENROWSET(BULK N'C:\Users\rpipc\Downloads\country-codes_zip\data\country-codes_json.json', SINGLE_CLOB) AS json
		CROSS APPLY OPENJSON(BulkColumn)

 --WITH( Continent nvarchar(100), [CLDR display name] nvarchar(100),Dial nvarchar(100), price float,
 --   pages_i int, author nvarchar(100)) AS book

-- Find Seperat rows
SELECT *
 FROM OPENROWSET (BULK 'C:\Users\rpipc\Downloads\country-codes_zip\data\country-codes_json.json', SINGLE_CLOB) as j
 CROSS APPLY OPENJSON(BulkColumn)

--Find Seperat Columns am\nd rows
SELECT *
 FROM OPENROWSET (BULK 'C:\Users\rpipc\Downloads\country-codes_zip\data\country-codes_json.json') as j
 CROSS APPLY OPENJSON(BulkColumn,SINGLE_NCLOB)
 WITH(	[CLDR display name] nvarchar(100), 
		Capital nvarchar(100),
		Ds nvarchar(100),
		Continent nvarchar(100), 
		author nvarchar(100),
		[Developed / Developing Countries] nvarchar(100),
		[Dial] nvarchar(100),
		[EDGAR] nvarchar(100),
		[FIFA] nvarchar(100),
		[FIPS] nvarchar(100),
		[GAUL] nvarchar(100),
		[Geoname ID] nvarchar(100),
		[Global Code] nvarchar(100),
		[Global Name] nvarchar(100),
		[IOC] nvarchar(100),
		[ISO3166-1-Alpha-2] nvarchar(100),
		[ISO3166-1-Alpha-3] nvarchar(100),
		[ISO3166-1-numeric] nvarchar(100),
		[SO4217-currency_alphabetic_code] nvarchar(100),
		[I] nvarchar(100),
		[ISO4217-currency_minor_unit] nvarchar(100),
		[ISO4217-currency_numeric_code] nvarchar(100),
		[ITU] nvarchar(100),
		[Intermediate Region Code] nvarchar(100),
		[Languages] nvarchar(100),
		[and Locked Developing Countries (LLDC)] nvarchar(100),
		[Least Developed Countries (LDC)] nvarchar(100),
		[M49] nvarchar(100),
		[MARC] nvarchar(100),
		[Region Code] nvarchar(100),
		[Region Name] nvarchar(100),
		[L] nvarchar(100),
		[Sub-region Code] nvarchar(100),
		[Sub-region Name] nvarchar(100),
		[TLD] nvarchar(100),
		[UNTERM Arabic Formal] nvarchar(100),
		[UNTERM Arabic Short] nvarchar(100),
		[UNTERM Chinese Formal] nvarchar(100),
		[UNTERM Chinese Short] nvarchar(100),
		[UNTERM English Formal] nvarchar(100),
		[UNTERM English Short] nvarchar(100),
		[UNTERM French Short] nvarchar(100),
		[UNTERM Russian Formal] nvarchar(100),
		[UNTERM Russian Short] nvarchar(100),
		[UNTERM Spanish Formal] nvarchar(100),
		[UNTERM Spanish Short] nvarchar(100),
		[WMO] nvarchar(100),
		[is_independent] nvarchar(100)
		--[official_name_ar] nvarchar(100),
		--[official_name_cn] nvarchar(100),
		--[official_name_en] nvarchar(100),
		--[official_name_es] nvarchar(100),
		--[official_name_fr] nvarchar(100),
		--[official_name_ru] nvarchar(100)
) AS country

--set by variable
DECLARE @json NVARCHAR(MAX)

SET @json= (SELECT *
			FROM OPENROWSET(BULK N'C:\Users\rpipc\Downloads\country-codes_zip\data\country-codes_json.json', SINGLE_CLOB))

SELECT *
FROM OPENJSON(@json);