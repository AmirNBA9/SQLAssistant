Set-Location SQLServer:\SQL\DESKTOP-H77K3E7\Default\Databases

foreach ($db in (get-ChildItem))
{
    $dbName = $db.Name
    $dt = Get-Date -FORMAT yyyyMMdd_hhmm
    $FileName = "C:\Backup\$($dbName)_$($dt).bak"
    Backup-SqlDatabase -Database $dbName -BackupFile $FileName -BackupAction Database -Initialize -CompressionOption On -Checksum 
}
