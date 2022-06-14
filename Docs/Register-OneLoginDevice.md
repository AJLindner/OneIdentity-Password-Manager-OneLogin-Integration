---
external help file: OneLoginByOneIdentity-help.xml
Module Name: OneLoginByOneIdentity
online version: https://github.com/AJLindner/OneIdentity-Password-Manager-OneLogin-Integration/blob/master/Docs/Register-OneLoginDevice.md
schema: 2.0.0
---

# Register-OneLoginDevice

## SYNOPSIS
Enroll a new MFA device for a user

## SYNTAX

```
Register-OneLoginDevice [-User] <User> [-AuthFactor] <AuthFactor> [-DisplayName] <String> [[-ValidFor] <Int32>]
 [[-CustomMessage] <String>] [[-Verified] <Boolean>] [[-Connection] <Connection>] [<CommonParameters>]
```

## DESCRIPTION
Register a new [OneLogin.AuthFactor] Authentication Factor for a [OneLogin.User] User to enable a new Device for MFA. You can get the available Authentication Factors for the user with Get-OneLoginAuthFactors. You can verify the new device with Confirm-OneLoginDeviceRegistration.

## EXAMPLES

### Example 1
```powershell
PS C:\> $User = Get-OneLoginUser -ID 12345678
PS C:\> $AuthFactor = Get-OneLoginAuthFactors -User $User | Where-Object name -eq "Email OTP"
PS C:\> Register-OneLoginDevice -User $User -AuthFactor $AuthFactor -DisplayName "Test Email OTP"

id                : 7e8c61f6-99d3-4a96-8b09-4201c99b355c
status            : pending
auth_factor_name  : OneLogin Email
type_display_name : Email OTP
user_display_name : Test Email OTP
expires_at        : 1/27/2022 3:37:44 PM +00:00
user              : 12345678
authFactor        : OneLogin.AuthFactor
```

Creates a [OneLogin.DeviceRegistration] Registration for a new Email OTP device/authentication method for the User 12345678. This can be verified via Confirm-OneLoginDeviceRegistration.

## PARAMETERS

### -AuthFactor
The [OneLogin.AuthFactor] Authentication Factor to register. You can get all available Authentication Factors for a user via Get-OneLoginAuthFactors.

```yaml
Type: AuthFactor
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Connection
The [OneLogin.Connection] object (returned via Connect-OneLogin) you wish to use for this command. If left blank, it will default to the default $Global:Connection that is set by Connect-OneLogin.

```yaml
Type: Connection
Parameter Sets: (All)
Aliases:

Required: False
Position: 6
Default value: $Global:Connection
Accept pipeline input: False
Accept wildcard characters: False
```

### -CustomMessage
A message template for use with SMS authentication. This accepts some template variables for the OTP Code and Expiry date. For more information, check the [OneLogin API Documentation](https://developers.onelogin.com/api-docs/2/multi-factor-authentication/enroll-factor)

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 4
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -DisplayName
A name for the users device

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -User
The [OneLogin.User] object (returned from New/Set/Get-OneLoginUser) whose device you are registering.

```yaml
Type: User
Parameter Sets: (All)
Aliases:

Required: True
Position: 0
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### -ValidFor
Time in seconds until the registration expires. Defaults to 120. Valid values are: 120-900 seconds.

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: 3
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Verified
Defaults to false. The following factors support verified = true as part of the initial registration request: OneLogin SMS, OneLogin Voice, OneLogin Email. When using verified = true it is critical that the supported factors have pre-verified values, most likely imported from an existing directory or by the users themselvdes.

Factors such as Authenticator and OneLogin Protect do not support verification = true as the user interaction is required to verify the factor.

For more information, check the [OneLogin API Documentation](https://developers.onelogin.com/api-docs/2/multi-factor-authentication/enroll-factor)

```yaml
Type: Boolean
Parameter Sets: (All)
Aliases:

Required: False
Position: 5
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### OneLogin.User

## OUTPUTS

### OneLogin.Device
## NOTES

## RELATED LINKS
