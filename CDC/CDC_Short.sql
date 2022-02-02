-- Example of enabling CDC:

USE Northwind
GO

EXEC sys.sp_cdc_enable_db
GO

EXEC sys.sp_cdc_enable_table
@source_schema = N'dbo',
@source_name   = N'Orders',
@role_name     = NULL,
@supports_net_changes = 1
GO
EXEC sys.sp_cdc_enable_table
@source_schema = N'dbo',
@source_name   = N'Order Details',
@role_name     = NULL,
@supports_net_changes = 1
GO