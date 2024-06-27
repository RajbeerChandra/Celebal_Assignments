CREATE PROCEDURE AllocateSubjects
AS
BEGIN
    SET NOCOUNT ON;

    -- Create a temporary table to store allocations
    CREATE TABLE #TempAllotments (
        SubjectId VARCHAR(10),
        StudentId INT
    );

    -- Declare variables
    DECLARE @StudentId INT, @GPA DECIMAL(3,1), @PreferenceOrder INT;
    DECLARE @SubjectId VARCHAR(10), @RemainingSeats INT;

    -- Cursor to iterate through students ordered by GPA descending
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
            -- Get the subject for the current preference
            SELECT @SubjectId = SubjectId
            FROM StudentPreference
            WHERE StudentId = @StudentId AND Preference = @PreferenceOrder;

            -- Check if seats are available
            SELECT @RemainingSeats = RemainingSeats
            FROM SubjectDetails
            WHERE SubjectId = @SubjectId;

            IF @RemainingSeats > 0
            BEGIN
                -- Allocate the subject
                INSERT INTO #TempAllotments (SubjectId, StudentId)
                VALUES (@SubjectId, @StudentId);

                -- Update remaining seats
                UPDATE SubjectDetails
                SET RemainingSeats = RemainingSeats - 1
                WHERE SubjectId = @SubjectId;

                BREAK; -- Exit preference loop
            END

            SET @PreferenceOrder = @PreferenceOrder + 1;
        END

        FETCH NEXT FROM StudentCursor INTO @StudentId, @GPA;
    END

    CLOSE StudentCursor;
    DEALLOCATE StudentCursor;

    -- Clear existing allocations and unallotted students
    TRUNCATE TABLE Allotments;
    TRUNCATE TABLE UnallotedStudents;

    -- Insert successful allocations into Allotments table
    INSERT INTO Allotments (SubjectId, StudentId)
    SELECT SubjectId, StudentId
    FROM #TempAllotments;

    -- Insert unallocated students into UnallotedStudents table
    INSERT INTO UnallotedStudents (StudentId)
    SELECT StudentId
    FROM StudentDetails
    WHERE StudentId NOT IN (SELECT StudentId FROM #TempAllotments);

    -- Clean up
    DROP TABLE #TempAllotments;
END