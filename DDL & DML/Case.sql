-- Simple CASE statement
SELECT  CASE DATEPART (WEEKDAY, GETDATE ())
            WHEN 1
                THEN 'Sunday'
            WHEN 2
                THEN 'Monday'
            WHEN 3
                THEN 'Tuesday'
            WHEN 4
                THEN 'Wednesday'
            WHEN 5
                THEN 'Thursday'
            WHEN 6
                THEN 'Friday'
            WHEN 7
                THEN 'Saturday'
        END;

-- Searched CASE statement
DECLARE @FirstName VARCHAR(30) = 'John';
DECLARE @LastName VARCHAR(30) = 'Smith';
SELECT  CASE
            WHEN LEFT(@FirstName, 1) IN ( 'a', 'e', 'i', 'o', 'u' )
                THEN 'First name starts with a vowel'
            WHEN LEFT(@LastName, 1) IN ( 'a', 'e', 'i', 'o', 'u' )
                THEN 'Last name starts with a vowel' ELSE 'Neither name starts with a vowel'
        END;