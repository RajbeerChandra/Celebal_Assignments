CREATE PROCEDURE sp_CheckRoomAvailability
    @HotelID INT,
    @RoomTypeID INT,
    @CheckInDate DATE,
    @CheckOutDate DATE
AS
BEGIN
    SET NOCOUNT ON;

    SELECT R.RoomID, R.RoomNumber
    FROM Rooms R
    LEFT JOIN Reservations RES ON R.RoomID = RES.RoomID
        AND (
            (@CheckInDate BETWEEN RES.CheckInDate AND RES.CheckOutDate)
            OR (@CheckOutDate BETWEEN RES.CheckInDate AND RES.CheckOutDate)
            OR (RES.CheckInDate BETWEEN @CheckInDate AND @CheckOutDate)
        )
    WHERE R.HotelID = @HotelID
        AND R.RoomTypeID = @RoomTypeID
        AND RES.ReservationID IS NULL

    -- If no rooms are available, suggest alternative dates
    IF @@ROWCOUNT = 0
    BEGIN
        SELECT TOP 1 
            RES.CheckOutDate AS SuggestedCheckInDate,
            DATEADD(DAY, DATEDIFF(DAY, @CheckInDate, @CheckOutDate), RES.CheckOutDate) AS SuggestedCheckOutDate
        FROM Reservations RES
        INNER JOIN Rooms R ON RES.RoomID = R.RoomID
        WHERE R.HotelID = @HotelID
            AND R.RoomTypeID = @RoomTypeID
            AND RES.CheckOutDate > @CheckOutDate
        ORDER BY RES.CheckOutDate ASC
    END
END