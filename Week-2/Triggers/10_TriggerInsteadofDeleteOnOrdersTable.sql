CREATE TRIGGER trgInsteadOfDeleteOrders
ON Orders
INSTEAD OF DELETE
AS
BEGIN

    DELETE FROM [Order Details]
    WHERE OrderID IN (SELECT OrderID FROM deleted);

    DELETE FROM Orders
    WHERE OrderID IN (SELECT OrderID FROM deleted);
END;
