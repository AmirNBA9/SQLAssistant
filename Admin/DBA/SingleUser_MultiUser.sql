/*
* When we need clear file for delete
*/
USE Master

ALTER DATABASE Test SET SINGLE_USER WITH ROLLBACK AFTER 10 SECONDS -- Drop connection after 10 second
GO

ALTER DATABASE Test SET MULTI_USER
GO



