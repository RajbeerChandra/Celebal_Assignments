CREATE VIEW MyProducts AS
SELECT 
    p.ProductID,
    p.ProductName,
    p.QuantityPerUnit,
    p.UnitPrice,
    s.CompanyName,
    c.CategoryName
FROM 
    Products p
    INNER JOIN Suppliers s ON p.SupplierID = s.SupplierID
    INNER JOIN Categories c ON p.CategoryID = c.CategoryID
WHERE 
    p.Discontinued = 0;
