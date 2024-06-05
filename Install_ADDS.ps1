# This script will assign a static IP to a server, will install the ADDS role, and will promote the server to a Domain Controller

# Assign a static IP address to the server
$IPAddress = "192.168.50.50"
$SubnetMask = "255.255.255.0"
$Gateway = "192.168.50.1"
$DNS = "192.168.50.50"
$InterfaceIndex = (Get-NetAdapter).InterfaceIndex
New-NetIPAddress -InterfaceIndex $InterfaceIndex -IPAddress $IPAddress -PrefixLength 24 -DefaultGateway $Gateway
Set-DnsClientServerAddress -InterfaceIndex $InterfaceIndex -ServerAddresses $DNS

# Install the ADDS role and promote the server to a Domain Controller
Install-WindowsFeature -Name AD-Domain-Services -IncludeManagementTools
Install-ADDSForest -DomainName "Domain.com" `
                  -DomainNetbiosName "Domain" `
                  -ForestMode "WinThreshold" `
                  -DomainMode "WinThreshold" `
                  -InstallDns `
                  -Force
