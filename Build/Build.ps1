# Update Help Documentation
Set-Location "C:\Scripts\Modules\PasswordManager_OneLogin_Standalone\"
Import-Module ".\OneLoginByOneIdentity\OneLoginByOneIdentity.psd1"
Update-MarkdownHelpModule -Path .\Docs -RefreshModulePage
New-ExternalHelp .\Docs -OutputPath .\OneLoginByOneIdentity\en-US\ -Force

