SELECT f1.X, f1.Y
FROM Functions f1
JOIN Functions f2 ON f1.X = f2.Y AND f1.Y = f2.X
WHERE f1.X <= f1.Y
GROUP BY f1.X, f1.Y
HAVING COUNT(*) > 1 OR f1.X < f1.Y
ORDER BY f1.X;