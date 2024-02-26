USE [LoyaltyDW]
GO
/****** Object:  StoredProcedure [dbo].[Date_Fill]    Script Date: 07/12/1402 10:42:45 ق.ظ ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


-- Example: Execute usp_FillDate @StartDate	= '01/01/2020' , @EndDate	= '01/01/2030'

ALTER       PROCEDURE [dbo].[Date_Fill]
    @StartDate DATETIME= Null, --Starting value of Date Range
    @EndDate DATETIME  = Null  --End Value of Date Range
AS
IF @StartDate IS NULL
    SET @StartDate = '01/01/2015';
IF @EndDate IS NULL
    SET @EndDate = '01/01/2035';

/*Delet old data*/
TRUNCATE TABLE dbo.Date;

--Temporary Variables To Hold the Values During Processing of Each Date of Year
DECLARE @DayOfWeekInMonth INT,
        @DayOfWeekInYear INT,
        @DayOfQuarter INT,
        @WeekOfMonth INT,
        @CurrentYear INT,
        @CurrentMonth INT,
        @CurrentQuarter INT;

/*Table Data type to store the day of week count for the month and year*/
DECLARE @DayOfWeek TABLE
(
    DOW INT,
    MonthCount INT,
    QuarterCount INT,
    YearCount INT
);

INSERT INTO @DayOfWeek
VALUES
(1, 0, 0, 0);
INSERT INTO @DayOfWeek
VALUES
(2, 0, 0, 0);
INSERT INTO @DayOfWeek
VALUES
(3, 0, 0, 0);
INSERT INTO @DayOfWeek
VALUES
(4, 0, 0, 0);
INSERT INTO @DayOfWeek
VALUES
(5, 0, 0, 0);
INSERT INTO @DayOfWeek
VALUES
(6, 0, 0, 0);
INSERT INTO @DayOfWeek
VALUES
(7, 0, 0, 0);

--Extract and assign various parts of Values from Current Date to Variable

DECLARE @CurrentDate AS DATETIME = @StartDate;
SET @CurrentMonth = DATEPART(MM, @CurrentDate);
SET @CurrentYear = DATEPART(YY, @CurrentDate);
SET @CurrentQuarter = DATEPART(QQ, @CurrentDate);

/********************************************************************************************/
--Proceed only if Start Date(Current date ) is less than End date you specified above

