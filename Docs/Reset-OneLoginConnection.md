---
external help file: OneLoginByOneIdentity-help.xml
Module Name: OneLoginByOneIdentity
online version: https://github.com/AJLindner/OneIdentity-Password-Manager-OneLogin-Integration/blob/master/Docs/Reset-OneLoginConnection.md
schema: 2.0.0
---

# Reset-OneLoginConnection

## SYNOPSIS
Reset the [OneLogin.Connection] $Connection

## SYNTAX

```
Reset-OneLoginConnection [[-Connection] <Connection>] [<CommonParameters>]
```

## DESCRIPTION
Resets the [OneLogin.Connection] passed in for the -connection parameter, or the default $Global:Connection set by Connect-OneLogin. This cmdlet checks if the current Access Token is expired or not. If it is, then a new Access Token will be generated. Otherwise, nothing will happen.

## EXAMPLES

### Example 1
```powershell
PS C:\> Reset-OneLoginConnection
```

Resets the OneLogin Connection, only if the Access Token is expired.

## PARAMETERS

### -Connection
The [OneLogin.Connection] object (returned via Connect-OneLogin) you wish to use for this command. If left blank, it will default to the default $Global:Connection that is set by Connect-OneLogin.

```yaml
Type: Connection
Parameter Sets: (All)
Aliases:

Required: False
Position: 0
Default value: $Global:Connection
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### None

## OUTPUTS

### System.Object
## NOTES

## RELATED LINKS
