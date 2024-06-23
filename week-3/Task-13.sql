SELECT 
    BU,
    YEAR(date) AS year,
    MONTH(date) AS month,
    SUM(cost) / SUM(revenue) AS cost_revenue_ratio
FROM bu_financials
GROUP BY BU, YEAR(date), MONTH(date)
ORDER BY BU, year, month;