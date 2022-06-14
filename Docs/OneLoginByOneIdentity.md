---
Module Name: OneLoginByOneIdentity
Module Guid: d1557d1e-87c7-48a2-a669-5b5d82c8b676
Download Help Link:
Help Version: 0.0.1
Locale: en-us
---

# OneLoginByOneIdentity Module
## Description
This Powershell Module is intended for use by One Identity Presales to build integrations between our products and OneLogin. It is essentially a wrapper around various endpoints available in OneLogin's REST API, but is being built on top of a custom class-object model for consistency and expandability. The initial scope is to support all the object classes and functions needed to easily authenticate a user via any MFA devices they have registered with OneLogin. Additional functionality not already covered by the class implementation will be added over time, as the need arises. Please refer to the OneLogin API Documentation for additional information.

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

### [New-OneLoginTemporaryOTP](New-OneLoginTemporaryOTP.md)
Generates a Temporary OTP for a user

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

