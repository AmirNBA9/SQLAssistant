echo Windows Update Medic Service
sc stop WaasMedicSvc
REG ADD HKLM\SYSTEM\CurrentControlSet\Services\WaasMedicSvc /v Start /f /t REG_DWORD /d 4
echo.


echo Servizio Windows Update
sc stop wuauserv
REG ADD HKLM\SYSTEM\CurrentControlSet\Services\wuauserv /v Start /f /t REG_DWORD /d 4
echo.


echo Aggiorna il servizio Orchestrator
sc stop UsoSvc
REG ADD HKLM\SYSTEM\CurrentControlSet\Services\UsoSvc /v Start /f /t REG_DWORD /d 4
echo.