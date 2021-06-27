
CREATE FUNCTION [dbo].[Calc_Age]
(
@DOB datetime , @calcDate datetime
)
RETURNS int
AS
BEGIN
	declare @age int
	IF (@calcDate < @DOB )
	RETURN -1
	-- If a DOB is supplied after the comparison date, then return -1
	SELECT @age = YEAR(@calcDate) - YEAR(@DOB) +
 	CASE WHEN DATEADD(year,YEAR(@calcDate) - YEAR(@DOB),@DOB) > @calcDate THEN -1 
	ELSE 0 END
 
	RETURN @age
 
END

/*
SELECT
 GETDATE(), --2016-07-21 14:27:37.447
 GETUTCDATE(), --2016-07-21 18:27:37.447
 CURRENT_TIMESTAMP, --2016-07-21 14:27:37.447
 SYSDATETIME(), --2016-07-21 14:27:37.4485768
 SYSDATETIMEOFFSET(),--2016-07-21 14:27:37.4485768 -04:00
 SYSUTCDATETIME() --2016-07-21 18:27:37.4485768
*/