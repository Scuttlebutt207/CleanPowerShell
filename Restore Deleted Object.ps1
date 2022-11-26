#Lists all deleted objects sitting in AD.
Get-ADObject -ldapFilter: "(msDS-LastKnownRDN=*)" -IncludeDeletedObjects | Format-Table

#This will restore the object you want. Copy the ObjectGUID from the previous command in-
#between '' then uncomment out the line.
#Get-ADObject -Filter {ObjectGUID -eq ''} -IncludeDeletedObjects | Restore-ADObjects