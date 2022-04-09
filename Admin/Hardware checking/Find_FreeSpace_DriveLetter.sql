/*Find drives free space*/

CREATE TABLE #Drives (DriveLetter nchar(1) , FreeSpace int)

INSERT INTO #Drives
   EXEC [sys].[xp_fixeddrives]

SELECT * FROM #Drives

DROP TABLE #Drives