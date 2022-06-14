---
external help file: OneLoginByOneIdentity-help.xml
Module Name: OneLoginByOneIdentity
online version:
schema: 2.0.0
---

# Get-OneLoginDevices

## SYNOPSIS
Get the Devices (e.g. OTP Factors) a user has registered in OneLogin.

## SYNTAX

```
Get-OneLoginDevices [-User] <User> [[-Connection] <Connection>] [<CommonParameters>]
```

## DESCRIPTION
Gets all of the OTP Factors that a OneLogin user has registered. This includes OneLogin Protect, OneLogin SMS, OneLogin Email (both magic link and OTP), OneLogin Voice, and Authenticator factors.

## EXAMPLES

### Example 1
```powershell
PS C:\> $User = Get-OneLoginUser -ID 12345678

PS C:\> Get-OneLoginDevices -User $User

device_id           : 9528539
user_display_name   : OneLogin Protect
type_display_name   : OneLogin Protect
auth_factor_name    : OneLogin
is_default          : False
user                : 12345678
verification_method : Prompt

device_id           : 8903343
user_display_name   : MS Authenticator
type_display_name   : Authenticator
auth_factor_name    : Google Authenticator
is_default          : False
user                : 12345678
verification_method : OTP

device_id           : 9945859
user_display_name   : Email OTP
type_display_name   : Email OTP
auth_factor_name    : OneLogin Email
is_default          : False
user                : 12345678
verification_method : Both

device_id           : 9946124
user_display_name   : Email Magic Link
type_display_name   : Email Magic Link
auth_factor_name    : OneLogin Email
is_default          : False
user                : 12345678
verification_method : Both
```

Get a User with ID 12345678, then get all Enrolled Devices (factors) for that user

## PARAMETERS

### -Connection
The [OneLogin.Connection] object (returned via Connect-OneLogin) you wish to use for this command. If left blank, it will default to the default $Global:Connection that is set by Connect-OneLogin.

```yaml
Type: Connection
Parameter Sets: (All)
Aliases:

Required: False
Position: 1
Default value: $Global:Connection
Accept pipeline input: False
Accept wildcard characters: False
```

### -User
The [OneLogin.User] object (returned from New/Set/Get-OneLoginUser) whose devices you wish to retreive.

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

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### OneLogin.User

## OUTPUTS

### OneLogin.Device[]
## NOTES

## RELATED LINKS
