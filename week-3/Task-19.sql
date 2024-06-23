SELECT 
    CEIL(
        AVG(salary) - 
        AVG(CAST(REPLACE(CAST(salary AS VARCHAR), '0', '') AS INTEGER))
    ) AS salary_difference
FROM EMPLOYEES;