---
external help file: OneLoginByOneIdentity-help.xml
Module Name: OneLoginByOneIdentity
online version:
schema: 2.0.0
---

# Resolve-OneLoginAuthentication

## SYNOPSIS
Authenticate a OneLogin User via an enrolled OTP/Device

## SYNTAX

### Prompt (Default)
```
Resolve-OneLoginAuthentication -Authentication <Authentication> [-Timeout <Int32>]
 [-OneLoginConnection <Connection>] [<CommonParameters>]
```

### OTP
```
Resolve-OneLoginAuthentication -Authentication <Authentication> -OTP <String> [-Timeout <Int32>]
 [-OneLoginConnection <Connection>] [<CommonParameters>]
```

## DESCRIPTION
Authenticate a OneLogin user via any of their enrolled OTP Factors (devices) including OneLogin Protect OTP or Push, Authenticator OTP or Push, Email OTP or Magic Link, SMS OTP, and OneLogin Voice. For an OTP authentication using OneLogin Protect, or Authenticator, the [OneLogin.Device] Device and the OTP Code are needed. All other Authentications require the [OneLogin.Authentication] Authentication object returned by Send-OneLoginAuthentication, and either the [Switch] -Push parameter, or the [string] -OTP code, provided by the user in response to the trigger.

## EXAMPLES

### Example 1
```powershell
PS C:\> $User = Get-OneLoginUser -ID 12345678
PS C:\> $Device = $User | Get-OneLoginDevices | Where-Object is_default
PS C:\> $Authentication = Send-OneLoginAuthentication -Device $Device
PS C:\> Resolve-OneLoginAuthentication -Authentication $Authentication -Push

id                : 8038046a-d655-4f78-8134-29194f049af0
device_id         : 9528539
user_id           : 12345678
user_display_name : OneLogin Protect
type_display_name : OneLogin Protect
auth_factor_name  : OneLogin
expires_at        : 1/24/2022 4:27:43 PM -06:00
Device            : OneLogin.Device
Status            : accepted
```

Gets the Default enrolled device for user 12345678, sends a push authentication trigger to that device, and waits for that authentication to process. The returned [OneLogin.Authentication] Authentication object has a Status parameter that shows that the user Accepted the push authentication request. Note that this process will continuously poll the endpoint until either the user responds to the request, or the $timeout is reached.

### Example 2
```powershell
PS C:\> $User = Get-OneLoginUser -ID 12345678
PS C:\> $Device = $User | Get-OneLoginDevices | Where-Object type_display_name -eq "Email OTP"
PS C:\> $Authentication = Send-OneLoginAuthentication -Device $Device
PS C:\> $OTPCode = Read-Host "Enter your emailed OTP Code:"
PS C:\> Resolve-OneLoginAuthentication -Authentication $Authentication -OTP $OTPCode

id                : d09688a1-8ccd-46a8-8a65-cda166484eef
device_id         : 9945859
user_id           : 12345678
user_display_name : Email OTP
type_display_name : Email OTP
auth_factor_name  : OneLogin Email
expires_at        : 1/24/2022 4:33:18 PM -06:00
Device            : OneLogin.Device
Status            : accepted
```

Example of an Email OTP AUthentication. The type_display_name for each authentication method is configurable by the OneLogin Administrator, and can therefore be used for specific filtering. In this example, we select a device that uses an Emailed OTP, send a trigger to that device, then prompt the user to enter in the provided OTP Code. That code and the [OneLogin.Authentication] Authentication object are then used to successfully authenticate.

## PARAMETERS

### -Authentication
The [OneLogin.Authentication] Authentication object returned from the trigger sent with Send-OneLoginAuthentication.

```yaml
Type: Authentication
Parameter Sets: (All)
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### -OTP
The OTP Code provided by the user in response to the trigger generated via Send-OneLoginAuthentication.

```yaml
Type: String
Parameter Sets: OTP
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -OneLoginConnection
The [OneLogin.Connection] object (returned via Connect-OneLogin) you wish to use for this command. If left blank, it will default to the default $Global:Connection that is set by Connect-OneLogin.

```yaml
Type: Connection
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: $Global:Connection
Accept pipeline input: False
Accept wildcard characters: False
```

### -Timeout
The time to wait for a user response to a Push Authentication request, in seconds. Default is 120.

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: 120
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### OneLogin.Authentication

### OneLogin.Device

## OUTPUTS

### System.Object
## NOTES

## RELATED LINKS
