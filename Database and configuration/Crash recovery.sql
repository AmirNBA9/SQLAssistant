--Crash recovery
Alter database startup
set emergency

--Singel user
Alter database startup set single_user with rollback immediate

--multi user
Alter database Startup set multi_user

