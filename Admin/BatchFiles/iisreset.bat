@ECHO OFF

SET server-name=%1
SET curdir=%~dp0

:: get SPA 
IF "%server-name%"=="" (
	SET /P server-name="ServerName: "
)

IF "%server-name%"=="" (
	@ECHO server address is required
	pause
	Exit /B -1
)

cmd /k "winrs -r:%server-name% iisreset"