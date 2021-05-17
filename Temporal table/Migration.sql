ALTER TABLE dbo.AWBuildVersion ADD
[TimeStart] DATETIME2(0) GENERATED ALWAYS AS ROW START NOT NULL,
[TimeEnd] DATETIME2(0) GENERATED ALWAYS AS ROW END NOT NULL CONSTRAINT,
PERIOD FOR SYSTEM_TIME ([TimeStart], [TimeEnd]);
GO
ALTER TABLE dbo.AWBuildVersion
SET ( SYSTEM_VERSIONING = ON ( HISTORY_TABLE = dbo.AWBuildVersion_History ) );
GO


--تغییرات
ALTER TABLE dbo.[dbo].[Temporal_Table_Demo] SET ( SYSTEM_VERSIONING = OFF );
ALTER TABLE [dbo].[dbo].[Temporal_Table_Demo] ADD ID int IDENTITY (1,1);
ALTER TABLE dbo.[dbo].[Temporal_Table_Demo]
SET ( SYSTEM_VERSIONING = ON (HISTORY_TABLE = dbo.[dbo].[Temporal_Table_Demo_History]));