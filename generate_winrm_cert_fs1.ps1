# ======================================================
# WinRM HTTPS Certificate Generator "fs1", "172.25.0.30"
# ======================================================

Write-Host "`nRemoving previous certificate CN=fs1 created" -ForegroundColor Cyan

Get-ChildItem Cert:\LocalMachine\My | Where-Object { $_.Subject -like "*CN=fs1*" } | ForEach-Object {
    Remove-Item -Path "Cert:\LocalMachine\My\$($_.Thumbprint)" -Force
    Write-Host "Removed: $($_.Thumbprint)" -ForegroundColor Green
}

Write-Host "`nGenerating certificate with IP: 172.25.0.30" -ForegroundColor Cyan

# Generate the self-signed certificate
$cert = New-SelfSignedCertificate `
  -DnsName "fs1", "172.25.0.30" `
  -CertStoreLocation "Cert:\LocalMachine\My"

# Validate the certificate
if (-not $cert) {
    Write-Host "`nFailed to generate certificate." -ForegroundColor Red
    exit 1
}
if (-not $cert.HasPrivateKey) {
    Write-Host "`nCertificate does not have a private key." -ForegroundColor Red
    exit 1
}

$thumb = $cert.Thumbprint
Write-Host "`nCertificate generated with Thumbprint: $thumb" -ForegroundColor Green

# Restart WinRM to free up listeners
Write-Host "`nRestarting WinRM service..." -ForegroundColor Yellow
Restart-Service winrm

# Clean up any existing HTTPS listener
Write-Host "`nRemoving old HTTPS listener (if any)..." -ForegroundColor Yellow
winrm delete winrm/config/Listener?Address=*+Transport=HTTPS 2>$null

# Create new WinRM HTTPS listener
Write-Host "`nCreating new WinRM HTTPS listener on port 5986..." -ForegroundColor Cyan
winrm create winrm/config/Listener?Address=*+Transport=HTTPS "@{Hostname=`"fs1`";CertificateThumbprint=`"$thumb`"}"

# Show active listeners
Write-Host "`nActive WinRM Listeners:" -ForegroundColor Green
winrm enumerate winrm/config/Listener
