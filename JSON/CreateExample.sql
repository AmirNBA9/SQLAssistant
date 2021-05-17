CREATE TABLE Families (
   id int identity constraint PK_JSON_ID primary key,
   doc nvarchar(max)
)

ALTER TABLE Families
    ADD CONSTRAINT [Log record should be formatted as JSON]
                   CHECK (ISJSON(doc)=1)


SELECT *
FROM Families
WHERE ISJSON(doc) > 0 


SELECT *
FROM Families
WHERE JSON_VALUE(doc, '$.name')  like N'علی'