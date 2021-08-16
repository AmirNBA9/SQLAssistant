/*------------------------------------------------------
-- Author:	Ah.ghasemi								----
-- Date:	1397/06/05								----
-- Note:	Changsystemname							----
------------------------------------------------------*/


/*
Step 1: Use in customer DB
قراردادن نام سیستم برای دیتابیس مشتری
*/
--update commonsystemsetting
--set SystemName = N'Kargoshyan'
/*یافتن نام سیستم برروی دیتابیس مشتری*/
Select SystemName
from CommonSystemSetting



/*
Step 2: Use in Ticketing DB
قراردادن نام سیستم برای دیتابیس خودمان
*/.
--update PortalCustomersInfo
--set systemname = N'NO-NAME'
--where CustomerId = N'A64313C9-04EF-468D-A947-0B3BA8FF337B'

/*ابتدا کد مشتری را بیابید*/
select * from PortalCustomersInfo
where Name like N'%äæÂæÑÇä%