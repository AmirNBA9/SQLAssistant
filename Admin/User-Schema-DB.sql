--------------------------------------------------------------------
/*
Schema_name: نام شِما
Schema_id :Id مربوط به شِما. این شماره در هر Instance ,Unique می‌باشد.
Schema_owner: نام شِمای مالک ؟؟؟؟؟
*/
--------------------------------------------------------------------
SELECT s.name AS schema_name,
       s.schema_id,
       u.name AS schema_owner
FROM sys.schemas s
    INNER JOIN sys.sysusers u
        ON u.uid = s.principal_id
WHERE u.issqluser = 1
      AND u.name NOT IN ( 'sys', 'guest', 'INFORMATION_SCHEMA' );
