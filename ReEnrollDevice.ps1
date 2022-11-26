$Computer = "<<Computer>>"
& sc.exe \\$Computer start winrm
start-sleep -Seconds 10
try {

    Invoke-Command -ComputerName $Computer -ScriptBlock {
    $query = get-childitem HKLM:\SOFTWARE\Microsoft\Enrollments\ | `
    foreach-object {Get-ItemProperty $_.PsPath} | Where-Object {$_.DiscoveryServiceFullURL -like "*enrollment.manage.microsoft.com*"}

    if ($null -ne $query) {
        $ID = $query.PSChildName.ToString()  
        Try{
        Get-Item -Path "HKLM:\SOFTWARE\Microsoft\Enrollments\$ID" | remove-item -recurse
        Get-Item -Path "HKLM:\SOFTWARE\Microsoft\Enrollments\Status\$ID" | remove-item -recurse
        Get-Item -Path "HKLM:\SOFTWARE\Microsoft\EnterpriseResourceManager\Tracked\$ID" | remove-item -recurse
        Get-Item -Path "HKLM:\SOFTWARE\Microsoft\PolicyManager\AdmxInstalled\$ID" | remove-item -recurse
        Get-Item -Path "HKLM:\SOFTWARE\Microsoft\PolicyManager\Providers\$ID" | remove-item -recurse
        Get-Item -Path "HKLM:\SOFTWARE\Microsoft\Provisioning\OMADM\Accounts\$ID" | remove-item -recurse
        Get-Item -Path "HKLM:\SOFTWARE\Microsoft\Provisioning\OMADM\Logger\$ID" | remove-item -recurse
        Get-Item -Path "HKLM:\SOFTWARE\Microsoft\Provisioning\OMADM\Sessions\$ID" | remove-item -recurse

#remove Scheduled Tasks

        Get-Item "C:\Windows\System32\Tasks\Microsoft\Windows\EnterpriseMgmt\$ID" | remove-item -Recurse
            
        Get-Item "HKLM:\Software\Microsoft\Windows NT\CurrentVersion\Schedule\Taskcache\Tree\Microsoft\Windows\EnterpriseMgmt\$ID" | remove-item -Recurse -ErrorAction SilentlyContinue


#Delete Certificates

        get-childitem "Cert:\localmachine\my" | where Issuer -like "*MDM*" | Remove-Item
        gpupdate /force
        }Catch{
            Write-Output $Error
        }        
    }Else{
        Write-Output "No MDM enrollment found on local device. Please check the computer name and try again"
    }
}
}Catch{
    Write-Output $Error
    }
& sc.exe \\$Computer stop winrm
