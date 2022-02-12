@ECHO OFF
:: **** Firewall Rules for Database Machines

netsh advfirewall firewall add rule name="_Redgate Activation" dir=out action=block protocol=TCP remoteip=162.13.16.143,94.236.39.224

pause