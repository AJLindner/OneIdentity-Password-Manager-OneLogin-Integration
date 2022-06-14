---
external help file: OneLoginByOneIdentity-help.xml
Module Name: OneLoginByOneIdentity
online version: https://github.com/AJLindner/OneIdentity-Password-Manager-OneLogin-Integration/blob/master/Docs/Invoke-OneLoginAPI.md
schema: 2.0.0
---

# Invoke-OneLoginAPI

## SYNOPSIS
Helper function that wraps Invoke-RestMethod and Invoke-WebRequest specifically for making REST calls to the OneLogin API.

## SYNTAX

```
Invoke-OneLoginAPI -Method <WebRequestMethod> -Endpoint <String> [-Body <Object>]
 [-QueryParameters <Hashtable>] [-Raw] [-AutoPaginate] [-MaxPageLimit <Int32>] [-Connection <Connection>]
 [<CommonParameters>]
```

## DESCRIPTION
This helper function wraps Invoke-RestMethod (or Invoke-WebRequest with the -Raw parameter) for use with the OneLogin REST API. Most cmdlets in this module run this cmdlet to perform actions against the provided OneLogin instance. You may use this cmdlet directly, if needed, to utilize any unsupported endpoints, return non type-cast REST responses, directly return raw webrequest responses, or otherwise make custom web requests utilizing your [OneLogin.Connection] connection.

When calling Invoke-OneLoginAPI, you can include query parameters directly in the -Endpoint string, and/or as a Hashtable with the -QueryParameters option. If the same Query Parameter exists in both attributes, the -QueryParameters hashtable will overwrite the -Endpoint string.

By default, Invoke-OneLoginAPI will use Invoke-RestMethod. This returns a Powershell auto-formatted custom object collection of the response contents. In Powershell 6.0 and forward, there are support options to follow rel links to support pagination. However, in Windows Powershell (5.1), that option is unavailable. In order to support both manual, and automatic pagination, the -Raw parameter will instead return the response from Invoke-WebRequest, which contains the response headers needed to follow pagination.

