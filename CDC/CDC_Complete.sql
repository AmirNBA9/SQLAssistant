use Northwind
GO

EXEC sp_cdc_enable_db 

GO

SELECT Name, is_cdc_enabled
FROM sys.Databases

GO

EXEC sys.sp_cdc_enable_table  @source_schema = N'dbo',@source_name = N'Products',@role_name = NULL, @Supports_Net_Changes = 1
GO

SELECT Name , is_tracked_by_cdc
FROM Sys.Tables
WHERE is_tracked_by_cdc = 1

GO
EXEC sys.sp_cdc_help_jobs  -- retention time is in minutes. 4320 = 3 days


EXEC sys.sp_cdc_help_change_data_capture
GO


SELECT *
FROM cdc.dbo_Products_CT
GO

INSERT INTO Products(ProductName , CategoryId , UnitPrice)
   VALUES ('Coca Cola' , 1 , 555.00)

SELECT *
FROM cdc.dbo_Products_CT   -- $Operation=2 for inserts

GO
DELETE FROM Products 
  WHERE ProductID = 78

GO

SELECT *
FROM cdc.dbo_Products_CT -- $Operation=1 for deletes


GO

UPDATE Products 
   SET UnitPrice = UnitPrice+1
   WHERE ProductID >= 75

GO

SELECT *
FROM cdc.dbo_Products_CT -- $Operation=3 for Before update &  $Operation=4 for After update 



GO

UPDATE Products 
   SET UnitPrice = UnitPrice  -- no data change produces no CDC record :-)
   WHERE ProductID >= 75

GO

UPDATE Products
   SET UnitPrice=123 , UnitsInStock = 246
   WHERE ProductID = 10


SELECT *
FROM cdc.dbo_Products_CT

GO

CREATE FUNCTION fn_ChangedColumns(@UpdateMask VarBinary(128))
RETURNS nvarchar(1000)
AS
BEGIN
RETURN
(
SELECT TOP 1 
        ( SELECT    CC.column_name + ','
          FROM      cdc.captured_columns CC
                    INNER JOIN cdc.change_tables CT ON CC.[object_id] = CT.[object_id]
          WHERE     capture_instance = 'dbo_Products'
                    AND sys.fn_cdc_is_bit_set(CC.column_ordinal,
                                              PD.__$update_mask) = 1
        FOR
          XML PATH('')
        ) AS changedcolumns
FROM    cdc.dbo_Products_CT PD
WHERE  PD.__$update_mask = @updateMask
)
END

GO



SELECT * , dbo.fn_ChangedColumns(__$update_mask) AS ChangedColumns
FROM cdc.dbo_Products_CT

GO


-- Retrieve Captured Data of Specific Time Frame;
SELECT *
FROM cdc.lsn_time_mapping
GO 

DECLARE @begin_time DATETIME, @end_time DATETIME, @begin_lsn BINARY(10), @end_lsn BINARY(10);

SET @begin_time = GETDATE()-1
SET @end_time = GETDATE();

SET @begin_lsn = sys.fn_cdc_map_time_to_lsn('smallest greater than', @begin_time);
SET @end_lsn = sys.fn_cdc_map_time_to_lsn('largest less than or equal', @end_time);

SELECT *
FROM cdc.fn_cdc_get_all_changes_dbo_Products(@begin_lsn,@end_lsn,'all')


SELECT *
FROM cdc.fn_cdc_get_net_changes_dbo_Products(@begin_lsn,@end_lsn,'all')

-- For the All changes, the third argument cab be All , all Update old
-- For the Net changes, the third argument can be: ALL , All with mask , All with Merge