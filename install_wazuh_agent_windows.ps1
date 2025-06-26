# Create Temp directory
New-Item -Path "C:\Temp" -ItemType Directory -Force | Out-Null

# Download Wazuh Agent MSI
Invoke-WebRequest -Uri "https://packages.wazuh.com/4.x/windows/wazuh-agent-4.4.5-1.msi" -OutFile "C:\Temp\wazuh-agent.msi"

# Install Wazuh Agent
Start-Process -FilePath "msiexec.exe" -ArgumentList "/i C:\Temp\wazuh-agent.msi /q ADDRESS=172.25.0.50" -Wait

# Download Sysmon ZIP
Invoke-WebRequest -Uri "https://download.sysinternals.com/files/Sysmon.zip" -OutFile "C:\Temp\Sysmon.zip"

# Extract Sysmon
Expand-Archive -Path "C:\Temp\Sysmon.zip" -DestinationPath "C:\Temp\sysmon" -Force

# Download Sysmon configuration
Invoke-WebRequest -Uri "https://raw.githubusercontent.com/SwiftOnSecurity/sysmon-config/master/sysmonconfig-export.xml" -OutFile "C:\Temp\sysmonconfig.xml"

# Install Sysmon with config
Start-Process -FilePath "C:\Temp\sysmon\Sysmon64.exe" -ArgumentList '-accepteula -i C:\Temp\sysmonconfig.xml' -Wait

# Modify Wazuh agent config to enable Sysmon event channel
$confPath = "C:\Program Files (x86)\ossec-agent\ossec.conf"
$line = '<localfile><log_format>eventchannel</log_format><location>Microsoft-Windows-Sysmon/Operational</location></localfile>'

if ((Get-Content $confPath) -notcontains $line) {
    (Get-Content $confPath) | ForEach-Object {
        $_
        if ($_ -match '<localfile>') {
            $line
        }
    } | Set-Content $confPath
}
