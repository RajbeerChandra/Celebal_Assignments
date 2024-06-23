WITH daily_submissions AS (
    SELECT 
        submission_date,
        hacker_id,
        COUNT(*) as submission_count
    FROM Submissions
    GROUP BY submission_date, hacker_id
),
cumulative_hackers AS (
    SELECT 
        s1.submission_date,
        COUNT(DISTINCT s1.hacker_id) as unique_hackers
    FROM Submissions s1
    WHERE s1.hacker_id IN (
        SELECT DISTINCT s2.hacker_id
        FROM Submissions s2
        WHERE s2.submission_date <= s1.submission_date
        GROUP BY s2.hacker_id
        HAVING COUNT(DISTINCT s2.submission_date) = DATEDIFF(DAY, '2016-03-01', s1.submission_date) + 1
    )
    GROUP BY s1.submission_date
),
max_submissions AS (
    SELECT 
        submission_date,
        hacker_id,
        submission_count,
        ROW_NUMBER() OVER (PARTITION BY submission_date ORDER BY submission_count DESC, hacker_id) as rn
    FROM daily_submissions
)
SELECT 
    ch.submission_date,
    ch.unique_hackers,
    ms.hacker_id,
    h.name
FROM cumulative_hackers ch
JOIN max_submissions ms ON ch.submission_date = ms.submission_date AND ms.rn = 1
JOIN Hackers h ON ms.hacker_id = h.hacker_id
ORDER BY ch.submission_date;