WHILE @CurrentDate < @EndDate
BEGIN

    /*Begin day of week logic*/

    /*Check for Change in Month of the Current date if Month changed then 
          Change variable value*/
    IF @CurrentMonth != DATEPART(MM, @CurrentDate)
    BEGIN
        UPDATE @DayOfWeek
        SET MonthCount = 0;
        SET @CurrentMonth = DATEPART(MM, @CurrentDate);
    END;

    /* Check for Change in Quarter of the Current date if Quarter changed then change 
         Variable value*/

    IF @CurrentQuarter != DATEPART(QQ, @CurrentDate)
    BEGIN
        UPDATE @DayOfWeek
        SET QuarterCount = 0;
        SET @CurrentQuarter = DATEPART(QQ, @CurrentDate);
    END;

    /* Check for Change in Year of the Current date if Year changed then change 
         Variable value*/


    IF @CurrentYear != DATEPART(YY, @CurrentDate)
    BEGIN
        UPDATE @DayOfWeek
        SET YearCount = 0;
        SET @CurrentYear = DATEPART(YY, @CurrentDate);
    END;

    -- Set values in table data type created above from variables 

    UPDATE @DayOfWeek
    SET MonthCount = MonthCount + 1,
        QuarterCount = QuarterCount + 1,
        YearCount = YearCount + 1
    WHERE DOW = DATEPART(DW, @CurrentDate);

    SELECT @DayOfWeekInMonth = MonthCount,
           @DayOfQuarter = QuarterCount,
           @DayOfWeekInYear = YearCount
    FROM @DayOfWeek
    WHERE DOW = DATEPART(DW, @CurrentDate);

    /*End day of week logic*/


    /* Populate Your Dimension Table with values*/

    INSERT INTO [dbo].[Date]
    (
        DateSurrogateId,
        [Date],
        [FullDate],
        [DayOfMonth],
        [DaySuffix],
        [DayName],
        [DayOfWeek],
        [DayOfWeekInMonth],
        [DayOfWeekInYear],
        [DayOfQuarter],
        [DayOfYear],
        [WeekOfMonth],
        [WeekOfQuarter],
        [WeekOfYear],
        [Month],
        [MonthName],
        [MonthOfQuarter],
        [Quarter],
        [QuarterName],
        [Year],
        [YearName],
        [MonthYear],
        [MMYYYY],
        [FirstDayOfMonth],
        [LastDayOfMonth],
        [FirstDayOfQuarter],
        [LastDayOfQuarter],
        [FirstDayOfYear],
        [LastDayOfYear],
        [IsHolidayUSA],
        [IsWeekday],
        [HolidayUSA],
        [IsHolidayUK],
        [HolidayUK]
    )
    SELECT CONVERT(CHAR(8), @CurrentDate, 112) AS DateKey,
           @CurrentDate AS Date,
           CONVERT(CHAR(10), @CurrentDate, 103) AS FullDate,
           DATEPART(DD, @CurrentDate) AS DayOfMonth,
           --Apply Suffix values like 1st, 2nd 3rd etc..
           CASE
               WHEN DATEPART(DD, @CurrentDate) IN ( 11, 12, 13 ) THEN
                   CAST(DATEPART(DD, @CurrentDate) AS VARCHAR) + 'th'
               WHEN RIGHT(DATEPART(DD, @CurrentDate), 1) = 1 THEN
                   CAST(DATEPART(DD, @CurrentDate) AS VARCHAR) + 'st'
               WHEN RIGHT(DATEPART(DD, @CurrentDate), 1) = 2 THEN
                   CAST(DATEPART(DD, @CurrentDate) AS VARCHAR) + 'nd'
               WHEN RIGHT(DATEPART(DD, @CurrentDate), 1) = 3 THEN
                   CAST(DATEPART(DD, @CurrentDate) AS VARCHAR) + 'rd'
               ELSE
                   CAST(DATEPART(DD, @CurrentDate) AS VARCHAR) + 'th'
           END AS DaySuffix,
           DATENAME(DW, @CurrentDate) AS DayName,

           -- check for day of week as Per US and change it as per UK format 
           CASE DATEPART(DW, @CurrentDate)
               WHEN 1 THEN
                   7
               WHEN 2 THEN
                   1
               WHEN 3 THEN
                   2
               WHEN 4 THEN
                   3
               WHEN 5 THEN
                   4
               WHEN 6 THEN
                   5
               WHEN 7 THEN
                   6
           END AS DayOfWeekUK,
           @DayOfWeekInMonth AS DayOfWeekInMonth,
           @DayOfWeekInYear AS DayOfWeekInYear,
           @DayOfQuarter AS DayOfQuarter,
           DATEPART(DY, @CurrentDate) AS DayOfYear,
           DATEPART(WW, @CurrentDate) + 1
           - DATEPART(
                         WW,
                         CONVERT(VARCHAR, DATEPART(MM, @CurrentDate)) + '/1/'
                         + CONVERT(VARCHAR, DATEPART(YY, @CurrentDate))
                     ) AS WeekOfMonth,
           (DATEDIFF(DD, DATEADD(QQ, DATEDIFF(QQ, 0, @CurrentDate), 0), @CurrentDate) / 7) + 1 AS WeekOfQuarter,
           DATEPART(WW, @CurrentDate) AS WeekOfYear,
           DATEPART(MM, @CurrentDate) AS Month,
           DATENAME(MM, @CurrentDate) AS MonthName,
           CASE
               WHEN DATEPART(MM, @CurrentDate) IN ( 1, 4, 7, 10 ) THEN
                   1
               WHEN DATEPART(MM, @CurrentDate) IN ( 2, 5, 8, 11 ) THEN
                   2
               WHEN DATEPART(MM, @CurrentDate) IN ( 3, 6, 9, 12 ) THEN
                   3
           END AS MonthOfQuarter,
           DATEPART(QQ, @CurrentDate) AS Quarter,
           CASE DATEPART(QQ, @CurrentDate)
               WHEN 1 THEN
                   'First'
               WHEN 2 THEN
                   'Second'
               WHEN 3 THEN
                   'Third'
               WHEN 4 THEN
                   'Fourth'
           END AS QuarterName,
           DATEPART(YEAR, @CurrentDate) AS Year,
           'CY ' + CONVERT(VARCHAR, DATEPART(YEAR, @CurrentDate)) AS YearName,
           LEFT(DATENAME(MM, @CurrentDate), 3) + '-' + CONVERT(VARCHAR, DATEPART(YY, @CurrentDate)) AS MonthYear,
           RIGHT('0' + CONVERT(VARCHAR, DATEPART(MM, @CurrentDate)), 2) + CONVERT(VARCHAR, DATEPART(YY, @CurrentDate)) AS MMYYYY,
           CONVERT(DATETIME, CONVERT(DATE, DATEADD(DD, - (DATEPART(DD, @CurrentDate) - 1), @CurrentDate))) AS FirstDayOfMonth,
           CONVERT(
                      DATETIME,
                      CONVERT(
                                 DATE,
                                 DATEADD(
                                            DD,
                                            - (DATEPART(DD, (DATEADD(MM, 1, @CurrentDate)))),
                                            DATEADD(MM, 1, @CurrentDate)
                                        )
                             )
                  ) AS LastDayOfMonth,
           DATEADD(QQ, DATEDIFF(QQ, 0, @CurrentDate), 0) AS FirstDayOfQuarter,
           DATEADD(QQ, DATEDIFF(QQ, -1, @CurrentDate), -1) AS LastDayOfQuarter,
           CONVERT(DATETIME, '01/01/' + CONVERT(VARCHAR, DATEPART(YY, @CurrentDate))) AS FirstDayOfYear,
           CONVERT(DATETIME, '12/31/' + CONVERT(VARCHAR, DATEPART(YY, @CurrentDate))) AS LastDayOfYear,
           NULL AS IsHolidayUSA,
           CASE DATEPART(DW, @CurrentDate)
               WHEN 1 THEN
                   0
               WHEN 2 THEN
                   1
               WHEN 3 THEN
                   1
               WHEN 4 THEN
                   1
               WHEN 5 THEN
                   1
               WHEN 6 THEN
                   1
               WHEN 7 THEN
                   0
           END AS IsWeekday,
           NULL AS HolidayUSA,
           NULL,
           NULL;

    SET @CurrentDate = DATEADD(DD, 1, @CurrentDate);
