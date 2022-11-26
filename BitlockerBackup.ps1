#Manual Run must be on the same network. Input hostname of the computer @ $computer
$computer = ""

Get-Service -Name WinRM -ComputerName $computer -ErrorAction Stop | Start-Service -ErrorAction Stop
Get-Service -Name RemoteRegistry -ComputerName $computer -ErrorAction Stop | Start-Service -ErrorAction Stop


Invoke-command -ComputerName $computer -ScriptBlock {

$BLV = Get-BitLockerVolume -MountPoint "C:" | select *
BackupToAAD-BitLockerKeyProtector -MountPoint "C:" -KeyProtectorId $BLV.KeyProtector[1].KeyProtectorId
}
