---
external help file: OneLoginByOneIdentity-help.xml
Module Name: OneLoginByOneIdentity
online version:
schema: 2.0.0
---

# Disconnect-OneLogin

## SYNOPSIS
Disconnect from a OneLogin instance

## SYNTAX

```
Disconnect-OneLogin [[-Connection] <Connection>] [<CommonParameters>]
```

## DESCRIPTION
Disconnect from any OneLogin instance connected to via Connect-OneLogin. This will revoke the access token that is automatically generated during the initial connection to ensure it is no longer valid. If no -connection parameter is passed in, this will disconnect the default connection stored in $global:connection.

## EXAMPLES

### Example 1
```powershell
PS C:\> Disconnect-OneLogin
```

Disconnects from the current OneLogin instance

## PARAMETERS

### -Connection
The [OneLogin.Connection] object (returned via Connect-OneLogin) you wish to disconnect from. If left blank, it will default to the $Global:Connection that is set by Connect-OneLogin.

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