END;

/********************************************************************************************/

--Step 3.
--Update Values of Holiday as per UK Government Declaration for National Holiday.

/*Update HOLIDAY fields of UK as per Govt. Declaration of National Holiday*/

-- Good Friday  April 18 
UPDATE [dbo].[Date]
SET HolidayUK = 'Good Friday'
WHERE [Month] = 4
      AND [DayOfMonth] = 18;

-- Easter Monday  April 21 
UPDATE [dbo].[Date]
SET HolidayUK = 'Easter Monday'
WHERE [Month] = 4
      AND [DayOfMonth] = 21;

-- Early May Bank Holiday   May 5 
UPDATE [dbo].[Date]
SET HolidayUK = 'Early May Bank Holiday'
WHERE [Month] = 5
      AND [DayOfMonth] = 5;

-- Spring Bank Holiday  May 26 
UPDATE [dbo].[Date]
SET HolidayUK = 'Spring Bank Holiday'
WHERE [Month] = 5
      AND [DayOfMonth] = 26;

-- Summer Bank Holiday  August 25 
UPDATE [dbo].[Date]
SET HolidayUK = 'Summer Bank Holiday'
WHERE [Month] = 8
      AND [DayOfMonth] = 25;

-- Boxing Day  December 26  	
UPDATE [dbo].[Date]
SET HolidayUK = 'Boxing Day'
WHERE [Month] = 12
      AND [DayOfMonth] = 26;

