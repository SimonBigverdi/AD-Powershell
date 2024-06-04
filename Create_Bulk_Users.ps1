# Import Active Directory Module to utilize AD cmdlets
Import-Module ActiveDirectory

# Creates temporary password that the user will need to login
$securePassword = ConvertTo-SecureString "ExamplePassword" -AsPlainText -Force

# Prompts for file path of CSV file 
$filepath = Read-Host -Prompt "Enter path of CSV file"

# Variable and loop that references the CSV file with columns for various fields such as first name, last name, job title, email address, description, OU for each user
$users = Import-Csv $filepath
ForEach ($user in $users) {
    
    $fname = $user.'First Name'
    $lname = $user.'Last Name'
    $jobtitle = $user.'Job Title'
    $emailaddress = $user.'Email Address'
    $description = $user.Description
    $OUpath = $user.'Organizational Unit'

    # Creates AD accounts for each row in referenced CSV file. AD Attributes include First name, Last name, Display name, UPN, OU, Password, Job Title, Description, Email Address. 
    # Accounts will be enabled and the user will be prompted to change their password on the next login 
    New-ADuser -Name "$fname $lname" -GivenName $fname -Surname $lname -UserPrincipalName "$fname$lname@domain.com" -DisplayName "$fname $lname" -SamAccountName "$fname$lname" `
    -Path $OUpath -AccountPassword $securePassword -Title "$jobtitle" -ChangePasswordAtLogon $True -Description $description -Enabled $True -EmailAddress $emailaddress `

    # Output in terminal indicating account is created and OU path where the account is created
    Write-Output "Account created for $fname $lname in $OUpath"
}
