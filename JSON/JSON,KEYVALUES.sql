DECLARE @Concepts VARCHAR(500)
SET @Concepts = '{"Concepts":[null,12345,"test value",true]}';
SELECT
	[key]
   ,[value]
   ,[type]
FROM OPENJSON(@Concepts, '$.Concepts')