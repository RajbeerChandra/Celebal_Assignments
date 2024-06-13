CREATE PROCEDURE UpdateOrderDetails
    @OrderID INT,
    @ProductID INT,
    @UnitPrice DECIMAL(18, 2) = NULL,
    @Quantity INT = NULL,
    @Discount DECIMAL(4, 2) = NULL
AS
BEGIN
    DECLARE @CurrentUnitPrice DECIMAL(18, 2);
    DECLARE @CurrentQuantity INT;
    DECLARE @CurrentDiscount DECIMAL(4, 2);
    DECLARE @NewUnitPrice DECIMAL(18, 2);
    DECLARE @NewQuantity INT;
    DECLARE @NewDiscount DECIMAL(4, 2);
    DECLARE @Stock INT;
    DECLARE @StockChange INT;

    SELECT @CurrentUnitPrice = UnitPrice, @CurrentQuantity = Quantity, @CurrentDiscount = Discount
    FROM [Order Details]
    WHERE OrderID = @OrderID AND ProductID = @ProductID;

    SET @NewUnitPrice = ISNULL(@UnitPrice, @CurrentUnitPrice);
    SET @NewQuantity = ISNULL(@Quantity, @CurrentQuantity);
    SET @NewDiscount = ISNULL(@Discount, @CurrentDiscount);

    SET @StockChange = @NewQuantity - @CurrentQuantity;

    SELECT @Stock = UnitsInStock
    FROM Products
    WHERE ProductID = @ProductID;

    IF @Stock < @StockChange
    BEGIN
        PRINT 'Not enough stock available to update the order. Aborting operation.';
        RETURN;
    END

    UPDATE [Order Details]
    SET UnitPrice = @NewUnitPrice, Quantity = @NewQuantity, Discount = @NewDiscount
    WHERE OrderID = @OrderID AND ProductID = @ProductID;

    IF @@ROWCOUNT = 0
    BEGIN
        PRINT 'Failed to update the order. Please try again.';
        RETURN;
    END

    UPDATE Products
    SET UnitsInStock = UnitsInStock - @StockChange
    WHERE ProductID = @ProductID;
END;
