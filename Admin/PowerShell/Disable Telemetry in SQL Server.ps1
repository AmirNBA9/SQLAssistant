Get-Service | 
    Where-Object { $_.Name -like '*telemetry*' -or $_.DisplayName -like '*CEIP*' } | 
    ForEach-Object { 
        $servicename = $_.Name; 
        $displayname = $_.DisplayName; 
        Set-Service -Name $servicename  -StartupType Disabled 
        $serviceinfo = Get-Service -Name $servicename 
        $startup = $serviceinfo.StartType
        Write-Host "$servicename : $startup : $displayname";  
    }

Set-Location "HKLM:\"
$sqlentries = @( "\Software\Microsoft\Microsoft SQL Server\", "\Software\Wow6432Node\Microsoft\Microsoft SQL Server\" ) 
Get-ChildItem -Path $sqlentries -Recurse |
    ForEach-Object {
        $keypath = $_.Name
        (Get-ItemProperty -Path $keypath).PSObject.Properties |
             Where-Object { $_.Name -eq "CustomerFeedback" -or $_.Name -eq "EnableErrorReporting" } |
             ForEach-Object {
                $itemporpertyname = $_.Name
                $olditemporpertyvalue = Get-ItemPropertyValue -Path $keypath -Name $itemporpertyname
                Set-ItemProperty  -Path $keypath -Name $itemporpertyname -Value 0
                $newitemporpertyvalue = Get-ItemPropertyValue -Path $keypath -Name $itemporpertyname
                Write-Host "$keypath.$itemporpertyname = $olditemporpertyvalue --> $newitemporpertyvalue" 
             }
    }