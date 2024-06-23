SELECT 
    BU,
    YEAR(date) AS year,
    MONTH(date) AS month,
    SUM(cost * weight) / SUM(weight) AS weighted_avg_cost
FROM employee_costs
GROUP BY BU, YEAR(date), MONTH(date)
ORDER BY BU, year, month;