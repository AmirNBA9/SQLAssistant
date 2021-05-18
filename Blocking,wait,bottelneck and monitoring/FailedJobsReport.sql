SELECT name 
FROM msdb.dbo.sysjobs A, msdb.dbo.sysjobservers B 
WHERE A.job_id = B.job_id AND B.last_run_outcome = 0