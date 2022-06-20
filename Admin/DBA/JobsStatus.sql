USE msdb;

GO
/*Jobs_MinMaxAverageTime*/
SELECT a.name AS 'JobName',
       MAX(((b.run_duration / 10000 * 3600 + (b.run_duration / 100) % 100 * 60 + b.run_duration % 100 + 31) / 60)) AS "MaxDurationMinutes",
       MIN(((b.run_duration / 10000 * 3600 + (b.run_duration / 100) % 100 * 60 + b.run_duration % 100 + 31) / 60)) AS "MinDurationMinutes",
       AVG(((b.run_duration / 10000 * 3600 + (b.run_duration / 100) % 100 * 60 + b.run_duration % 100 + 31) / 60)) AS "AvgDurationMinutes"
FROM dbo.sysjobs AS a
    LEFT JOIN dbo.sysjobhistory AS b ON b.job_id = a.job_id AND b.step_id = 0
WHERE a.enabled = 1
GROUP BY a.name
ORDER BY a.name;

/*Jobs_MinMaxAverageTime with steps*/
WITH t
AS
    (SELECT a.job_id, b.step_name, b.step_id, ((b.run_duration / 10000 * 3600 + (b.run_duration / 100) % 100 * 60 + b.run_duration % 100 + 31) / 60) AS run_duration,
            CAST(DATEADD (MILLISECOND, ((b.run_duration / 10000 * 3600 + (b.run_duration / 100) % 100 * 60 + b.run_duration % 100)), '00:00:00') AS TIME(3)) AS run_duration_Format
       FROM dbo.sysjobs AS a
            LEFT JOIN dbo.sysjobhistory AS b ON b.job_id = a.job_id)
SELECT a.name AS 'JobName', a.description, t.step_name, --
       MAX (t.run_duration) AS "MaxDurationMinutes", --
       MIN (t.run_duration) AS "MinDurationMinutes", --
       AVG (t.run_duration) AS "AvgDurationMinutes", --
       MIN (t.run_duration_Format) AS MinRunDuration, --
	   MAX (t.run_duration_Format) AS MaxRunDuration

  FROM dbo.sysjobs AS a
       LEFT JOIN t ON t.job_id = a.job_id
                  AND t.step_id <> 0
 WHERE a.enabled = 1
 -- AND t.run_duration > 0 ==> Jobs less than 1 minutes is not important for check
 GROUP BY a.name, a.description, t.step_name
 ORDER BY a.name, "MinDurationMinutes" DESC;




/*FailedJobsReport*/
SELECT SJ.name, SJS.last_outcome_message, SJS.last_run_date, SJS.last_run_duration
  FROM msdb.dbo.sysjobs AS SJ
       LEFT JOIN msdb.dbo.sysjobservers AS SJS ON SJS.job_id = SJ.job_id
 WHERE SJS.last_run_outcome = 0;