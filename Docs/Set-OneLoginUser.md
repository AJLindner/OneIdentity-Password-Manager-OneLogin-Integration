---
external help file: OneLoginByOneIdentity-help.xml
Module Name: OneLoginByOneIdentity
online version: https://github.com/AJLindner/OneIdentity-Password-Manager-OneLogin-Integration/blob/master/Docs/Set-OneLoginUser.md
schema: 2.0.0
---

# Set-OneLoginUser

## SYNOPSIS
Modify the attributes of a OneLogin User.

## SYNTAX

### User (Default)
```
Set-OneLoginUser [-User <User>] [-mappings <String>] [-validate_policy <String>] [-password <String>]
 [-Connection <Connection>] [<CommonParameters>]
```

### ID
```
Set-OneLoginUser [-mappings <String>] [-validate_policy <String>] [-password <String>] -ID <String>
 [-email <String>] [-username <String>] [-group_id <String>] [-role_ids <String[]>] [-firstname <String>]
 [-lastname <String>] [-title <String>] [-department <String>] [-company <String>] [-comment <String>]
 [-phone <String>] [-state <UserState>] [-status <UserStatus>] [-directory_id <Int32>]
 [-trusted_idp_id <Int32>] [-manager_ad_id <Int32>] [-manager_user_id <Int32>] [-samaccountname <String>]
 [-member_of <String>] [-userprincipalname <String>] [-distinguished_name <String>] [-external_id <String>]
 [-Connection <Connection>] [<CommonParameters>]
```

