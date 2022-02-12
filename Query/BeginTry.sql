-- Transaction in a TRY/CATCH
-- This will rollback both inserts due to an invalid datetime:
BEGIN TRANSACTION;
BEGIN TRY
    INSERT INTO dbo.Sale (Price, SaleDate, Quantity)
    VALUES (5.2, GETDATE (), 1);
    INSERT INTO dbo.Sale (Price, SaleDate, Quantity)
    VALUES (5.2, 'not a date', 1);
    COMMIT TRANSACTION;
END TRY
BEGIN CATCH
    ROLLBACK TRANSACTION -- First Rollback and then throw.
    THROW;
END CATCH;

-- This will commit both inserts:
BEGIN TRANSACTION;
BEGIN TRY
    INSERT INTO dbo.Sale (Price, SaleDate, Quantity)
    VALUES (5.2, GETDATE (), 1);
    INSERT INTO dbo.Sale (Price, SaleDate, Quantity)
    VALUES (5.2, GETDATE (), 1);
    COMMIT TRANSACTION;
END TRY
BEGIN CATCH
    THROW;
    ROLLBACK TRANSACTION;
END CATCH;

-- Raising errors in try-catch block
DECLARE @msg NVARCHAR(50) = N'Here is a problem!';
BEGIN TRY
    PRINT 'First statement';
    RAISERROR (@msg, 11, 1);
    PRINT 'Second statement';
END TRY
BEGIN CATCH
    PRINT 'Error: ' + ERROR_MESSAGE ();
END CATCH;
/*
RAISERROR with second parameter greater than 10 (11 in this example) will stop execution in TRY BLOCK and raise
an error that will be handled in CATCH block. You can access error message using ERROR_MESSAGE() function.
Output of this sample is:
*/

-- Raising info messages in try catch block
-- RAISERROR with severity (second parameter) less or equal to 10 will not throw exception.
BEGIN TRY
    PRINT 'First statement';
    RAISERROR ('Here is a problem!', 10, 15);
    PRINT 'Second statement';
END TRY
BEGIN CATCH
    PRINT 'Error: ' + ERROR_MESSAGE ();
END CATCH;

-- Re-throwing exception generated by RAISERROR
DECLARE @msg NVARCHAR(50) = N'Here is a problem! Area: ''%s'' Line:''%i''';
BEGIN TRY
    PRINT 'First statement';
    RAISERROR (@msg, 11, 1, 'TRY BLOCK', 2);
    PRINT 'Second statement';
END TRY
BEGIN CATCH
    PRINT 'Error: ' + ERROR_MESSAGE ();
    THROW;
END CATCH;
GO
/*
Note that in this case we are raising error with formatted arguments (fourth and fifth parameter). This might be
useful if you want to add more info in message. Result of execution is:
First statement
Error: Here is a problem! Area: 'TRY BLOCK' Line:'2'
Msg 50000, Level 11, State 1, Line 26
Here is a problem! Area: 'TRY BLOCK' Line:'2'
*/

-- Throwing exception in TRY/CATCH blocks
DECLARE @msg NVARCHAR(50) = N'Here is a problem!';
BEGIN TRY
    PRINT 'First statement';
    THROW 51000, @msg, 15;
    PRINT 'Second statement';
END TRY
BEGIN CATCH
    PRINT 'Error: ' + ERROR_MESSAGE ();
    THROW;
END CATCH;

/*
THROW is similar to RAISERROR with following differences:
1. Recommendation is that new applications should use THROW instead of RASIERROR.
2. THROW can use any number as first argument (error number), RAISERROR can use only ids in sys.messages view
3. THROW has severity 16 (cannot be changed)
4. THROW cannot format arguments like RAISERROR. Use FORMATMESSAGE function as an argument of RAISERROR if you need this feature.
*/