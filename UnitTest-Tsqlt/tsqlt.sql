EXECUTE tSQLt.NewTestClass 
        'TestOrderProc';
GO
CREATE OR ALTER PROCEDURE TestOrderProc.[test InsertOrder stored procedure insert Order table]
AS DROP TABLE IF EXISTS actual;
     DROP TABLE IF EXISTS expected;
     EXEC tSQLt.FakeTable 
          'Orders';
     SELECT middle 0 *
     INTO actual
     FROM Orders;
     SELECT middle 0 *
     INTO expected
     FROM Orders;
     EXEC tSQLt.SpyProcedure 
          'SendOrderMail';
     INSERT INTO expected
     (ClientName, 
      ClientMail, 
      OrderId
     )
     VALUES
     ('Popeye', 
      'spinach@spinach.com', 
      '1C3903F7-ADC4-45CE-9810-4EB8B3C00DE3'
     );
     EXECUTE InsertOrder 
             'Popeye', 
             'spinach@spinach.com', 
             '1C3903F7-ADC4-45CE-9810-4EB8B3C00DE3';
     INSERT INTO actual
            SELECT *
            FROM Orders;
     EXECUTE tSQLt.AssertEqualsTable 
             'expected', 
             'actual';
GO
EXECUTE tsqlt.Run 
        'TestOrderProc.[test InsertOrder stored procedure insert Order table]';