## DESCRIPTION
Make changes to a user in OneLogin. Please refer to the [OneLogin API Update User Endpoint Documentation](https://developers.onelogin.com/api-docs/2/users/update-user) as needed. Currently, this cmdlet does not support pre-hashed passwords, therefore the *password_algorithm* and *salt* parameters mentioned in the documentation do not exist for this cmdlet.

You can either pass in the user's OneLogin ID and all of the attributes you wish to update, or you can modify the [OneLogin.User] object returned from Get-OneLoginUser and pass that in instead.

Will return the modified [OneLogin.User] user object.

## EXAMPLES

### Example 1
```powershell
PS C:\> Set-OneLoginUser -ID 12345678 -Company "Test Company" -Phone "5555555555" -Title "Test User"         

activated_at           :
comment                :
company                : Test Company
created_at             : 1/25/2022 12:16:22 PM +00:00
custom_attributes      :
department             :
directory_id           :
distinguished_name     :
email                  : testuser@example.com
external_id            :
firstname              : Test
group_id               :
id                     : 12345678
invalid_login_attempts : 0
invitation_sent_at     :
lastname               : User
last_login             :
locale_code            :
preferred_locale_code  : 
locked_until           :
manager_ad_id          :
manager_user_id        :
member_of              :
notes                  :
openid_name            :
password_changed_at    :
phone                  : 5555555555
role_ids               : {}
samaccountname         :
state                  : Unapproved
status                 : Password_Pending
title                  : Test User
trusted_idp_id         :
updated_at             : 1/25/2022 12:34:34 PM +00:00
username               : testuser
userprincipalname      :
```

Update a OneLogin User's attributes by specifying the ID and the individual attributes.

### Example 2
```powershell
PS C:\> $User = Get-OneLoginUser -ID 12345678

PS C:\> $User.Department = "Test Department"

PS C:\> $User | Set-OneLoginUser

activated_at           :
comment                :
company                : Test Company
created_at             : 1/25/2022 12:16:22 PM +00:00
custom_attributes      :
department             : Test Department
directory_id           :
distinguished_name     :
email                  : testuser@example.com
external_id            :
firstname              : Test
group_id               : 
id                     : 12345678
invalid_login_attempts : 0
invitation_sent_at     :
lastname               : User
last_login             :
locale_code            :
preferred_locale_code  :
locked_until           :
manager_ad_id          :
manager_user_id        :
member_of              :
notes                  :
openid_name            :
password_changed_at    :
phone                  : 5555555555
role_ids               : {456043}
samaccountname         :
state                  : Unapproved
status                 : Password_Pending
title                  : Test User
trusted_idp_id         :
updated_at             : 1/25/2022 1:29:38 PM +00:00
username               : testuser
userprincipalname      :
```

Update a OneLogin User's attributes by modifying and passing in a [OneLogin.User] User object returned via Get-OneLoginUser.

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
The user's OneLogin ID.

```yaml
Type: String
Parameter Sets: ID
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -User
The modified [OneLogin.User] User object, returned by Get-OneLoginUser.

```yaml
Type: User
Parameter Sets: User
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### -comment
Free text related to the user.

```yaml
Type: String
Parameter Sets: ID
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -company
The user's company.

```yaml
Type: String
Parameter Sets: ID
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -department
The user's department.

```yaml
Type: String
Parameter Sets: ID
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -directory_id
The ID of the OneLogin Directory the user will be assigned to.

```yaml
Type: Int32
Parameter Sets: ID
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -distinguished_name
The distinguished name of the user.

```yaml
Type: String
Parameter Sets: ID
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -email
A valid email for the user.

```yaml
Type: String
Parameter Sets: ID
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -external_id
The ID of the user in an external directory.

```yaml
Type: String
Parameter Sets: ID
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -firstname
The user's first name.

```yaml
Type: String
Parameter Sets: ID
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -group_id
The ID of the Group in OneLogin that the user will be assigned to.

```yaml
Type: String
Parameter Sets: ID
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -lastname
The user's last name.

```yaml
Type: String
Parameter Sets: ID
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -manager_ad_id
The ID of the user's manager in Active Directory.

```yaml
Type: Int32
Parameter Sets: ID
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -manager_user_id
The OneLogin User ID for the user's manager.

```yaml
Type: Int32
Parameter Sets: ID
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -mappings
Controls how mappings will be applied to the user on creation.
Defaults to async.

async: Mappings run after the API returns a response
sync: Mappings run before the API returns a response
disabled: Mappings don't run for this user.

```yaml
Type: String
Parameter Sets: (All)
Aliases:
Accepted values: async, sync, disabled

Required: False
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -member_of
The user's directory membership.

```yaml
Type: String
Parameter Sets: ID
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -password
The password to set for a user.

Not that in *current state* this cmdlet only supports plaintext passwords.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -phone
The E.164 format phone number for a user.

```yaml
Type: String
Parameter Sets: ID
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -role_ids
A list of OneLogin Role IDs the user will be assigned to.

```yaml
Type: String[]
Parameter Sets: ID
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -samaccountname
The user's Active Directory username.

```yaml
Type: String
Parameter Sets: ID
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -state
You may pass in either the string or integer value for the [OneLogin.UserState] enum.

0: Unapproved
1: Approved
2: Rejected
3: Unlicensed

```yaml
Type: UserState
Parameter Sets: ID
Aliases:
Accepted values: Unapproved, Approved, Rejected, Unlicensed

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -status
You may pass in either the string or integer value for the [OneLogin.UserStatus] enum.

0: Unactivated
1: Active
2: Suspended
3: Locked
4: Password expired
5: Awaiting password reset
7: Password Pending
8: Security questions required

```yaml
Type: UserStatus
Parameter Sets: ID
Aliases:
Accepted values: Unactivated, Active, Suspended, Locked, Password_Expired, Awaiting_Password_Reset, Unknown, Password_Pending, Security_Questions_Required

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -title
The user's job title.

```yaml
Type: String
Parameter Sets: ID
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -trusted_idp_id
The ID of the OneLogin Trusted IDP the user will be assigned to.

```yaml
Type: Int32
Parameter Sets: ID
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -username
A username for the user.

```yaml
Type: String
Parameter Sets: ID
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -userprincipalname
The principal name of the user.

```yaml
Type: String
Parameter Sets: ID
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -validate_policy
Will passwords validate against the User Policy?
Defaults to "true".

*Note: this is a **string***

```yaml
Type: String
Parameter Sets: (All)
Aliases:
Accepted values: true, false

Required: False
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### OneLogin.User

### System.String

### System.String[]

### OneLogin.UserState

### OneLogin.UserStatus

### System.Int32

## OUTPUTS

### OneLogin.User
## NOTES

## RELATED LINKS
