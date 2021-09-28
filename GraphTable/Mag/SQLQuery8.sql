Alter table person.personal
add MaritalType int
go

EXEC	Common.[usp_MainInsert]
		@MainGroupID = 11,
		@mainid = 1,
		@MainDesc = N'مجرد',
		@LanguageID = 33
GO

EXEC	Common.[usp_MainInsert]
		@MainGroupID = 11,
		@mainid = 2,
		@MainDesc = N'متاهل',
		@LanguageID = 33
GO

EXEC	Common.[usp_MainInsert]
		@MainGroupID = 11,
		@mainid = 1,
		@MainDesc = N'Single',
		@LanguageID = 29
GO

EXEC	Common.[usp_MainInsert]
		@MainGroupID = 11,
		@mainid = 2,
		@MainDesc = N'Married',
		@LanguageID = 29
GO

EXEC	Common.[usp_MainInsert]
		@MainGroupID = 11,
		@mainid = 1,
		@MainDesc = N'أعزب',
		@LanguageID = 6
GO

EXEC	Common.[usp_MainInsert]
		@MainGroupID = 11,
		@mainid = 2,
		@MainDesc = N'متزوج',
		@LanguageID = 6
GO