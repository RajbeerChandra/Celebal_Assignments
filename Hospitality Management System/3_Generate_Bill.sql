CREATE PROCEDURE sp_GenerateBill
    @ReservationID INT
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @TotalAmount DECIMAL(10, 2)

    SELECT @TotalAmount = TotalPrice
    FROM Reservations
    WHERE ReservationID = @ReservationID

    INSERT INTO Bills (ReservationID, BillDate, TotalAmount, PaymentStatus)
    VALUES (@ReservationID, GETDATE(), @TotalAmount, 'Unpaid')

    SELECT SCOPE_IDENTITY() AS BillID
END