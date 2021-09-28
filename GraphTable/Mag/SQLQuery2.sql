
--Create table Node for Collate Magazine
CREATE TABLE Mag.Node_Magazine(
    [MagazineID]	bigint IDENTITY(1,1)	NOT NULL primary key,
	[Note]			Nvarchar(max)			Not null,
	[Title]			Nvarchar(50)			Not Null,
	UserCode		bigint					Not Null,
	EstimateRead	time					Null,
	[CreateDate]	datetime				Not Null,
	[UpdateDate]	datetime				null,
	[LanguageID]	tinyint					null,
	[Status]		tinyint
) AS NODE
GO
EXEC sp_bindefault 
   N'Common.CreateDate', 
   N'Mag.Node_Magazine.CreateDate'
GO

--Node tags
CREATE TABLE Mag.Node_Tags(
	[TagID]		bigint IDENTITY(1,1) NOT NULL primary key,
	[Tag]			Nvarchar(30),
	[CreateDate]	datetime, 
	[LastUpDate]	datetime,
	[Status]		tinyint default '1'
) AS NODE
GO
EXEC sp_bindefault 
   N'Common.CreateDate', 
   N'Mag.Node_Tags.CreateDate'
GO
--Edge
CREATE TABLE Mag.Edge_MagazineTags (CreateDate datetime null ,Status bit null default '2')
AS EDGE
GO
-- Bind the default to a column
EXEC sp_bindefault 
   N'Common.CreateDate', 
   N'Mag.Edge_MagazineTags.CreateDate'
GO