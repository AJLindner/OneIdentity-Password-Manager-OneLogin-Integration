---
external help file: OneLoginByOneIdentity-help.xml
Module Name: OneLoginByOneIdentity
online version: https://github.com/AJLindner/OneIdentity-Password-Manager-OneLogin-Integration/blob/master/Docs/New-OneLoginTemporaryOTP.md
schema: 2.0.0
---

# New-OneLoginTemporaryOTP

## SYNOPSIS
Generates a Temporary OTP for a user

## SYNTAX

```
New-OneLoginTemporaryOTP [-User] <User> [[-ValidFor] <Int32>] [[-Reusable] <Boolean>]
 [[-OneLoginConnection] <Object>] [<CommonParameters>]
```

## DESCRIPTION
Generates a temporary OTP for a user in OneLogin.

## EXAMPLES

### Example 1
```powershell
PS C:\> $User = Get-OneLoginUser -ID 12345
New-OneLoginTemporaryOTP -User $User

mfa_token               : 25992782
expires_at              : 2022-03-17T18:04:12.807Z
reusable                : false
device_id               : user_temp_otp_36216766
```

Generates a temporary OTP for user with ID 12345.

## PARAMETERS

### -OneLoginConnection
The [OneLogin.Connection] object (returned via Connect-OneLogin) you wish to use for this command. If left blank, it will default to the default $Global:Connection that is set by Connect-OneLogin.

```yaml
Type: Object
Parameter Sets: (All)
Aliases:

Required: False
Position: 3
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Reusable
Determines if the token is reusable multiple times within the expiry window.

```yaml
Type: Boolean
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -User
The [OneLogin.User] User Object who you want to generate a temporary OTP token for.

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
Set the duration of the token in seconds. Defaults to 259200 (72 hours), which is also the max value.

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### OneLogin.User

## OUTPUTS

### System.Object
## NOTES

## RELATED LINKS