--CHRISTMAS
UPDATE [dbo].[Date]
SET HolidayUK = 'Christmas Day'
WHERE [Month] = 12
      AND [DayOfMonth] = 25;

--New Years Day
UPDATE [dbo].[Date]
SET HolidayUK = 'New Year''s Day'
WHERE [Month] = 1
      AND [DayOfMonth] = 1;

--Update flag for UK Holidays 1= Holiday, 0=No Holiday

UPDATE [dbo].[Date]
SET IsHolidayUK = CASE
                      WHEN HolidayUK IS NULL THEN
                          0
                      WHEN HolidayUK IS NOT NULL THEN
                          1
                  END;


--Step 4.
--Update Values of Holiday as per USA Govt. Declaration for National Holiday.

/*Update HOLIDAY Field of USA In dimension*/

/*THANKSGIVING - Fourth THURSDAY in November*/
UPDATE [dbo].[Date]
SET HolidayUSA = 'Thanksgiving Day'
WHERE [Month] = 11
      AND [DayOfWeek] = 'Thursday'
      AND DayOfWeekInMonth = 4;

/*CHRISTMAS*/
UPDATE [dbo].[Date]
SET HolidayUSA = 'Christmas Day'
WHERE [Month] = 12
      AND [DayOfMonth] = 25;

/*4th of July*/
UPDATE [dbo].[Date]
SET HolidayUSA = 'Independance Day'
WHERE [Month] = 7
      AND [DayOfMonth] = 4;

/*New Years Day*/
UPDATE [dbo].[Date]
SET HolidayUSA = 'New Year''s Day'
WHERE [Month] = 1
      AND [DayOfMonth] = 1;

/*Memorial Day - Last Monday in May*/
UPDATE [dbo].[Date]
SET HolidayUSA = 'Memorial Day'
FROM [dbo].[Date]
WHERE DateSurrogateId IN
      (
          SELECT MAX(DateSurrogateId)
          FROM [dbo].[Date]
          WHERE [MonthName] = 'May'
                AND [DayOfWeek] = 'Monday'
          GROUP BY [Year],
                   [Month]
      );

/*Labor Day - First Monday in September*/
UPDATE [dbo].[Date]
SET HolidayUK = 'Labor Day'
FROM [dbo].[Date]
WHERE DateSurrogateId IN
      (
          SELECT MIN(DateSurrogateId)
          FROM [dbo].[Date]
          WHERE [MonthName] = 'September'
                AND [DayOfWeek] = 'Monday'
          GROUP BY [Year],
                   [Month]
      );

/*Valentine's Day*/
UPDATE [dbo].[Date]
SET HolidayUSA = 'Valentine''s Day'
WHERE [Month] = 2
      AND [DayOfMonth] = 14;

/*Saint Patrick's Day*/
UPDATE [dbo].[Date]
SET HolidayUSA = 'Saint Patrick''s Day'
WHERE [Month] = 3
      AND [DayOfMonth] = 17;

/*Martin Luthor King Day - Third Monday in January starting in 1983*/
UPDATE [dbo].[Date]
SET HolidayUSA = 'Martin Luthor King Jr Day'
WHERE [Month] = 1
      AND [DayOfWeek] = 'Monday'
      AND [Year] >= 1983
      AND DayOfWeekInMonth = 3;

/*President's Day - Third Monday in February*/
UPDATE [dbo].[Date]
SET HolidayUSA = 'President''s Day'
WHERE [Month] = 2
      AND [DayOfWeek] = 'Monday'
      AND DayOfWeekInMonth = 3;

/*Mother's Day - Second Sunday of May*/
UPDATE [dbo].[Date]
SET HolidayUSA = 'Mother''s Day'
WHERE [Month] = 5
      AND [DayOfWeek] = 'Sunday'
      AND DayOfWeekInMonth = 2;

