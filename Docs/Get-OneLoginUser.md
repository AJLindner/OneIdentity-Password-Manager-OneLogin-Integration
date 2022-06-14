---
external help file: OneLoginByOneIdentity-help.xml
Module Name: OneLoginByOneIdentity
online version: https://github.com/AJLindner/OneIdentity-Password-Manager-OneLogin-Integration/blob/master/Docs/Get-OneLoginUser.md
schema: 2.0.0
---

# Get-OneLoginUser

## SYNOPSIS
Gets OneLogin Users, either all, by a search/filter, or by ID

## SYNTAX

### Filter (Default)
```
Get-OneLoginUser [-Filter <Hashtable>] [-All] [-Raw] [-Connection <Connection>] [<CommonParameters>]
```

### ID
```
Get-OneLoginUser [-ID <String>] [-Connection <Connection>] [<CommonParameters>]
```

## DESCRIPTION
Get a list of OneLogin Users, all OneLogin Users, a subset of users by -filter, or a specific user by ID. Returns [OneLogin.User] object(s). For detailed information on the available filter parameters, please reference the [OneLogin API List Users Endpoint](https://developers.onelogin.com/api-docs/2/users/list-users)

## EXAMPLES

### Example 1
```powershell
PS C:\> Get-OneLoginUser                   

email                  : aj.lindner@oneidentity.com
locked_until           :
password_changed_at    : 2021-10-18T13:50:30.290Z
directory_id           :
id                     : 12345678
username               : aj
invitation_sent_at     : 2021-10-18T13:49:42.899Z
external_id            :
member_of              :
samaccountname         :
activated_at           : 2021-08-18T17:11:50.966Z
invalid_login_attempts : 0
group_id               :
last_login             : 2022-01-24T12:20:19.544Z
phone                  : 5555555555
state                  : 1
firstname              : AJ
updated_at             : 2022-01-24T12:20:19.624Z
lastname               : Lindner
created_at             : 2021-08-18T17:11:50.969Z
distinguished_name     :
status                 : 1

email                  : mikemanager@ajlindner.xyz
locked_until           :
password_changed_at    : 2021-12-08T21:30:13.055Z
directory_id           : 80670
id                     : 23456789
username               : mikemanager@ajlindner.xyz
...
```

Calling this cmdlet with no parameters will return all OneLogin Users as a [OneLogin.User[]]Collection

### Example 2
```powershell
PS C:\> Get-OneLoginUser -ID 12345678             

group_id               :
lastname               : Lindner
status                 : 1
userprincipalname      :
title                  :
id                     : 12345678
trusted_idp_id         :
manager_ad_id          :
comment                : 
invalid_login_attempts : 0
invitation_sent_at     : 2021-10-18T13:49:42.899Z
phone                  : 5555555555
username               : aj
department             :
custom_attributes      : @{CustomField=; CustomField2=}
firstname              : AJ
role_ids               : {}
directory_id           :
member_of              :
company                : One Identity
created_at             : 2021-08-18T17:11:50.969Z
external_id            :
manager_user_id        :
last_login             : 2022-01-24T12:20:19.544Z
password_changed_at    : 2021-10-18T13:50:30.290Z
state                  : 1
samaccountname         :
updated_at             : 2022-01-24T12:20:19.624Z
activated_at           : 2021-08-18T17:11:50.966Z
distinguished_name     :
email                  : aj.lindner@oneidentity.com
locked_until           :
preferred_locale_code  :
```

Get a specific user by their OneLogin ID.

### Example 3
```powershell
PS C:\> Get-OneLoginUser -Filter @{username="AJ"}                

email                  : aj.lindner@oneidentity.com
locked_until           :
password_changed_at    : 2021-10-18T13:50:30.290Z
directory_id           :
id                     : 12345678
username               : aj
invitation_sent_at     : 2021-10-18T13:49:42.899Z
external_id            :
member_of              :
samaccountname         :
activated_at           : 2021-08-18T17:11:50.966Z
invalid_login_attempts : 0
group_id               :
last_login             : 2022-01-24T12:20:19.544Z
phone                  : 5555555555
state                  : 1
firstname              : AJ
updated_at             : 2022-01-24T12:20:19.624Z
lastname               : Lindner
created_at             : 2021-08-18T17:11:50.969Z
distinguished_name     :
status                 : 1
```

Search for users based on query parameters, documented in the [OneLogin API List Users Endpoint](https://developers.onelogin.com/api-docs/2/users/list-users)

## PARAMETERS

### -All
Returns ALL OneLogin Users by automatically paginating API responses. See the [OneLogin API Pagination Section](https://developers.onelogin.com/api-docs/2/getting-started/using-query-parameters#pagination) for information on what is happening behind the scenes.

```yaml
Type: SwitchParameter
Parameter Sets: Filter
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### -Connection
The [OneLogin.Connection] object (returned via Connect-OneLogin) you wish to use for this command. If left blank, it will default to the default $Global:Connection that is set by Connect-OneLogin.

```yaml
Type: Connection
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Filter
A [Hashtable] filter based on the query parameters documented in the [OneLogin API List Users Endpoint](https://developers.onelogin.com/api-docs/2/users/list-users).

E.g. -Filter @{Firstname="AJ" ; LastName="Lindner"}

```yaml
Type: Hashtable
Parameter Sets: Filter
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### -ID
The user's OneLogin ID.

```yaml
Type: String
Parameter Sets: ID
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### -Raw
Returns the raw [Microsoft.PowerShell.Commands.BasicHtmlWebResponseObject] web response(s).

```yaml
Type: SwitchParameter
Parameter Sets: Filter
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### System.Collections.Hashtable

### System.String

## OUTPUTS

### OneLogin.User
## NOTES

## RELATED LINKS
