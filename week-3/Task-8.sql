WITH ranked_occupations AS (
  SELECT 
    Name,
    Occupation,
    ROW_NUMBER() OVER (PARTITION BY Occupation ORDER BY Name) as rn
  FROM OCCUPATIONS
),
max_rows AS (
  SELECT MAX(rn) as max_rn
  FROM ranked_occupations
)
SELECT 
  MAX(CASE WHEN Occupation = 'Doctor' THEN Name END) AS Doctor,
  MAX(CASE WHEN Occupation = 'Professor' THEN Name END) AS Professor,
  MAX(CASE WHEN Occupation = 'Singer' THEN Name END) AS Singer,
  MAX(CASE WHEN Occupation = 'Actor' THEN Name END) AS Actor
FROM (
  SELECT *
  FROM ranked_occupations
  CROSS JOIN max_rows
  WHERE rn <= max_rn
) t
GROUP BY rn
ORDER BY rn;