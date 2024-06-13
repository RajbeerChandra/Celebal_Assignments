CREATE PROCEDURE GetOrderDetails
    @OrderID INT
AS
BEGIN

    IF NOT EXISTS (SELECT 1 FROM [Order Details] WHERE OrderID = @OrderID)
    BEGIN
        PRINT 'The OrderID ' + CAST(@OrderID AS VARCHAR(10)) + ' does not exist.';
        RETURN 1;
    END

    SELECT * FROM [Order Details] WHERE OrderID = @OrderID;
END;
