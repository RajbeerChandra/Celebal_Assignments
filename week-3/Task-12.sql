SELECT 
    job_family,
    SUM(CASE WHEN location = 'India' THEN cost ELSE 0 END) / SUM(cost) * 100 AS India_percentage,
    SUM(CASE WHEN location != 'India' THEN cost ELSE 0 END) / SUM(cost) * 100 AS International_percentage
FROM employee_costs
GROUP BY job_family;