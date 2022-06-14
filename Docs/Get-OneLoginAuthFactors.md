---
external help file: OneLoginByOneIdentity-help.xml
Module Name: OneLoginByOneIdentity
online version: https://github.com/AJLindner/OneIdentity-Password-Manager-OneLogin-Integration/blob/master/Docs/Get-OneLoginAuthFactors.md
schema: 2.0.0
---

# Get-OneLoginAuthFactors

## SYNOPSIS
Gets the available Authentication Factors for a user

## SYNTAX

```
Get-OneLoginAuthFactors [-User] <User> [[-Connection] <Connection>] [<CommonParameters>]
```

## DESCRIPTION
Returns a list of all [OneLogin.AuthFactor] Authentication Factors that are available for a user to register as a new device. 

## EXAMPLES

### Example 1
```powershell
PS C:\> $User = Get-OneLoginUser -Filter @{Username="TestUser"}
PS C:\> Get-OneLoginAuthFactors -User $User

factor_id name             auth_factor_name     verification_method
--------- ----             ----------------     -------------------
    77339 OneLogin Protect OneLogin             Prompt
    80225 Email OTP        OneLogin Email       Both
    77341 Email Magic Link OneLogin Email       Both
    77340 Authenticator    Google Authenticator OTP
```

Gets the available Authentication Factors available for the user TestUser.

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

### OneLogin.AuthFactor[]
## NOTES

## RELATED LINKS
