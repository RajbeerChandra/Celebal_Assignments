CREATE PROCEDURE sp_LoginUser
    @Username VARCHAR(50),
    @Password VARCHAR(255)
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @UserID INT
    DECLARE @UserType VARCHAR(20)

    SELECT @UserID = UserID, @UserType = UserType
    FROM Users
    WHERE Username = @Username AND Password = @Password

    IF @UserID IS NOT NULL
    BEGIN
        SELECT @UserID AS UserID, @UserType AS UserType, 'Login Successful' AS Message
    END
    ELSE
    BEGIN
        SELECT 0 AS UserID, NULL AS UserType, 'Invalid Credentials' AS Message
    END
END