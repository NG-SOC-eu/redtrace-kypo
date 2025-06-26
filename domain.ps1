Import-Module ActiveDirectory
Set-ADAccountPassword `
  -Identity "Administrator" `
  -NewPassword (ConvertTo-SecureString $env:ADMIN_PASSWORD -AsPlainText -Force) `
  -Reset
