/*CMD Connnect for backup*/

:Connect 192.168.1.94 -Usa -Pa1234
:r C:\Users\OnlineClass\Backup.sql
:setvar DBName  "Northwind"
:setvar FileName "C:\Backup\nw.bak"