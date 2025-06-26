Install-WindowsFeature -Name AD-Domain-Services -IncludeManagementTools

Install-ADDSForest `
  -DomainName "redtrace.local" `
  -DomainNetbiosName "REDTRACE" `
  -SafeModeAdministratorPassword (ConvertTo-SecureString $env:ADMIN_PASSWORD -AsPlainText -Force) `
  -InstallDns `
  -Force
