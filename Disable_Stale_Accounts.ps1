# Import the Active Directory module
Import-Module ActiveDirectory

# Get the current date
$currentDate = Get-Date

# Calculate the date 90 days ago
$thresholdDate = $currentDate.AddDays(-90)

# Get all user accounts that haven't logged in since the threshold date
$inactiveUsers = Get-ADUser -Filter { LastLogonTimestamp -lt $thresholdDate -and Enabled -eq $true } -Properties LastLogonTimestamp

# Disable the inactive user accounts and output the results
foreach ($user in $inactiveUsers) {
    Disable-ADAccount -Identity $user
    Write-Host "User $($user.SamAccountName) has been disabled due to inactivity."
}