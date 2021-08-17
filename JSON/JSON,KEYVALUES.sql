 declare @Concepts varchar(500)
 set @Concepts = '{"Concepts":[1,2,3,4]}';
 select [key],[value] from openjson(@Concepts,'$.Concepts')