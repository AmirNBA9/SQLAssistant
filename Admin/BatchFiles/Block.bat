SET NEWLINE=^& echo.

FIND /C /I "crm.devolutions.net" %windir%\system32\drivers\etc\hosts
IF %ERRORLEVEL% NEQ 0 ECHO %NEWLINE%^	127.0.0.1	crm.devolutions.net>>%WINDIR%\system32\drivers\etc\hosts
