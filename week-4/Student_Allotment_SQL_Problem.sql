CREATE PROCEDURE AllocateSubjects
AS
BEGIN
    SET NOCOUNT ON;

    CREATE TABLE #TempAllotments (
        SubjectId VARCHAR(10),
        StudentId INT
    );

    DECLARE @StudentId INT, @GPA DECIMAL(3,1), @PreferenceOrder INT;
    DECLARE @SubjectId VARCHAR(10), @RemainingSeats INT;

    DECLARE StudentCursor CURSOR FOR
    SELECT StudentId, GPA
    FROM StudentDetails
    ORDER BY GPA DESC;

    OPEN StudentCursor;
    FETCH NEXT FROM StudentCursor INTO @StudentId, @GPA;

    WHILE @@FETCH_STATUS = 0
    BEGIN
        SET @PreferenceOrder = 1;
        
        WHILE @PreferenceOrder <= 5
        BEGIN
            SELECT @SubjectId = SubjectId
            FROM StudentPreference
            WHERE StudentId = @StudentId AND Preference = @PreferenceOrder;

            SELECT @RemainingSeats = RemainingSeats
            FROM SubjectDetails
            WHERE SubjectId = @SubjectId;

            IF @RemainingSeats > 0
            BEGIN
                INSERT INTO #TempAllotments (SubjectId, StudentId)
                VALUES (@SubjectId, @StudentId);

                UPDATE SubjectDetails
                SET RemainingSeats = RemainingSeats - 1
                WHERE SubjectId = @SubjectId;

                BREAK; 
            END

            SET @PreferenceOrder = @PreferenceOrder + 1;
        END

        FETCH NEXT FROM StudentCursor INTO @StudentId, @GPA;
    END

    CLOSE StudentCursor;
    DEALLOCATE StudentCursor;

    TRUNCATE TABLE Allotments;
    TRUNCATE TABLE UnallotedStudents;

    INSERT INTO Allotments (SubjectId, StudentId)
    SELECT SubjectId, StudentId
    FROM #TempAllotments;

    INSERT INTO UnallotedStudents (StudentId)
    SELECT StudentId
    FROM StudentDetails
    WHERE StudentId NOT IN (SELECT StudentId FROM #TempAllotments);

    DROP TABLE #TempAllotments;
END
