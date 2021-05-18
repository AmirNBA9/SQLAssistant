CREATE TABLE #Errors (vchMessage varchar(255), ID int)
	CREATE INDEX idx_msg ON #Errors(ID, vchMessage)

INSERT #Errors EXEC xp_readerrorlog
SELECT vchMessage 
FROM #Errors 
WHERE vchMessage NOT LIKE '%Log backed up%' AND
	vchMessage NOT LIKE '%.TRN%' AND vchMessage NOT LIKE '%Database backed up%' AND
	vchMessage NOT LIKE '%.BAK%' AND vchMessage NOT LIKE '%Run the RECONFIGURE%' AND
	vchMessage NOT LIKE '%Copyright (c)%' ORDER BY ID DROP TABLE #Errors