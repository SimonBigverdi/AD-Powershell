# This script will assign a static IP to a server, will install the ADDS role, and will promote the server to a Domain Controller

# Assign a static IP address to the server
$IPAddress = "192.168.50.50"
$SubnetMask = "255.255.255.0"
$Gateway = "192.168.50.1"
$DNS = "192.168.50.50"
$InterfaceIndex = (Get-NetAdapter).InterfaceIndex
New-NetIPAddress -InterfaceIndex $InterfaceIndex -IPAddress $IPAddress -PrefixLength 24 -DefaultGateway $Gateway
Set-DnsClientServerAddress -InterfaceIndex $InterfaceIndex -ServerAddresses $DNS

# Install ADDS Role
Install-WindowsFeature -Name AD-Domain-Services -IncludeManagementTools

# Install DNS Server Role
Install-WindowsFeature -Name DNS -IncludeManagementTools

# Install DHCP Server Role
Install-WindowsFeature -Name DHCP -IncludeManagementTools

# Promote DC to Domain Controller and create AD Forest
Import-Module ADDSDeployment
Install-ADDSForest `
-CreateDnsDelegation:$false `
-DatabasePath "C:\Windows\NTDS" `
-DomainMode "WinThreshold" `
-DomainName "subdomain.domain.com" `
-DomainNetbiosName "subdomain" `
-ForestMode "WinThreshold" `
-InstallDns:$true `
-LogPath "C:\Windows\NTDS" `
-NoRebootOnCompletion:$false `
-SysvolPath "C:\Windows\SYSVOL" `
-Force:$true
