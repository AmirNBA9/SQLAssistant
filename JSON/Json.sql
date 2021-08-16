--JSON SYNTAX

--Modify JSON
DECLARE @json NVARCHAR(MAX);
SET @json = '{"info":{"address":[{"town":"Belgrade"},{"town":"Paris"},{"town":"Madrid"}]}}';
if ISJSON(@json) > 0
	begin
	SET @json = JSON_MODIFY(@json,'$.info.address[0].town','London');
	SELECT modifiedJson = @json;
	end

---2
--SELECT 
-- JSON_VALUE(FirstName,'$.info.address.PostCode') AS PostCode
-- JSON_VALUE(FirstName,'$.info.address."Address Line 1"')+' '
--  +JSON_VALUE(FirstName,'$.info.address."Address Line 2"') AS Address,
-- JSON_QUERY(FirstName,'$.info.skills') AS Skills
--FROM [Person].[Person] p
--WHERE ISJSON(FirstName)>0 
-- AND JSON_VALUE(FirstName,'$.info.address.Town')='Belgrade'
--ORDER BY JSON_VALUE(FirstName,'$.info.address.PostCode')


---3
DECLARE @json NVARCHAR(MAX)
SET @json =
N'[
       { "id" : 2,"info": { "name": "John", "surname": "Smith" }, "age": 25 },
       { "id" : 5,"info": { "name": "Jane", "surname": "Smith" }, "dob": "2005-11-04T12:00:00" }
 ]'

SELECT *
FROM OPENJSON(@json)
  WITH (id int 'strict $.id',
        firstName nvarchar(50) '$.info.name',
		lastName nvarchar(50) '$.info.surname',
        age int, dateOfBirth datetime2 '$.dob')



--4
DECLARE @json NVARCHAR(MAX)
SET @json =
N'[
       { "id" : 2,"info": { "name": "John", "surname": "Smith" }, "age": 25 },
       { "id" : 5,"info": { "name": "Jane", "surname": "Smith", "skills": ["SQL", "C#", "Azure"] }, "dob": "2005-11-04T12:00:00" }
 ]'

SELECT *
FROM OPENJSON(@json)
WITH (id int 'strict $.id',
	firstName nvarchar(50) '$.info.name',
	lastName nvarchar(50) '$.info.surname',
	age int, 
	dateOfBirth datetime2 '$.dob',
	skills nvarchar(max) '$.info.skills' as json)
		outer apply openjson( skills )
        with ( skill nvarchar(8) '$' )


--5
SELECT [BusinessEntityID], firstName AS "info.name", lastName AS "info.surname",[EmailPromotion] , [AdditionalContactInfo] 
FROM [Person].[Person]
FOR JSON PATH




N'[{ "ProductID" : 2,"ColorHex": FF12A5 },{ "ProductID" : 5,"ColorHex": H00011}]'



--6 Nullable
Declare @j nvarchar(1000) = N'[{"":""}]'

select JSON_VALUE(@j,'$[0].name')
GO

Declare @j nvarchar(1000) = Null

select JSON_VALUE(@j,'$[0].name')