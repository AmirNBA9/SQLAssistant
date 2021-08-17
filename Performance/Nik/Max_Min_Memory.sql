
--قابلیت استفاده از تنظیمات پیشرفته
SP_CONFIGURE 'show advanced options',1
GO
RECONFIGURE WITH OVERRIDE
GO
--تنظیم حداقل و حداکثر حافظه
SP_CONFIGURE N'min server memory (MB)', N'xxxx'
GO
SP_CONFIGURE N'max server memory (MB)', N'xxxx'
GO
RECONFIGURE WITH OVERRIDE
GO
