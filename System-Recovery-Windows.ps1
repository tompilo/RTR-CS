# Check Volume Shadow Copy Service
Get-Service -Name VSS | Select DisplayName,Status,StartType | Out-String | ForEach-Object { $_.Trim() };

# If Stop, Enable using this
Enable-ComputerRestore -Drive "C:\";
Set-Service -Name VSS StartupType Automatic;

# Create Snapshot
(Get-WmiObject -List Win32_ShadowCopy).Create("C:\","ClientAccessible") | Select ShadowID | Format-List | Out-String | ForEach-Object { $_.trim() };

# Check Snapshot available
Get-WmiObject Win32_ShadowCopy | Select @{N='DeviceObject';E={$_.DeviceObject + "\"}},@{N='Snapshot Time';E={$_.ConvertToDateTime($_.InstallDate).ToString("MMM dd, hh:mm tt")}}

# Restore the Snapshot
$SnapshotDeviceID = (Get-WmiObject Win32_ShadowCopy | Select-Object -Last 1).DeviceObject + "\";
cmd \c mklink /d \Shadow "$SnapshotDeviceID";
robocopy \Shadow\Users\<username>\Desktop /mir /nfl /ndl /njh /nc /ns /np; 

