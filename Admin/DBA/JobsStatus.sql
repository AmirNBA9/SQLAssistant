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
SELECT a.name AS 'JobName', a.description, b.step_name,--
	   FORMAT(MAX (((b.run_duration / 10000 * 3600 + (b.run_duration / 100) % 100 * 60 + b.run_duration % 100 + 31) / 60)),'##,###') AS "MaxDurationMinutes",
       FORMAT(MIN (((b.run_duration / 10000 * 3600 + (b.run_duration / 100) % 100 * 60 + b.run_duration % 100 + 31) / 60)),'##,###') AS "MinDurationMinutes",
       FORMAT(AVG (((b.run_duration / 10000 * 3600 + (b.run_duration / 100) % 100 * 60 + b.run_duration % 100 + 31) / 60)),'##,###') AS "AvgDurationMinutes"
  FROM dbo.sysjobs AS a
       LEFT JOIN dbo.sysjobhistory AS b ON b.job_id = a.job_id
                                       AND b.step_id <> 0
 WHERE a.enabled = 1
 GROUP BY a.name, a.description, b.step_name
 ORDER BY a.name asc, step_name asc;


/*FailedJobsReport*/
SELECT SJ.name, SJS.last_outcome_message, SJS.last_run_date, SJS.last_run_duration
  FROM msdb.dbo.sysjobs AS SJ
       LEFT JOIN msdb.dbo.sysjobservers AS SJS ON SJS.job_id = SJ.job_id
 WHERE SJS.last_run_outcome = 0;