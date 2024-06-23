WITH ProjectGroups AS (
  SELECT 
    Task_ID,
    Start_Date,
    End_Date,
    DATE_DIFF(End_Date, LAG(End_Date) OVER (ORDER BY Start_Date), DAY) AS DateDiff,
    SUM(CASE WHEN DATE_DIFF(End_Date, LAG(End_Date) OVER (ORDER BY Start_Date), DAY) > 1 
             THEN 1 ELSE 0 END) OVER (ORDER BY Start_Date) AS ProjectGroup
  FROM Projects
),
ProjectDates AS (
  SELECT 
    ProjectGroup,
    MIN(Start_Date) AS ProjectStart,
    MAX(End_Date) AS ProjectEnd
  FROM ProjectGroups
  GROUP BY ProjectGroup
)
SELECT 
  ProjectStart,
  ProjectEnd
FROM ProjectDates
ORDER BY DATE_DIFF(ProjectEnd, ProjectStart, DAY) + 1, ProjectStart;