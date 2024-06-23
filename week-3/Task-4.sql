SELECT 
    con.contest_id,
    con.hacker_id,
    con.name,
    SUM(sg.total_submissions),
    SUM(sg.total_accepted_submissions),
    SUM(vg.total_views),
    SUM(vg.total_unique_views)
FROM Contests con
JOIN Colleges col ON con.contest_id = col.contest_id
JOIN Challenges cha ON col.college_id = cha.college_id
LEFT JOIN (
    SELECT challenge_id,
        SUM(total_submissions) as total_submissions,
        SUM(total_accepted_submissions) as total_accepted_submissions
    FROM Submission_Stats
    GROUP BY challenge_id
) sg ON cha.challenge_id = sg.challenge_id
LEFT JOIN (
    SELECT challenge_id,
        SUM(total_views) as total_views,
        SUM(total_unique_views) as total_unique_views
    FROM View_Stats
    GROUP BY challenge_id
) vg ON cha.challenge_id = vg.challenge_id
GROUP BY con.contest_id, con.hacker_id, con.name
HAVING 
    SUM(sg.total_submissions) != 0 OR
    SUM(sg.total_accepted_submissions) != 0 OR
    SUM(vg.total_views) != 0 OR
    SUM(vg.total_unique_views) != 0
ORDER BY con.contest_id;