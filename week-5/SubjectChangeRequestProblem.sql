CREATE PROCEDURE UpdateSubjectAllotment
AS
BEGIN
    SET NOCOUNT ON;
    
    DECLARE @StudentId varchar(50)
    DECLARE @RequestedSubjectId varchar(50)
    DECLARE @CurrentSubjectId varchar(50)

    DECLARE subject_request_cursor CURSOR FOR
    SELECT StudentId, SubjectId FROM SubjectRequest

    OPEN subject_request_cursor
    FETCH NEXT FROM subject_request_cursor INTO @StudentId, @RequestedSubjectId

    WHILE @@FETCH_STATUS = 0
    BEGIN
        -- Check if student exists in SubjectAllotments
        IF EXISTS (SELECT 1 FROM SubjectAllotments WHERE StudentId = @StudentId)
        BEGIN
            -- Get current valid subject for the student
            SELECT @CurrentSubjectId = SubjectId
            FROM SubjectAllotments
            WHERE StudentId = @StudentId AND Is_Valid = 1

            -- If current subject is different from requested subject
            IF @CurrentSubjectId <> @RequestedSubjectId
            BEGIN
                -- Update current valid subject to invalid
                UPDATE SubjectAllotments
                SET Is_Valid = 0
                WHERE StudentId = @StudentId AND Is_Valid = 1

                -- Insert new valid record with requested subject
                INSERT INTO SubjectAllotments (StudentId, SubjectId, Is_Valid)
                VALUES (@StudentId, @RequestedSubjectId, 1)
            END
        END
        ELSE
        BEGIN
            -- Insert new valid record for new student
            INSERT INTO SubjectAllotments (StudentId, SubjectId, Is_Valid)
            VALUES (@StudentId, @RequestedSubjectId, 1)
        END

        FETCH NEXT FROM subject_request_cursor INTO @StudentId, @RequestedSubjectId
    END

    CLOSE subject_request_cursor
    DEALLOCATE subject_request_cursor

END