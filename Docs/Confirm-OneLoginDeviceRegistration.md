---
external help file: OneLoginByOneIdentity-help.xml
Module Name: OneLoginByOneIdentity
online version: https://presales-oneidentity.visualstudio.com/Misc/_git/OneLoginPowershell?path=/Docs/Confirm-OneLoginDeviceRegistration.md&_a=preview
schema: 2.0.0
---

# Confirm-OneLoginDeviceRegistration

## SYNOPSIS
Verify a newly registered/enrolled MFA device for a user

## SYNTAX

### Prompt (Default)
```
Confirm-OneLoginDeviceRegistration -DeviceRegistration <DeviceRegistration> [-Timeout <Int32>]
 [-OneLoginConnection <Connection>] [<CommonParameters>]
```

### OTP
```
Confirm-OneLoginDeviceRegistration -DeviceRegistration <DeviceRegistration> -OTP <String> [-Timeout <Int32>]
 [-OneLoginConnection <Connection>] [<CommonParameters>]
```

## DESCRIPTION
After registering a new MFA device with Register-OneLoginDevice, that device may need to be verified. If so, this command allows you to verify the newly enrolled device by providing the [OneLogin.Registration] response and the user-provided OTP.

This will return the newly-verified [OneLogin.Device] device if it is successful. Otherwise, if the OTP is incorrect or the registration is expired, it will throw an error.

## EXAMPLES

### Example 1
```powershell
PS C:\> $Registration = Register-OneLoginDevice -User $User -AuthFactor $AuthFactor -DisplayName "Test Device"
PS C:\> Confirm-OneLoginDeviceRegistration -DeviceRegistration $Registration -OTP 123456

device_id           : 10012154
user_display_name   : Test Device
type_display_name   : Email OTP
auth_factor_name    : OneLogin Email
is_default          : False
user                : 12345678
verification_method : Both
```

Confirms the registration of the "Test Device" of type "OneLogin Email" for user "12345678", with OTP "123456".

## PARAMETERS

### -DeviceRegistration
The [OneLogin.DeviceRegistration] object returned via Register-OneLoginDevice.

```yaml
Type: DeviceRegistration
Parameter Sets: (All)
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### -OTP
The user-provided OTP Code

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
The time to wait for a user to confirm the Device Registration request, in seconds. Default is 120.

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### OneLogin.DeviceRegistration

### System.String

## OUTPUTS

### OneLogin.Device
## NOTES

## RELATED LINKS
