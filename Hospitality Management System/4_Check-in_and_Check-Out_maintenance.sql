CREATE PROCEDURE sp_CheckIn
    @ReservationID INT
AS
BEGIN
    SET NOCOUNT ON;

    UPDATE Reservations
    SET Status = 'Checked In'
    WHERE ReservationID = @ReservationID

    SELECT 'Check-in Successful' AS Message
END

CREATE PROCEDURE sp_CheckOut
    @ReservationID INT
AS
BEGIN
    SET NOCOUNT ON;

    UPDATE Reservations
    SET Status = 'Completed'
    WHERE ReservationID = @ReservationID

    UPDATE Bills
    SET PaymentStatus = 'Paid'
    WHERE ReservationID = @ReservationID

    SELECT 'Check-out Successful' AS Message
END