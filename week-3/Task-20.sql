MERGE INTO target_table t
USING source_table s
ON (t.id = s.id)  -- Assume 'id' is a unique identifier
WHEN NOT MATCHED THEN
    INSERT (column1, column2, column3, ...)
    VALUES (s.column1, s.column2, s.column3, ...);