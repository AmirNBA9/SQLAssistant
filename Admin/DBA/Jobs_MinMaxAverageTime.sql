USE msdb;

GO

SELECT a.name AS 'JobName',
       MAX(((b.run_duration / 10000 * 3600 + (b.run_duration / 100) % 100 * 60 + b.run_duration % 100 + 31) / 60)) AS "MaxDurationMinutes",
       MIN(((b.run_duration / 10000 * 3600 + (b.run_duration / 100) % 100 * 60 + b.run_duration % 100 + 31) / 60)) AS "MinDurationMinutes",
       AVG(((b.run_duration / 10000 * 3600 + (b.run_duration / 100) % 100 * 60 + b.run_duration % 100 + 31) / 60)) AS "AvgDurationMinutes"
FROM dbo.sysjobs AS a
    LEFT JOIN dbo.sysjobhistory AS b ON b.job_id = a.job_id AND b.step_id = 0
WHERE a.enabled = 1
GROUP BY a.name
ORDER BY a.name;

