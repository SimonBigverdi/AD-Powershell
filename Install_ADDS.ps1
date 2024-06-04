# Configurations below are made up and can be modified as needed

# Assign a static IP address to the server
$IPAddress = "192.168.50.50"
$SubnetMask = "255.255.255.0"
$Gateway = "192.168.50.1"
$DNS = "192.168.50.50"
$InterfaceIndex = (Get-NetAdapter).InterfaceIndex
New-NetIPAddress -InterfaceIndex $InterfaceIndex -IPAddress $IPAddress -PrefixLength 24 -DefaultGateway $Gateway
Set-DnsClientServerAddress -InterfaceIndex $InterfaceIndex -ServerAddresses $DNS

# Install the AD DS role and promote the server to a domain controller
Install-WindowsFeature -Name AD-Domain-Services -IncludeManagementTools
Install-ADDSForest -DomainName "Domain.com" `
                  -DomainNetbiosName "Domain" `
                  -ForestMode "WinThreshold" `
                  -DomainMode "WinThreshold" `
                  -InstallDns `
                  -Force

# Install DHCP role and configure DHCP server
Install-WindowsFeature -Name DHCP -IncludeManagementTools
Add-DhcpServerv4Scope -Name "Scope1" `
                      -StartRange "192.168.50.100" `
                      -EndRange "192.168.1.200" `
                      -SubnetMask "255.255.255.0" `
                      -State Active

# DNS server IP addresses
$DNSServers = "192.168.50.50", "192.168.50.51"

# Get the DHCP server scope ID
$ScopeID = (Get-DhcpServerv4Scope).ScopeID

# Loop through each DNS server IP and add it as an option value
foreach ($DNSServer in $DNSServers) {
    Add-DhcpServerv4OptionValue -ScopeID $ScopeID -OptionId 6 -Value $DNSServer
}