CREATE PROCEDURE InsertOrderDetails
    @OrderID INT,
    @ProductID INT,
    @UnitPrice DECIMAL(18, 2) = NULL,
    @Quantity INT,
    @Discount DECIMAL(4, 2) = 0
AS
BEGIN
    DECLARE @Stock INT;
    DECLARE @ReorderLevel INT;
    DECLARE @ProductUnitPrice DECIMAL(18, 2);

    SELECT @Stock = UnitsInStock, @ReorderLevel = ReorderLevel, @ProductUnitPrice = UnitPrice
    FROM Products
    WHERE ProductID = @ProductID;

    IF @Stock < @Quantity
    BEGIN
        PRINT 'Not enough stock available. Aborting operation.';
        RETURN;
    END

    IF @UnitPrice IS NULL
    BEGIN
        SET @UnitPrice = @ProductUnitPrice;
    END

    INSERT INTO [Order Details] (OrderID, ProductID, UnitPrice, Quantity, Discount)
    VALUES (@OrderID, @ProductID, @UnitPrice, @Quantity, @Discount);

    IF @@ROWCOUNT = 0
    BEGIN
        PRINT 'Failed to place the order. Please try again.';
        RETURN;
    END

    UPDATE Products
    SET UnitsInStock = UnitsInStock - @Quantity
    WHERE ProductID = @ProductID;

    IF (UnitsInStock - @Quantity) < @ReorderLevel
    BEGIN
        PRINT 'Warning: The quantity in stock for the product has dropped below the reorder level.';
    END
END;
