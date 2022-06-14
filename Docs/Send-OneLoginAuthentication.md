---
external help file: OneLoginByOneIdentity-help.xml
Module Name: OneLoginByOneIdentity
online version: https://github.com/AJLindner/OneIdentity-Password-Manager-OneLogin-Integration/blob/master/Docs/Send-OneLoginAuthentication.md
schema: 2.0.0
---

# Send-OneLoginAuthentication

## SYNOPSIS
Sends an MFA Trigger to the provided user's [OneLogin.Device] $Device (a.k.a. "enrolled OTP Factor").

## SYNTAX

```
Send-OneLoginAuthentication [-Device] <Device> [[-ValidFor] <Int32>] [[-CustomMessage] <String>]
 [[-OneLoginConnection] <Object>] [<CommonParameters>]
```

## DESCRIPTION
Certain Devices or OTP Factors require a trigger in order to perform an authentication. For example, an SMS authentication or an Email OTP requires that a message be sent with the OTP Code, and a Push Authentication via OneLogin Protect requires that we trigger that Push Authentication. This cmdlet sends an MFA trigger to the provided [OneLogin.Device] factor (returned via Get-OneLoginDevices), and returns a [OneLogin.Authentication] object, which you can then use with Resolve-OneLoginAuthentication to either provide the OTP and authenticate, or wait for the user to accept the trigger (in the case of OneLogin Protect or Authenticator Push Authentication, Magic Link Email, or OneLogin Voice Authentication).

## EXAMPLES

### Example 1
```powershell
PS C:\> $User = Get-OneLoginUser -ID 12345678
PS C:\> $Device = $User | Get-OneLoginDevices | Where-Object is_default
PS C:\> Send-OneLoginAuthentication -Device $Device

id                : b4dbd4f6-0e69-4e52-88fc-18e5aba207d4
device_id         : 9528539
user_id           : 12345678
user_display_name : OneLogin Protect
type_display_name : OneLogin Protect
auth_factor_name  : OneLogin
expires_at        : 1/24/2022 4:12:46 PM -06:00
Device            : OneLogin.Device
Status            : Pending
```

Gets the Default enrolled device for user 12345678 and sends a trigger to that device. The returned [OneLogin.Verification] object can be passed in to Resolve-OneLoginAuthentication to confirm whether this authentication was successful or not.

### Example 2
```powershell
PS C:\> $Device | Send-OneLoginAuthentication -ValidFor 240

id                : b4dbd4f6-0e69-4e52-88fc-18e5aba207d4
device_id         : 9528539
user_id           : 12345678
user_display_name : OneLogin Protect
type_display_name : OneLogin Protect
auth_factor_name  : OneLogin
expires_at        : 1/24/2022 4:13:46 PM -06:00
Device            : OneLogin.Device
Status            : Pending
```

Sends a trigger to $Device that expires in 240 seconds.

## PARAMETERS

### -CustomMessage
A message template for use with SMS authentication. This accepts some template variables for the OTP Code and Expiry date. For more information, check the [OneLogin API Documentation](https://developers.onelogin.com/api-docs/2/multi-factor-authentication/activate-factor)

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Device
The [OneLogin.Device] device to trigger for Authentication.

```yaml
Type: Device
Parameter Sets: (All)
Aliases:

Required: True
Position: 0
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### -OneLoginConnection
The [OneLogin.Connection] object (returned via Connect-OneLogin) you wish to use for this command. If left blank, it will default to the default $Global:Connection that is set by Connect-OneLogin.

```yaml
Type: Object
Parameter Sets: (All)
Aliases:

Required: False
Position: 3
Default value: $Global:Connection
Accept pipeline input: False
Accept wildcard characters: False
```

### -ValidFor
Time in seconds until the trigger expires. Defaults to 120. Max 900.

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: 1
Default value: 120
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### OneLogin.Device

## OUTPUTS

### System.Object
## NOTES

## RELATED LINKS
