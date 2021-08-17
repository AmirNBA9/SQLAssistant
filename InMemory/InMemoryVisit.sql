--In Memory
Create database InMemory

Alter database InMEMORY add filegroup imoltp_fg contains memory_optimized_data

/*If AUTO-CLOSE error*/
--SELECT name,database_id,*
--FROM sys.databases 
--WHERE is_auto_close_on = 1;

--USE [master]
--GO
--ALTER DATABASE InMEMORY SET AUTO_CLOSE ON WITH NO_WAIT;
--GO

--SELECT name, is_auto_close_on 
--FROM sys.databases 
--WHERE name = 'InMEMORYtable';
/*END*/

Alter database InMEMORY add file (name = 'imoltp_f',filename='C:\Program Files\Microsoft SQL Server\MSSQL15.AH\MSSQL\data\im_oltp2') to filegroup imoltp_fg;

Use InMEMORY
GO
Create table ProductView (
	ID			bigint not null primary key nonclustered identity(1,1),
	UserID		uniqueidentifier not null,
	ProductID	bigint,
	) with (memory_optimized=on)
--'[{"userid":'00000000-0000-0000-0000-000000000000',Productid=147}]'
GO
Create Procedure usp_Productview
	  @UserID		varchar(50) = '00000000-0000-0000-0000-000000000000'
	 ,@ProductID	bigint

with native_compilation,schemabinding 
AS
Begin atomic with (transaction isolation level = snapshot, language='english')
	Begin
		insert into dbo.ProductView (UserID,ProductID)
		Values (@UserID,@ProductID)
		--Select UserID,ProductID
		--From OPENJSON(@Record) with ( UserID			varchar(50) '$.userid'
		--							 ,ProductID			bigint		'$.productid')
	END
END



--test
Create table inmemorytest (
	ID			bigint not null primary key nonclustered identity(1,1),
	firstname	Nvarchar(50),
	lastname	Nvarchar(50),
	Createdate	datetime
	) with (memory_optimized=on)

GO
Alter Proc insertrow
	@records	int
with native_compilation,schemabinding 

as
Begin atomic with (Transaction isolation level = snapshot, language='us_english')
	Declare @counter int = 1
	while @counter <= @records
	Begin
		insert into dbo.inmemorytest (firstname,lastname,Createdate)
		values (N'امیرحسین',N'قاسمی',Getdate())
		Set @counter = @counter+1
	End
END


Execute insertrow 10000


Select * from dbo.inmemorytest

Select * from [dbo].[inmemorytest]

Select Count(1) from [dbo].[inmemorytest]


Select * from dbo.inmemorytest
Where id in( 29123312,29123312,29121312,29123912,29123712,29133312,29124312,29223312)