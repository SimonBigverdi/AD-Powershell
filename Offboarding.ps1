# Import Active Directory module to utilize AD cmdlets
Import-Module ActiveDirectory

# Prompt for the username
$username = Read-Host "Enter the username of the account to manage:"

# Check if the user exists
$user = Get-ADUser -Filter { SamAccountName -eq $username }

if ($user) {
    # Disable the user account
    Disable-ADAccount -Identity $username

    # Hide from address list
    Set-ADUser -Identity $username -Replace @{msExchHideFromAddressLists=$true}

    # List groups the user belongs to
    Write-Host "Groups $username belongs to:"
    $userGroups = Get-ADPrincipalGroupMembership -Identity $username | Select-Object -ExpandProperty Name
    $userGroups

    # Remove the user from all groups
    foreach ($group in $userGroups) {
        Remove-ADGroupMember -Identity $group -Members $username -Confirm:$false
        Write-Host "User removed from group: $group"
    }

    # Move user to a different OU
    $targetOU = "OU=DisabledUsers,DC=domain,DC=com" # Update with your target OU
    Move-ADObject -Identity $user -TargetPath $targetOU

    # Output information to a text file
    $outputFile = "User_Management_Report.txt"
    $reportContent = @"
User Management Report for $username
--------------------------------------
User account: $username
Account status: Disabled
Hidden from address lists: Yes
Groups removed:
$userGroups
Moved to OU: $targetOU
"@

    $reportContent | Out-File -FilePath $outputFile -Append
    Write-Host "User account $username disabled, hidden from address lists, removed from all groups, and moved to $targetOU. Report saved to $outputFile"
} else {
    Write-Host "User $username not found."
}