The -AutoPaginate parameter will automatically follow all rel links. By default, the page limit will be set to 100, but this can be overwritten with -MaxPageLimit, up to a max of 1000 (as supported by the OneLogin API). See the [OneLogin API Pagination Section] (https://developers.onelogin.com/api-docs/2/getting-started/using-query-parameters#pagination) for more details. By default, the -AutoPaginate option will parse the contents of all pages and return a collection of powershell-formatted custom objects. Use the -Raw parameter to return a collection of the raw webrequest responses.

## EXAMPLES

### Example 1
```powershell
PS C:\> Invoke-OneLoginAPI -Method "Get" -Endpoint "auth/rate_limit"

status                                                  data
------                                                  ----
@{error=False; code=200; type=success; message=Success} @{X-RateLimit-Limit=5000; X-RateLimit-Remaining=5000; X-RateLimit-Reset=3600}
```

A request for the OneLogin rate limit, using the default connection. Note that this response is different from the [OneLogin.APIRateLimit] object that is returned via the Get-OneLoginRateLimit cmdlet, since this is a raw REST response.

### Example 2
```powershell
PS C:\> Invoke-OneLoginAPI -Method Post -Endpoint "api/2/users" -Body @{username="testuser";firstname="test";lastname="user"}

trusted_idp_id         :
department             :
custom_attributes      : @{CustomField=; CustomField2=}
firstname              : test
invitation_sent_at     :
userprincipalname      :
directory_id           :
member_of              :
external_id            :
state                  : 1
updated_at             : 2022-01-24T21:54:25.840Z
[..................]
```

A request to create a new OneLogin User. The -Body parameter can either take a JSON string, or an object, which will be automatically converted via ConvertTo-JSON.

### Example 3
```powershell
PS C:\> Invoke-OneLoginAPI -Method Get -Endpoint "api/2/apps?name=*a*&auth_method=0" -QueryParameters @{auth_method=2;limit=2}

id                      : 1671479
visible                 : True
description             :
created_at              : 2022-02-09T14:15:17.764Z
auth_method             : 2
name                    : Salesforce
connector_id            : 29255
updated_at              : 2022-02-09T14:45:09.170Z
auth_method_description : SAML2.0

id                      : 1677993
visible                 : True
description             :
created_at              : 2022-02-17T14:11:36.530Z
auth_method             : 2
name                    : Google Analytics
connector_id            : 49108
updated_at              : 2022-02-17T16:43:20.331Z
auth_method_description : SAML2.0
```

Gets apps via a query. The auth_method (2) parameter in the -QueryParameters hashtable overwrites the auth_method query string (0) in the -Endpoint.

### Example 4
```powershell
PS C:\> Invoke-OneLoginAPI -Method Get -Endpoint "api/2/users" -AutoPaginate -MaxPageLimit 1000

samaccountname         : standarduser
username               : standarduser@ajlindner.xyz
activated_at           : 2022-03-08T13:29:05.605Z
firstname              : Standard
lastname               : User
invalid_login_attempts : 0
last_login             : 2022-03-07T17:20:09.498Z
password_changed_at    : 2021-12-08T21:30:13.054Z
phone                  :
created_at             : 2021-12-08T21:30:13.329Z
external_id            : 0e1afa2f-2781-4be1-b3d6-a7c1f0edfbff
id                     : 158402419
state                  : 1
member_of              : CN=DefenderUsers,OU=Groups,OU=Lab,DC=ajlindner,DC=local;CN=DL-CA - Aliso
                         Viejo,OU=Locations,OU=Groups,OU=Enterprise,DC=ajlindner,DC=local;CN=Manager,OU=RBAC,OU=Groups,OU=Enterprise,DC=ajlindner,DC=local;CN=PWM,OU=Groups,OU=Enterprise,DC=ajlindner,DC=local
directory_id           : 80670
locked_until           :
updated_at             : 2022-03-10T11:08:42.742Z
distinguished_name     : CN=Standard User,OU=Administrative,OU=Enterprise,DC=ajlindner,DC=local
invitation_sent_at     : 2021-12-08T21:46:06.641Z
status                 : 1
email                  : standarduser@ajlindner.xyz
group_id               : 487781

samaccountname         : helpdeskuser
username               : helpdeskuser@ajlindner.xyz
activated_at           : 2021-12-08T21:30:13.379Z
firstname              : Helpdesk
lastname               : User
invalid_login_attempts : 0
last_login             : 2022-03-08T14:40:37.823Z
password_changed_at    : 2021-12-08T21:30:13.088Z
phone                  :
created_at             : 2021-12-08T21:30:13.399Z
external_id            : 898ba478-25ba-4bda-acc8-30a7d2dd56bc
id                     : 158402420
state                  : 1
member_of              : CN=DL-OH - Cincinnatti,OU=Locations,OU=Groups,OU=Enterprise,DC=ajlindner,DC=local;CN=Support Agent - Level 2,OU=Groups,OU=Enterprise,DC=ajlindner,DC=local;CN=Support Agent,OU=RBAC,OU=Groups,OU=Enterprise,DC=ajlindner,DC=local
directory_id           : 80670
locked_until           :
updated_at             : 2022-03-08T14:40:38.274Z
distinguished_name     : CN=Helpdesk User,OU=IT,OU=Enterprise,DC=ajlindner,DC=local
invitation_sent_at     :
status                 : 1
email                  : helpdeskuser@ajlindner.xyz
group_id               : 487781
...
```

### Example 4
```powershell
PS C:\> Invoke-OneLoginAPI -Method Get -Endpoint "api/2/users" -Raw

StatusCode        : 200
StatusDescription : OK
Content           : [{"invalid_login_attempts":0,"distinguished_name":null,"phone":"+1 (256) 808-7598","directory_id":null,"external_id":null,"locked_until":null,"member_of":null,"state":1,"firstname":"AJ","group_id":nul...
RawContent        : HTTP/1.1 200 OK
                    current-page: 1
                    page-items: 100
                    status: 200 OK
                    total-count: 7
                    total-pages: 1
                    x-request-id: 623375EA-88355373-E494-0A0B03A2-01BB-17F3B6-13B2
                    x-xss-protection: 1; mode=block
                    stri...
Forms             :
Headers           : {[current-page, 1], [page-items, 100], [status, 200 OK], [total-count, 7]...}
Images            : {}
InputFields       : {}
Links             : {}
ParsedHtml        :
RawContentLength  : 5577
```

Returns the raw HTTP response.

## PARAMETERS

### -AutoPaginate
Follows all rel links to automatically page through responses.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -Body
Optional paramater for the WebRequest body. This can either be a JSON [string], or any [object] (like a hashtable) that will automatically get converted via ConvertTo-JSON.

```yaml
Type: Object
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName)
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
Default value: $Global:Connection
Accept pipeline input: False
Accept wildcard characters: False
```

### -Endpoint
The OneLogin API Endpoint you wish to invoke. This will be appended onto the BaseURL parameter of the -Connection. E.g., if $Connection.BaseURL = "https://api.US.onelogin.com", and the $endpoint is "auth/rate_limit", the URI that will be requested is "https://api.US.onelogin.com/auth/rate_limit"

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -MaxPageLimit
Sets the max limit per page when used with -Autopaginate. Default is 100, max is 1000.

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -Method
The WebRequestMethod for this request. Must be in the list:

Default, Get, Head, Post, Put, Delete, Trace, Options, Merge, Patch

```yaml
Type: WebRequestMethod
Parameter Sets: (All)
Aliases:
Accepted values: Default, Get, Head, Post, Put, Delete, Trace, Options, Merge, Patch

Required: True
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -QueryParameters
Provide Query Parameters to the Endpoint as a Hashtable, instead of in the endpoint string. These values overwrite the endpoint string if they both have the same parameter.

e.g. @{firstname = "Test" ; lastname = "User"}

```yaml
Type: Hashtable
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -Raw
Returns the raw [Microsoft.PowerShell.Commands.BasicHtmlWebResponseObject] web response(s) via Invoke-WebRequest, rather than the formatted powershell objects returned via Invoke-RestMethod.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### Microsoft.PowerShell.Commands.WebRequestMethod

### System.String

### OneLogin.Connection

## OUTPUTS

### System.Object
## NOTES

## RELATED LINKS
