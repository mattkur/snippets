$disks = Get-Disk |? Number -ne $null |? IsBoot -ne $true |? IsSystem -ne $true

$disks | Set-Disk -IsOffline $false
$disks | Set-Disk -IsReadOnly $false
$disks | Clear-Disk -Confirm:$false
$disks | Set-Disk -IsOffline $true
$disks | Set-Disk -IsReadOnly $true