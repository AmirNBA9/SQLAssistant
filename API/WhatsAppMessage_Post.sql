-- EXEC WhatsappApi_SendMessage

Alter PROC WhatsappApi_SendMessage
AS
BEGIN
	-- Count of refresh and fill data
	-- Declare @CountRefresh INT = (Select  Count(1) From );
	--Declare @CountFill varchar(3) = (SELECT Count(1) FROM [Reporting].[dbo].[vw_PackageMonitor] Where Error is NULL);
	--Declare @Date datetime = (SELECT Top 1 StartTime FROM [Reporting].[dbo].[vw_PackageMonitor] Order by EndTime desc);
	-- Whats app send message
	DECLARE @Time datetime = GETDATE()
	DECLARE @Message varchar(500) = 'All fill is Last Start Date is '
	--Select @Message
	DECLARE @Url varchar(1000) = 'https://api.callmebot.com/whatsapp.php?phone=[PhoneNumber]&text=fill+is+done&apikey=531059'
	--select @Url
	DECLARE @Win int
	DECLARE @Hr  int
	DECLARE @Text varchar(8000)
	
	--If (DATEPART(HH,@Time) between 8 and 9)
	Begin Try
		EXEC @Hr=sp_OACreate 'WinHttp.WinHttpRequest.5.1',@Win OUT
		IF @Hr <> 0 
			EXEC sp_OAGetErrorInfo @Win

		EXEC @Hr=sp_OAMethod @Win, 'Open',NULL,'GET',@Url,'false'
		IF @Hr <> 0 
			EXEC sp_OAGetErrorInfo @Win
		
		EXEC @Hr=sp_OAMethod @Win,'Send'
		IF @Hr <> 0 
			EXEC sp_OAGetErrorInfo @Win
		
		EXEC @Hr=sp_OAGetProperty @Win,'ResponseText',@Text OUTPUT
		IF @Hr <> 0 
			EXEC sp_OAGetErrorInfo @Win
	
		EXEC @Hr=sp_OADestroy @Win
		IF @Hr <> 0 
			EXEC sp_OAGetErrorInfo @Win
	END Try
	Begin catch
		Throw;
	End catch
END