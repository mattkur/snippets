param([string]$ComputerName = $env:COMPUTERNAME)

$DiskStates = @{
    [uint32]0 = "0 - Unknown";
    [uint32]1 = "1 - Configuring";
    [uint32]2 = "2 - Initialized";
    [uint32]3 = "3 - InitializedAndBound";
    [uint32]4 = "4 - Draining";
    [uint32]5 = "5 - Disabling";
    [uint32]6 = "6 - Disabled";
    [uint32]7 = "7 - Missing";
    [uint32]8 = "8 - Orphaned - Waiting";
    [uint32]9 = "9 - Orphaned - Recovering";
    [uint32]10 = "10 - Failed - Media Error";
    [uint32]2000 = "2000 - Ineligible - Has data partition";
    [uint32]2001 = "2001 - Ineligible - Not GPT formatted";
    [uint32]2002 = "2002 - Ineligible - Not large enough";
    [uint32]3000 = "3000 - Skipped Binding - No flash devices";
    [uint32]9000 = "9000 - Internal error"
};

function Get-DiskStateDescription([uint32]$DiskState)
{
    if ($DiskStates.ContainsKey($DiskState))
    {
        return $DiskStates[$DiskState]
    }
    else
    {
        return "*** UNKNOWN STATE ***";
    }
}

$table = @{Expression={$_.__SERVER};Label="Server"}, `
@{Expression={$_.DeviceNumber};Label="DeviceNumber"}, `
@{Expression={$_.Identifier};Label="DiskGuid"}, `
@{Expression={$_.IsFlash};Label="IsFlash"}, `
@{Expression={$(Get-DiskStateDescription $_.State)};Label="State"}, `
@{Expression={([wmi]"").ConvertToDateTime($_.LastStateChangeTime)};Label="LastStateChangeTime"}, `
@{Expression={$_.ReadMediaErrorCount};Label="Media Error Count: Read"}, `
@{Expression={$_.ReadTotalErrorCount};Label="Total Error Count: Read"}, `
@{Expression={$_.WriteMediaErrorCount};Label="Media Error Count: Write"}, `
@{Expression={$_.WriteTotalErrorCount};Label="Total Error Count: Write"}

$disks = @(gwmi -namespace root/microsoft/windows/storage MSFT_SBLTargetDisk -ComputerName $ComputerName | sort State,DeviceNumber)
$disks | ft -Auto $table
