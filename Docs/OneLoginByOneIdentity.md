---
Module Name: OneLoginByOneIdentity
Module Guid: d1557d1e-87c7-48a2-a669-5b5d82c8b676
Download Help Link: 
Help Version: 0.0.1
Locale: en-us
---

# OneLoginByOneIdentity Module
## Description
This Powershell Module is a limited fork of the larger, in-progress OneLoginByOneIdentity module. This slimmed-down version is intended specifically for use with the One Identity Password Manager product. It provides OneLogin API Wrapper functions that are necessary for integrating with OneLogin via the OneLogin API 2 (v5). This includes the ability to manage Users, manage Security Factors (Devices), and Authenticate against those Security Factors, driven via API instead of RADIUS.'

## OneLoginByOneIdentity Cmdlets
### [Confirm-OneLoginDeviceRegistration](Confirm-OneLoginDeviceRegistration.md)
Verify a newly registered/enrolled MFA device for a user

### [Connect-OneLogin](Connect-OneLogin.md)
Establish a connection to your OneLogin instance to work with the REST API.

### [Disconnect-OneLogin](Disconnect-OneLogin.md)
Disconnect from a OneLogin instance

### [Get-OneLoginAuthFactors](Get-OneLoginAuthFactors.md)
Gets the available Authentication Factors for a user

### [Get-OneLoginDevices](Get-OneLoginDevices.md)
Get the Devices (e.g. OTP Factors) a user has registered in OneLogin.

### [Get-OneLoginRateLimit](Get-OneLoginRateLimit.md)
Gets the current Rate Limit for the provided OneLogin instance.

### [Get-OneLoginUser](Get-OneLoginUser.md)
Gets OneLogin Users, either all, by a search/filter, or by ID

### [Invoke-OneLoginAPI](Invoke-OneLoginAPI.md)
Helper function that wraps Invoke-RestMethod and Invoke-WebRequest specifically for making REST calls to the OneLogin API.

### [New-OneLoginUser](New-OneLoginUser.md)
Create a new user in OneLogin

### [Register-OneLoginDevice](Register-OneLoginDevice.md)
Enroll a new MFA device for a user

### [Remove-OneLoginUser](Remove-OneLoginUser.md)
Delete a OneLogin User.

### [Reset-OneLoginConnection](Reset-OneLoginConnection.md)
Reset the [OneLogin.Connection] $Connection

### [Resolve-OneLoginAuthentication](Resolve-OneLoginAuthentication.md)
Authenticate a OneLogin User via an enrolled OTP/Device

### [Send-OneLoginAuthentication](Send-OneLoginAuthentication.md)
Sends an MFA Trigger to the provided user's [OneLogin.Device] $Device (a.k.a. "enrolled OTP Factor").

### [Set-OneLoginUser](Set-OneLoginUser.md)
Modify the attributes of a OneLogin User.

### [Unregister-OneLoginDevice](Unregister-OneLoginDevice.md)
Unregister a user's enrolled MFA device

