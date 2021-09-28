
/****** Object:  StoredProcedure Common.[usp_MainInsert]    Script Date: 2/19/2020 10:03:34 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		AmirhosseinGhasemi
-- Create date: 1398/11/15
-- Description:	Entry data to main table
-- =============================================
ALTER PROCEDURE COMMON.[usp_MainInsert]
	-- Add the parameters for the stored procedure here
	@MainGroupID	int,
	@MainId			int,
	@MainDesc		Nvarchar(50),
	@LanguageID		int = 33,
	@SortNum		smallint = 0,
	@SPAction		tinyint = 0			/* 0-->insert	1-->Update	2-->Delete */

AS
--Parameter check
if @LanguageID not in (Select LanguageID from Common.Languages WHERE Active=1)
	Begin
        RAISERROR(N'کد زبان متشکل از یک الی سه عدد است',16,1);
		ROLLBACK;
	End
if @MainDesc in (Select Maindesc From Common.Main)
	Begin

        RAISERROR(N'این توصبف در جدول موجود است.',16,1); 
		ROLLBACK;
	End
-- End check

Begin
SET NOCOUNT ON;
--If @mainid is null
--	Set @mainid = (Select Max(mainid)+1 from Common.Main where MainGroupID=@MainGroupID and LanguageID=@LanguageID)--Set MainID parameter

If @SPAction = 0	--Insert
	Begin
		if Convert(char(30),@MainGroupID)+Convert(char(10),@LanguageID)+Convert(char(10),@MainID) not in (select Convert(char(10),MainGroupID)+Convert(char(10),LanguageID)+Convert(char(10),MainID) from common.Main) --AND @MainID not in (Select distinct MainID From common.Main where MainGroupID=@MainGroupID) And @LanguageID not in (Select distinct LanguageID from Common.Main where MainGroupID=@MainGroupID and MainId=@MainID)
		BEGIN
	
			Insert into Common.Main ([MainGroupID], [MainID], [MainDesc],LanguageID, [Flag], [Sort], CreateDate)
			Values (@MainGroupID,@MainID,@MainDesc,@LanguageID,1,@Sortnum,Getdate())
		END
	End
else
If @SPAction = 1	--Update
	Begin
		
		Update common.Main
		Set MainDesc = @MainDesc
		Where MainGroupID = @MainGroupID and MainID = @MainID and  LanguageID = @LanguageID
	End

If @SPAction = 2
	Begin

		Delete From Common.Main
		Where MainGroupID=@MainGroupID AND MainID=@MainId AND LanguageID=@LanguageID
	End



--نمایش نتیجه در خروجی
	Declare @SQL Nvarchar(4000) ='', @MainGroupID2 nvarchar(10) =  Convert(Nvarchar(10),@MainGroupID)
	Set @SQL ='
	Select * 
	from fun.MainFinder ('+@MainGroupID2+')'
	--Print @SQL
	Exec (@SQL)
End
