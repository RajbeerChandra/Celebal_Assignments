CREATE TRIGGER trgBeforeInsertOrderDetails
ON [Order Details]
INSTEAD OF INSERT
AS
BEGIN
    DECLARE @ProductID INT;
    DECLARE @OrderID INT;
    DECLARE @Quantity INT;
    DECLARE @UnitsInStock INT;

    DECLARE cur CURSOR FOR
    SELECT OrderID, ProductID, Quantity
    FROM inserted;

    OPEN cur;

    FETCH NEXT FROM cur INTO @OrderID, @ProductID, @Quantity;

    WHILE @@FETCH_STATUS = 0
    BEGIN

        SELECT @UnitsInStock = UnitsInStock
        FROM Products
        WHERE ProductID = @ProductID;

        IF @UnitsInStock >= @Quantity
        BEGIN
            UPDATE Products
            SET UnitsInStock = UnitsInStock - @Quantity
            WHERE ProductID = @ProductID;

            INSERT INTO [Order Details] (OrderID, ProductID, UnitPrice, Quantity, Discount)
            SELECT OrderID, ProductID, UnitPrice, Quantity, Discount
            FROM inserted
            WHERE OrderID = @OrderID AND ProductID = @ProductID;
        END
        ELSE
        BEGIN
            RAISERROR ('Insufficient stock for ProductID %d. Order could not be filled.', 16, 1, @ProductID);
        END

        FETCH NEXT FROM cur INTO @OrderID, @ProductID, @Quantity;
    END

    CLOSE cur;
    DEALLOCATE cur;
END;
