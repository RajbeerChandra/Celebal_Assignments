WITH RECURSIVE
  numbers(n) AS (
    SELECT 2
    UNION ALL
    SELECT n + 1 FROM numbers WHERE n < 1000
  ),
  primes(p) AS (
    SELECT n FROM numbers n
    WHERE NOT EXISTS (
      SELECT 1 FROM numbers d
      WHERE d.n < n.n AND n.n % d.n = 0
    )
  )
SELECT GROUP_CONCAT(p SEPARATOR '&')
FROM primes;