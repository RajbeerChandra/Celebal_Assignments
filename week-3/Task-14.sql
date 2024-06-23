WITH headcount_data AS (
    SELECT 
        sub_band,
        COUNT(*) AS headcount,
        COUNT(*) OVER () AS total_headcount
    FROM employees
    GROUP BY sub_band
)
SELECT 
    sub_band,
    headcount,
    (headcount * 100.0 / total_headcount) AS headcount_percentage
FROM headcount_data;