/*1*/
CREATE TABLE Pictures ( 
pictureName NVARCHAR(40) PRIMARY KEY NOT NULL ,picFileName NVARCHAR (100),PictureData VARBINARY (max) )
GO

/*2*/
Use master
Go
EXEC sp_configure 'show advanced options', 1; 
GO
RECONFIGURE; 
GO 
EXEC sp_configure 'Ole Automation Procedures', 1; 
GO
RECONFIGURE;
GO 
ALTER SERVER ROLE [bulkadmin] ADD MEMBER sa
GO
--exec sp_changedbowner 'sa', 'true'
/*3*/
CREATE PROCEDURE dbo.usp_ImportImage (
     @PicName NVARCHAR (100)
   , @ImageFolderPath NVARCHAR (1000)
   , @Filename NVARCHAR (1000)
   )
AS
BEGIN
   DECLARE @Path2OutFile NVARCHAR (2000);
   DECLARE @tsql NVARCHAR (2000);
   SET NOCOUNT ON
   SET @Path2OutFile = CONCAT (
         @ImageFolderPath
         ,'\'
         , @Filename
         );
   SET @tsql = 'insert into Pictures (pictureName, picFileName, PictureData) ' +
               ' SELECT ' + '''' + @PicName + '''' + ',' + '''' + @Filename + '''' + ', * ' + 
               'FROM Openrowset( Bulk ' + '''' + @Path2OutFile + '''' + ', Single_Blob) as img'
   EXEC (@tsql)
   SET NOCOUNT OFF
END
GO

/*4*/
CREATE PROCEDURE dbo.usp_ExportImage (
   @PicName NVARCHAR (100)
   ,@ImageFolderPath NVARCHAR(1000)
   ,@Filename NVARCHAR(1000)
   )
AS
BEGIN
   DECLARE @ImageData VARBINARY (max);
   DECLARE @Path2OutFile NVARCHAR (2000);
   DECLARE @Obj INT
 
   SET NOCOUNT ON
 
   SELECT @ImageData = (
         SELECT convert (VARBINARY (max), PictureData, 1)
         FROM Pictures
         WHERE pictureName = @PicName
         );
 
   SET @Path2OutFile = CONCAT (
         @ImageFolderPath
         ,'\'
         , @Filename
         );
    BEGIN TRY
     EXEC sp_OACreate 'ADODB.Stream' ,@Obj OUTPUT;
     EXEC sp_OASetProperty @Obj ,'Type',1;
     EXEC sp_OAMethod @Obj,'Open';
     EXEC sp_OAMethod @Obj,'Write', NULL, @ImageData;
     EXEC sp_OAMethod @Obj,'SaveToFile', NULL, @Path2OutFile, 2;
     EXEC sp_OAMethod @Obj,'Close';
     EXEC sp_OADestroy @Obj;
    END TRY
    
 BEGIN CATCH
  EXEC sp_OADestroy @Obj;
 END CATCH
 
   SET NOCOUNT OFF
END
GO

/*6*/
exec dbo.usp_ImportImage 'DRAGON','E:\MyPictures\Input','4.jpg'

/*7*/
exec dbo.usp_ExportImage 'DRAGON','E:\MyPictures\Output','1.jpg'

/*https://www.mssqltips.com/ https://vrgl.ir/5LHui */