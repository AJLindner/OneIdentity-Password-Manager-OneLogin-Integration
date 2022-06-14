---
external help file: OneLoginByOneIdentity-help.xml
Module Name: OneLoginByOneIdentity
online version: https://github.com/AJLindner/OneIdentity-Password-Manager-OneLogin-Integration/blob/master/Docs/Unregister-OneLoginDevice.md
schema: 2.0.0
---

# Unregister-OneLoginDevice

## SYNOPSIS
Unregister a user's enrolled MFA device

## SYNTAX

```
Unregister-OneLoginDevice [-Device] <Device> [[-Connection] <Connection>] [<CommonParameters>]
```

## DESCRIPTION
Remove a [OneLogin.Device] Device that is currently enrolled for a user.

## EXAMPLES

### Example 1
```powershell
PS C:\> $Devices = Get-OneLoginDevices -User $User | Where type_display_name -eq "Old Device"
PS C:\> ForEach ($Device in $Devices) {Unregister-OneLoginDevice -Device $Device}
```

Removes all devices with a type of "Old Device" from the user.

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

### -Device
The [OneLogin.Device] that you wish to unregister/remove from its user.

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

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### OneLogin.Device

## OUTPUTS

### System.Object
## NOTES

## RELATED LINKS
