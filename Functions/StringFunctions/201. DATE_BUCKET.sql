-- This function start working at 2022

declare @date datetime2 = '2020-04-15 21:22:11';

Select  DATE_BUCKET(MONTH, 1, @date)AS ONE_MONTH_AGO	, 
		DATE_BUCKET(WEEK, 1, @date)	AS ONE_Week_AGO	, 
		DATE_BUCKET(DAY, 1, @date)	AS ONE_Day_AGO	,
		DATE_BUCKET(HOUR, 1, @date)	AS ONE_HOUR_AGO 
Select	DATE_BUCKET(MONTH, 2, @date)AS TWO_MONTH_AGO	, 
		DATE_BUCKET(WEEK, 2, @date)	AS TWO_Week_AGO	, 
		DATE_BUCKET(DAY, 2, @date)	AS TWO_Day_AGO	,
		DATE_BUCKET(HOUR, 2, @date)	AS TWO_HOUR_AGO 

/*Buket with union*/
Select 'Year' AS 'PartOfDate',  DATE_BUCKET(YEAR, 1, @date)
Union All
Select 'Month' AS 'PartOfDate',  DATE_BUCKET(MONTH, 1, @date)
Union All
Select 'Week' AS 'PartOfDate',  DATE_BUCKET(WEEK, 1, @date)
Union All
Select 'Day' AS 'PartOfDate',  DATE_BUCKET(DAY, 1, @date)
Union All
Select 'Hour' AS 'PartOfDate',  DATE_BUCKET(HOUR, 1, @date)
Union All
Select 'Minutes' AS 'PartOfDate',  DATE_BUCKET(MINUTE, 1, @date)
Union All
Select 'Seconds' AS 'PartOfDate',  DATE_BUCKET(SECOND, 1, @date);


/*Working until year 1900*/
DECLARE @days int = 1100,
        @datetime datetime2 = '2000-01-01 01:01:01.1110000'; /* 1900 is end of come back to year */;
SELECT Date_Bucket(YEAR, @days, @datetime);