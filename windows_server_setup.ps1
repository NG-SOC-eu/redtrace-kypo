# Variables
$domainName = "redtrace.local"
$dcAddress = "172.25.0.40"

Disable-NetAdapter -Name "Ethernet" -Confirm:$false
Set-DnsClientServerAddress -InterfaceAlias "Ethernet 2" -ServerAddresses ($dcAddress)

# Display DNS config
Write-Host "`nCurrent DNS server per interface:" -ForegroundColor Cyan
Get-DnsClientServerAddress | Format-Table InterfaceAlias, ServerAddresses

# Flush DNS cache
Write-Host "`nFlushing DNS resolver cache..." -ForegroundColor Cyan
ipconfig /flushdns | Out-Null

# Check connectivity to Domain Controller
Write-Host "`nTesting connectivity to DC (port 389)..." -ForegroundColor Cyan
$ping = Test-NetConnection -ComputerName redtrace.local -Port 389

if (-not $ping.TcpTestSucceeded) {
    Write-Host "Unable to connect to redtrace.local on port 389. Aborting." -ForegroundColor Red
    exit 1
}

# Prompt for domain credentials and join
Write-Host "`nPlease enter domain credentials to join '$domainName'" -ForegroundColor Cyan
try {
    Add-Computer -DomainName $domainName -Credential (Get-Credential) -Restart
}
catch {
    Write-Host "Failed to join the domain: $_" -ForegroundColor Red
    exit 1
}

