/*Configuring SQL Server Database Mail*/

-- Enable DBMail
USE master 
GO 
sp_configure 'show advanced options',1 
GO 
RECONFIGURE WITH OVERRIDE 
GO 
sp_configure 'Database Mail XPs', 1 
GO 
RECONFIGURE  
GO  

-- User parameters
Declare @email_address Nvarchar(100) = '[E-Mail]'
Declare @password Nvarchar(100) = '[Password]'
Declare @profile_name Nvarchar(100) = 'default'
Declare @account_name Nvarchar(100) = 'SQLAlerts'
Declare @mailserver_name Nvarchar(100) = 'smtp.gmail.com' --smtp.live.com	 --smtp.office365.com	
-- Create a new account
EXECUTE msdb.dbo.sysmail_add_account_sp 
@account_name = @account_name, 
@description = 'Account for Automated DBA Notifications', 
@email_address = @email_address, 
@replyto_address = @email_address, 
@display_name = 'SQL Agent', 
@mailserver_name = @mailserver_name, 
@port = 587, -- Open port on firewall, no deffrent between smtp server all off them port is 587
@enable_ssl = 1, 
@username = @email_address, 
@password = @password 


-- Create a default profile
EXECUTE msdb.dbo.sysmail_add_profile_sp 
@profile_name = @profile_name, 
@description = 'Profile for sending Automated DBA Notifications' 


-- Add the Database Mail account to a Database Mail profile
EXECUTE msdb.dbo.sysmail_add_principalprofile_sp 
@profile_name = @profile_name, 
@principal_name = 'public', 
@is_default = 1 ; 

-- Add account to profile
EXECUTE msdb.dbo.sysmail_add_profileaccount_sp   
@profile_name = @profile_name,   
@account_name = @account_name,   
@sequence_number = 1; 

/*
Note:
In order to fix the issue with Gmail, you need to enable the option to "Allow less secure apps". This is a setting in your Gmail account that needs to be enabled.
*/
-- Send test email
EXECUTE msdb.dbo.sp_send_dbmail 
@profile_name = @profile_name, 
@recipients = @email_address, 
@Subject = 'Testing DBMail', 
@Body = 'This message is a test for DBMail' 
GO

-- Find successfully sent email
SELECT * From msdb.dbo.sysmail_sentitems

-- Find unsent email
SELECT * From msdb.dbo.sysmail_unsentitems

-- Find failed email attempts
SELECT * From msdb.dbo.sysmail_faileditems