

Declare @count int = 1
		,@i  varchar(1000)

	While @Count < 1000
		Begin
			Set @i = Convert (varchar(50), @Count + 09121213115)
			Execute [Person].[usp_SignUP] @Username=@i,@Password='1234',@Salt='1234',@UserType=3,@FirstName=N'علی',@LastName=N'محمدی',@CountryID=88,@Code=0,@LanguageID=33
			Set @count = @count + 1
		End

	Set @count += 1
FETCH NEXT FROM C;  