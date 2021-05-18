SELECT name 
FROM msdb.dbo.sysjobs 
WHERE enabled = 0 ORDER BY name