---
external help file: OneLoginByOneIdentity-help.xml
Module Name: OneLoginByOneIdentity
online version: https://github.com/AJLindner/OneIdentity-Password-Manager-OneLogin-Integration/blob/master/Docs/Remove-OneLoginUser.md
schema: 2.0.0
---

# Remove-OneLoginUser

## SYNOPSIS
Delete a OneLogin User.

## SYNTAX

### User (Default)
```
Remove-OneLoginUser -User <User> [-Connection <Connection>] [<CommonParameters>]
```

### ID
```
Remove-OneLoginUser -ID <String> [-Connection <Connection>] [<CommonParameters>]
```

## DESCRIPTION
Delete a user from OneLogin either by their unique OneLogin ID, or pass in a [OneLogin.User] User returned via Get-OneLoginUser.

## EXAMPLES

### Example 1
```powershell
PS C:\> $User = Get-OneLoginUser -Filter @{email="testuser@example.com"}

PS C:\> $User | Remove-OneLoginUser
```

Remove a user returned by Get-OneLoginUser

### Example 2
```powershell
PS C:\> $User | Remove-OneLoginUser -ID 12345678
```

Remove a user returned by ID.

## PARAMETERS

### -Connection
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

### -ID
The OneLogin ID of the user you wish to delete.

```yaml
Type: String
Parameter Sets: ID
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -User
The [OneLogin.User] User Object, as returned via Get-OneLoginUser, that you wish to delete.

```yaml
Type: User
Parameter Sets: User
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### OneLogin.User

### System.String

## OUTPUTS

### System.Object
## NOTES

## RELATED LINKS
