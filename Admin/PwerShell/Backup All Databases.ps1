Set-Location SQLServer:\SQL\TeacherA-PC\Default\Databases

foreach ($db in (get-ChildItem))
{
    $dbName = $db.Name
    $dt = Get-Date -FORMAT yyyyMMdd_hhmm
    $FileName = "C:\Backup\$($dbName)_$($dt).bak"
    Backup-SqlDatabase -Database $dbName -BackupFile $FileName -BackupAction Database -Initialize -CompressionOption On -Checksum 
}
