#Get-Service  *SQL* | Where-Object {$_.status -eq "Running"}
#Stop-Service -Name "SQLSERVERAGENT"
Start-Service -Name "SQLSERVERAGENT"