# Update Help Documentation
Set-Location "C:\Scripts\Modules\OneIdentity-Password-Manager-OneLogin-Integration\"
Import-Module ".\OneLoginByOneIdentity\OneLoginByOneIdentity.psd1"
Update-MarkdownHelpModule -Path .\Docs -RefreshModulePage
New-ExternalHelp .\Docs -OutputPath .\OneLoginByOneIdentity\en-US\ -Force

