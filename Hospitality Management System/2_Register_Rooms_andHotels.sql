CREATE PROCEDURE sp_RegisterHotel
    @HotelName VARCHAR(100),
    @Address VARCHAR(255),
    @City VARCHAR(50),
    @Country VARCHAR(50),
    @PhoneNumber VARCHAR(20)
AS
BEGIN
    SET NOCOUNT ON;

    INSERT INTO Hotels (HotelName, Address, City, Country, PhoneNumber)
    VALUES (@HotelName, @Address, @City, @Country, @PhoneNumber)

    SELECT SCOPE_IDENTITY() AS HotelID
END

CREATE PROCEDURE sp_RegisterRoom
    @HotelID INT,
    @RoomNumber VARCHAR(10),
    @RoomTypeID INT
AS
BEGIN
    SET NOCOUNT ON;

    INSERT INTO Rooms (HotelID, RoomNumber, RoomTypeID)
    VALUES (@HotelID, @RoomNumber, @RoomTypeID)

    SELECT SCOPE_IDENTITY() AS RoomID
END