/*Father's Day - Third Sunday of June*/
UPDATE [dbo].[Date]
SET HolidayUSA = 'Father''s Day'
WHERE [Month] = 6
      AND [DayOfWeek] = 'Sunday'
      AND DayOfWeekInMonth = 3;

/*Halloween 10/31*/
UPDATE [dbo].[Date]
SET HolidayUSA = 'Halloween'
WHERE [Month] = 10
      AND [DayOfMonth] = 31;

/*Election Day - The first Tuesday after the first Monday in November*/
BEGIN
    DECLARE @Holidays TABLE
    (
        ID INT IDENTITY(1, 1),
        DateID INT,
        Week TINYINT,
        YEAR CHAR(4),
        DAY CHAR(2)
    );

    INSERT INTO @Holidays
    (
        DateID,
        [YEAR],
        [DAY]
    )
    SELECT DateSurrogateId,
           [Year],
           [DayOfMonth]
    FROM [dbo].[Date]
    WHERE [Month] = 11
          AND [DayOfWeek] = 'Monday'
    ORDER BY Year,
             DayOfMonth;

    DECLARE @CNTR INT,
            @POS INT,
            @STARTYEAR INT,
            @ENDYEAR INT,
            @MINDAY INT;

    SELECT @CurrentYear = MIN([YEAR]),
           @STARTYEAR = MIN([YEAR]),
           @ENDYEAR = MAX([YEAR])
    FROM @Holidays;

    WHILE @CurrentYear <= @ENDYEAR
    BEGIN
        SELECT @CNTR = COUNT([YEAR])
        FROM @Holidays
        WHERE [YEAR] = @CurrentYear;

        SET @POS = 1;

        WHILE @POS <= @CNTR
        BEGIN
            SELECT @MINDAY = MIN(DAY)
            FROM @Holidays
            WHERE [YEAR] = @CurrentYear
                  AND [Week] IS NULL;

            UPDATE @Holidays
            SET [Week] = @POS
            WHERE [YEAR] = @CurrentYear
                  AND [DAY] = @MINDAY;

            SELECT @POS = @POS + 1;
        END;

        SELECT @CurrentYear = @CurrentYear + 1;
    END;

    UPDATE [dbo].[Date]
    SET HolidayUSA = 'Election Day'
    FROM [dbo].[Date] DT
        JOIN @Holidays HL
            ON (HL.DateID + 1) = DT.DateSurrogateId
    WHERE [Week] = 1;
END;
--set flag for USA holidays in Dimension
UPDATE [dbo].[Date]
SET IsHolidayUSA = CASE
                       WHEN HolidayUSA IS NULL THEN
                           0
                       WHEN HolidayUSA IS NOT NULL THEN
                           1
                   END,
    PersianDateValue = dbo.PersianDateByGregoryDate(Date.Date, 0),
    PersianDateSurrogateId = CAST(REPLACE(dbo.PersianDateByGregoryDate(Date.Date, 0), '/', '') AS INT);
/*****************************************************************************************/
UPDATE Date
SET PersianYear = CAST(SUBSTRING(Date.PersianDateValue, 1, 4) AS INT),
    PersianMonth = CAST(SUBSTRING(Date.PersianDateValue, 6, 2) AS INT),
    PersianDayOfMonth = CAST(SUBSTRING(Date.PersianDateValue, 9, 2) AS INT);

UPDATE Date
SET PersianSeason = (PersianMonth - 1) / 3 + 1,
    PersianMonthName = CASE Date.PersianMonth
                           WHEN 1 THEN
                               N'فروردین'
                           WHEN 2 THEN
                               N'اردیبهشت'
                           WHEN 3 THEN
                               N'خرداد'
                           WHEN 4 THEN
                               N'تیر'
                           WHEN 5 THEN
                               N'مرداد'
                           WHEN 6 THEN
                               N'شهریور'
                           WHEN 7 THEN
                               N'مهر'
                           WHEN 8 THEN
                               N'آبان'
                           WHEN 9 THEN
                               N'آذر'
                           WHEN 10 THEN
                               N'دی'
                           WHEN 11 THEN
                               N'بهمن'
                           WHEN 12 THEN
                               N'اسفند'
                       END;

