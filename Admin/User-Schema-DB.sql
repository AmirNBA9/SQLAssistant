--------------------------------------------------------------------
/*
Schema_name: نام شِما
Schema_id :Id مربوط به شِما. این شماره در هر Instance ,Unique می‌باشد.
Schema_owner: نام شِمای مالک ؟؟؟؟؟
*/
--------------------------------------------------------------------
select s.name as schema_name, 
    s.schema_id,
    u.name as schema_owner
from sys.schemas s
    inner join sys.sysusers u
        on u.uid = s.principal_id
where u.issqluser = 1
    and u.name not in ('sys', 'guest', 'INFORMATION_SCHEMA')
