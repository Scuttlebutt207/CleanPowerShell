$6432Node = get-childitem HKLM:\Software\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall\ | `
foreach-object {Get-ItemProperty $_.PsPath} | Where-Object { $_.displayname -like "dell command*"} | Select-Object uninstallstring

$software = get-childitem HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\ | `
foreach-object {Get-ItemProperty $_.PsPath} | Where-Object { $_.displayname -like "dell command*"} | Select-Object uninstallstring

$6432Command = $6432Node.UninstallString

$softwareCommand = $software.UninstallString

$checkproc = Get-Process -Name dellcommandupdate.exe -ea SilentlyContinue

If ($null -eq $6432Command -and $null -eq $softwareCommand){

    Write-Host "Dell Command not found"

}Elseif ($null -ne $6432Command){
    if ($checkproc)
    {
    taskkill /im dellcommandupdate.exe
    }

Start-Process -Wait cmd.exe -nonewwindow -ArgumentList "/c $6432command /QN"
}Elseif ($null -ne $softwareCommand){
    if ($checkproc)
    {
    taskkill /im dellcommandupdate.exe
    }

Start-Process -Wait cmd.exe -nonewwindow -ArgumentList "/c $softwareCommand /QN"
}