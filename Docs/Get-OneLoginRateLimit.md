---
external help file: OneLoginByOneIdentity-help.xml
Module Name: OneLoginByOneIdentity
online version:
schema: 2.0.0
---

# Get-OneLoginRateLimit

## SYNOPSIS
Gets the current Rate Limit for the provided OneLogin instance.

## SYNTAX

```
Get-OneLoginRateLimit [[-Connection] <Connection>] [<CommonParameters>]
```

## DESCRIPTION
Returns a [OneLogin.APIRateLimit] object for the included [OneLogin.Connection], which shows the total RateLimit (default 5000), RateLimitRemaining, and RateLimitReset.

## EXAMPLES

### Example 1
```powershell
PS C:\> Get-OneLoginRateLimit

RateLimit RateLimitRemaining RateLimitReset
--------- ------------------ --------------
     5000               5000 01:00:00
```

Gets the Rate Limit for the default connection

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

### OneLogin.APIRateLimit
## NOTES

## RELATED LINKS