UPDATE Date
SET PersianMonthYear = CAST(Date.PersianYear AS NVARCHAR(4)) + '-' + Date.PersianMonthName,
    Date.PersianSeasonName = CASE PersianSeason
                                    WHEN 1 THEN
                                        N'بهار'
                                    WHEN 2 THEN
                                        N'تابستان'
                                    WHEN 3 THEN
                                        N'پاییز'
                                    WHEN 4 THEN
                                        N'زمستان'
                                END,
    PersianDayOfWeek = CASE Date.DayName
                           WHEN 'Friday' THEN
                               7
                           WHEN 'Saturday' THEN
                               1
                           WHEN 'Sunday' THEN
                               2
                           WHEN 'Monday' THEN
                               3
                           WHEN 'Tuesday' THEN
                               4
                           WHEN 'Wednesday' THEN
                               5
                           WHEN 'Thursday' THEN
                               6
                       END,
    PersianDayOfWeekName = CASE Date.DayName
                               WHEN 'Friday' THEN
                                   N'جمعه'
                               WHEN 'Saturday' THEN
                                   N'شنبه'
                               WHEN 'Sunday' THEN
                                   N'یکشنبه'
                               WHEN 'Monday' THEN
                                   N'دوشنبه'
                               WHEN 'Tuesday' THEN
                                   N'سه شنبه'
                               WHEN 'Wednesday' THEN
                                   N'چهارشنبه'
                               WHEN 'Thursday' THEN
                                   N'پنج شنبه'
                           END,
    PersianMonthOfSeason = CASE Date.PersianMonth % 3
                               WHEN 0 THEN
                                   3
                               ELSE
                                   Date.PersianMonth % 3
                           END;


SELECT DD.DateValue,
       (
           SELECT TOP 1
                  ISNULL(COUNT(1), 0) + 1
           FROM Date
           WHERE PersianYear = DD.PersianYear
                 AND PersianDayOfWeek = 1
                 AND Date.DateValue < DD.DateValue
       ) AS PersianWeekOftheYear,
       (
           SELECT TOP 1
                  ISNULL(COUNT(1), 0) + 1
           FROM Date
           WHERE PersianYear = DD.PersianYear
                 AND PersianDayOfWeek = 1
       ) AS TotalWeekOftheYear,
       (
           SELECT TOP 1
                  ISNULL(COUNT(1), 0)
           FROM Date
           WHERE PersianYear = DD.PersianYear
                 AND Date.DateValue <= DD.DateValue
       ) AS DayOftheYear,
       (
           SELECT TOP 1
                  ISNULL(COUNT(1), 0)
           FROM Date
           WHERE PersianYear = DD.PersianYear
       ) AS TotalDayOftheYear
INTO #Temp1
FROM Date AS DD;

UPDATE DD
SET PersianWeekOfYear = T.PersianWeekOftheYear,
    PersianWeekRemainedFromYear = T.TotalWeekOftheYear - T.PersianWeekOftheYear,
    PersianDayOfYear = T.DayOftheYear,
    persianDayRemainedFromyear = T.TotalDayOftheYear - T.DayOftheYear
FROM Date AS DD
    INNER JOIN #Temp1 AS T
        ON T.DateValue = DD.DateValue;
DROP TABLE #Temp1;
--PersianDayOfYear INT NULL,
--PersianWeekOfYear INT NULL,

--PersianWeekRemainedFromYear INT NULL,
--persianDayRemainedFromyear INT NULL,
DECLARE @FirstYear INT,
        @LastYear INT;
SELECT @FirstYear = MIN(DD.Year),
       @LastYear = MAX(DD.Year)
FROM Date AS DD;

--DELETE Date WHERE Date.Year IN (@LastYear, @FirstYear)

--SELECT  * FROM Date AS DD  
