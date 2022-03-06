# Set thresholds (in gigabytes) for C: drive and for the remaining drives
$driveCthreshold=100
$threshold=400


# Replace settings below with your e-mails
$emailTo="info@fad.ir"

# Get SQL Server hostname
$hostname=Get-WMIObject Win32_ComputerSystem | Select-Object -ExpandProperty name

# Get all drives with free space less than a threshold. Exclude System Volumes
$Results = Get-WmiObject -Class Win32_Volume -Filter "SystemVolume='False' AND DriveType=3"|
  Where-Object {($_.FreeSpace/1GB –lt  $driveCthreshold –and $_.DriveLetter -eq "C:")`
 –or ($_.FreeSpace/1GB –lt  $threshold –and $_.DriveLetter -ne "C:" )}

ForEach ($Result In $Results)
{
    $drive = $Result.DriveLetter
    $space = [math]::truncate($Result.FreeSpace/1GB)
    $thresh = if($drive -eq 'C:'){$driveCthreshold} else {$threshold}
    
    invoke-sqlcmd -Query "EXEC msdb.dbo.sp_send_dbmail  
    @profile_name = 'Yahoo',  
    @recipients = 'info@fad.ir',  
    @body = 'Disk $($drive) on $($hostname) has less than $($thresh) GB of free space left: $($space) GB' ,
    @subject = 'Low Disk Space on Server $($hostname) ' ;  "
}