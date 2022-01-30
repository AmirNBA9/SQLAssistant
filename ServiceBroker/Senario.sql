-- Enabling Service Broker
ALTER DATABASE OrderDB 
SET ENABLE_BROKER;

-- Create Valid Message Types
CREATE MESSAGE TYPE ReceivedOrders
AUTHORIZATION dbo
VALIDATION = None

-- Create a Contract for the Conversation
CREATE CONTRACT postmessages
(ReceivedOrders SENT BY ANY)

-- Create Queues for the Communication
CREATE QUEUE OrderQueue
WITH STATUS = ON, RETENTION = OFF

-- Create Services for the Communication
CREATE SERVICE OrderService
AUTHORIZATION dbo 
ON QUEUE OrderQueue
(postmessages)

-- 6
CREATE TABLE [dbo].[Orders](
  [OrderID] [int] NOT NULL,
  [OrderDate] [date] NULL,
  [ProductCode] [varchar](50) NOT NULL,
  [Quantity] [numeric](9, 2) NULL,
  [UnitPrice] [numeric](9, 2) NULL,
 CONSTRAINT [PK__Orders] PRIMARY KEY CLUSTERED 
(
  [OrderID] ASC,
  [ProductCode] ASC
)
ON [PRIMARY]
) ON [PRIMARY]
GO

-- 7
CREATE PROCEDURE usp_CreateOrders (
  @OrderID INT
  ,@ProductCode VARCHAR(50)
  ,@Quantity NUMERIC(9, 2)
  ,@UnitPrice NUMERIC(9, 2)
  )
AS
BEGIN
  DECLARE @OrderDate AS SMALLDATETIME
  SET @OrderDate = GETDATE()
  DECLARE @XMLMessage XML
 
  CREATE TABLE #Message (
    OrderID INT PRIMARY KEY
    ,OrderDate DATE
    ,ProductCode VARCHAR(50)
    ,Quantity NUMERIC(9, 2)
    ,UnitPrice NUMERIC(9, 2)
    )
 
  INSERT INTO #Message (
    OrderID
    ,OrderDate
    ,ProductCode
    ,Quantity
    ,UnitPrice
    )
  VALUES (
    @OrderID
    ,@OrderDate
    ,@ProductCode
    ,@Quantity
    ,@UnitPrice
    )
 
  --Insert to Orders Table
  INSERT INTO Orders (
    OrderID
    ,OrderDate
    ,ProductCode
    ,Quantity
    ,UnitPrice
    )
  VALUES (
    @OrderID
    ,@OrderDate
    ,@ProductCode
    ,@Quantity
    ,@UnitPrice
    )
     --Creating the XML Message
  SELECT @XMLMessage = (
      SELECT *
      FROM #Message
      FOR XML PATH('Order')
        ,TYPE
      );
 
  DECLARE @Handle UNIQUEIDENTIFIER;
  --Sending the Message to the Queue
  BEGIN
    DIALOG CONVERSATION @Handle
    FROM SERVICE OrderService TO SERVICE 'OrderService' ON CONTRACT [postmessages]
    WITH ENCRYPTION = OFF;
 
    SEND ON CONVERSATION @Handle MESSAGE TYPE ReceivedOrders(@XMLMessage);
  END 
  GO

-- 8
usp_CreateOrders 202003,'PD0001',1,10.50
usp_CreateOrders 202003,'PD0002',2,100.75
usp_CreateOrders 202003,'PD0010',1.5,20.00

-- 9
SELECT service_name
,priority,
queuing_order,
service_contract_name,
message_type_name,
validation,
message_body,
message_enqueue_time,
status
FROM dbo.OrderQueue

-- 10
DECLARE @Handle UNIQUEIDENTIFIER ;
 DECLARE @MessageType SYSNAME ;
 DECLARE @Message XML
 DECLARE @OrderDate DATE
 DECLARE @OrderID INT 
 DECLARE @ProductCode VARCHAR(50)
 DECLARE @Quantity NUMERIC (9,2)
 DECLARE @UnitPrice NUMERIC (9,2)
 
WAITFOR( RECEIVE TOP (1)  
@Handle = conversation_handle,
@MessageType = message_type_name,
@Message = message_body FROM dbo.OrderQueue),TIMEOUT 1000
 
SET @OrderID   =   CAST(CAST(@Message.query('/Order/OrderID/text()') AS NVARCHAR(MAX)) AS INT)
SET @OrderDate   =   CAST(CAST(@Message.query('/Order/OrderDate/text()') AS NVARCHAR(MAX)) AS DATE)
SET @ProductCode =   CAST(CAST(@Message.query('/Order/ProductCode/text()') AS NVARCHAR(MAX)) AS VARCHAR(50))
SET @Quantity    =   CAST(CAST(@Message.query('/Order/Quantity/text()') AS NVARCHAR(MAX)) AS NUMERIC(9,2))
SET @UnitPrice   =   CAST(CAST(@Message.query('/Order/UnitPrice/text()') AS NVARCHAR(MAX)) AS NUMERIC(9,2))
 
PRINT @OrderID
PRINT @OrderDate
PRINT @ProductCode
PRINT @Quantity
PRINT @UnitPrice

/*https://www.sqlshack.com/using-the-sql-server-service-broker-for-asynchronous-processing/*/