# This script will list all group memberships for users in an OU specified in the $ou variable and export the results to a CSV file specified in the $csvPath variable.

# Import Active Directory module
Import-Module ActiveDirectory

# Organizational Unit (OU) that will be used
$ou = "OU=ExampleOU,DC=domain,DC=com"

# Get all users in the specified OU
$users = Get-ADUser -Filter * -SearchBase $ou -Property MemberOf

# Create an array to hold the results
$results = @()

# Iterate through each user and retrieve their group memberships
foreach ($user in $users) {
   $username = $user.SamAccountName
   $groups = $user.MemberOf | ForEach-Object {
       ($_ -split ',')[0] -replace 'CN=', ''
   }

   # Create a custom object to hold the user and group data
   $userObject = [PSCustomObject]@{
       UserName = $username
       Groups = $groups -join ', '
   }

   # Add the custom object to the results array
   $results += $userObject
}

# Define the path where the CSV file will be saved
$csvPath = "C:\Path\To\ExportedGroupsinOU.csv"

# Export the results to a CSV file
$results | Export-Csv -Path $csvPath -NoTypeInformation

Write-Output "Export completed. Check the file at $csvPath"
