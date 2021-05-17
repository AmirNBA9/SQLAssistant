/*install tSQLt*/

/*1*/
EXEC sp_configure 'clr enabled', 1;
RECONFIGURE;
GO
EXEC sp_configure 'clr enabled'

/*2*/
USE WideWorldImporters 
GO
ALTER DATABASE WideWorldImporters SET TRUSTWORTHY ON;


/*3*/
--از پکیج استفاده شود
http://sourceforge.net/projects/tsqlt/files/latest/download
-- inistall class


/*4*/
--following query shows the tSQLt framework objects list which are installed to Azure SQL database also Dbversion column indicates version of the Azure SQL database.
SELECT @@VERSION,name
 FROM sys.objects sysobj where schema_id = (
select sch.schema_id from sys.schemas sch where name='tSQLt' )
order by sysobj.name



/*5*/
-- add new class
USE WideWorldImporters
GO
EXEC tSQLt.NewTestClass 'DemoUnitTestClass';

/*6*/
--

select SCHEMA_NAME,objtype,name,value from INFORMATION_SCHEMA.SCHEMATA SC
CROSS APPLY fn_listextendedproperty (NULL, 'schema', NULL, NULL, NULL, NULL, NULL) OL
WHERE OL.objname=sc.SCHEMA_NAME COLLATE Latin1_General_CI_AI
and SCHEMA_NAME = 'DemoUnitTestClass'

/*7*/
--Drop a class
EXEC tSQLt.DropClass  'DemoUnitTestClass'


/*8*/
/*
The tSQLt framework offers a bunch of test methods for SQL unit testing operations so that we can use this method under different circumstances.

tSQLt.AsserEquals						--This method allows us to compare the expected and actual values and it takes three input parameters;
tSQLr.AssertEqualsTable					--
tSQLt.AssertEmptyTable					--
tSQLt.AssertEqualsString				--
tSQLt.AssertEqualsTableSchema			--
tSQLt.AssertLike						--
tSQLt.AssertNotEquals					--
AssertObjectDoesNotExist				--
AssertObjectExists						--
AssertResultSetsHaveSameMetaData		--
Fail
*/

--1. 
/*
tSQLt.AsserEquals: This method allows us to compare the expected and actual values and it takes three input parameters;

@expected: This parameter specifies expected value namely the result of the test value compared with this value.

@actual: This parameter specifies the result of the test.

@message: If the unit test returns fail, we can customize the error message with the help of the parameter.
*/
/*TEST*/
-- 1
CREATE OR ALTER FUNCTION CalculateTaxAmount(@amt MONEY)
RETURNS MONEY
AS BEGIN
RETURN (@amt /100)*18 
END;
GO
 
select dbo.CalculateTaxAmount(100) AS TaxAmount

--2

EXEC tSQLt.NewTestClass 'DemoUnitTestClass';
GO
 
 
CREATE OR ALTER PROC DemoUnitTestClass.[test tax amount]
AS
BEGIN
DECLARE @TestedAmount as money = 100
DECLARE @expected as money  = 20 --check by 20 
DECLARE @actual AS money 
--DECLARE @Message AS VARCHAR(500)='Wrong tax amount'  --add then

SET @actual = dbo.CalculateTaxAmount(100)
 
EXEC tSQLt.AssertEquals @expected , @actual--, @Message
 
END

--3
tSQLt.Run 'DemoUnitTestClass.[test tax amount]'

--4
tSQLt.Run 'DemoUnitTestClass'

