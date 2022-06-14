Function Connect-OneLogin {

    [CmdletBinding()]
    param(

        [Parameter(Mandatory,ValueFromPipelineByPropertyName)]
        [string]
        $ClientID,

        [Parameter(Mandatory,ValueFromPipelineByPropertyName)]
        [string]
        $ClientSecret,

        [Parameter(Mandatory,ValueFromPipelineByPropertyName)]
        [OneLogin.Region]
        $Region
    )

    $Connection = [OneLogin.Connection]::New($ClientID,$ClientSecret,$Region)

    $Connection.AccessToken = Get-OneLoginAccessToken -ClientID $ClientID -ClientSecret $ClientSecret -BaseURL $Connection.BaseURL
    $Connection.Headers = @{
        "Content-Type" = "application/json"
        "Authorization" = "Bearer $($Connection.AccessToken.access_token)"
    }
    
    $Global:Connection = $Connection

    Get-OneLoginRateLimit | Out-Null

    Return $Connection
}

Function Disconnect-OneLogin {
    
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $false)]        
        [OneLogin.Connection]
        $Connection = $Global:Connection
    )

    $Response = Revoke-OneLoginAccessToken -Connection $Connection
    $Connection.AccessToken = $null
    $Connection.Headers = @{}
    $Connection.RateLimit = $null

    Return $Response

}

Function Reset-OneLoginConnection {
    
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $false)]        
        [OneLogin.Connection]
        $Connection = $Global:Connection
    )

    if ($Global:Connection.AccessToken.expires_at.LocalDateTime -le (Get-Date)) {
        Connect-OneLogin -Connection $Connection | out-null
    }

    Return $Connection

}

Function Invoke-OneLoginAPI {

    [CmdletBinding()]
    param(

        [Parameter(Mandatory,ValueFromPipelineByPropertyName)]
        [Microsoft.PowerShell.Commands.WebRequestMethod]
        $Method,

        [Parameter(Mandatory,ValueFromPipelineByPropertyName)]
        [string]
        $Endpoint,

        [Parameter(Mandatory = $false,ValueFromPipelineByPropertyName)]
        [object]
        $Body,

        [Parameter(Mandatory = $false,ValueFromPipelineByPropertyName)]
        [Hashtable]
        $QueryParameters = @{},

        [Parameter(Mandatory = $false,ValueFromPipelineByPropertyName)]
        [Switch]
        $Raw,

        [Parameter(Mandatory = $false,ValueFromPipelineByPropertyName,ParameterSetName="Autopaginate")]
        [switch]
        $AutoPaginate,

        [Parameter(Mandatory = $false,ValueFromPipelineByPropertyName,ParameterSetName="Autopaginate")]
        [int]
        $MaxPageLimit = 100,

        [Parameter(Mandatory = $False)]
        [OneLogin.Connection]
        $Connection = $Global:Connection
    )

    # Build Web Request
    $URI = Resolve-OneLoginURI -BaseURI $Connection.BaseURL -Endpoint $Endpoint -QueryParameters $QueryParameters -AutoPaginate $AutoPaginate -MaxPageLimit $MaxPageLimit

    $RequestParams = @{
        Uri = $URI.ToLower()
        Method = $Method
        Headers = $Connection.Headers
        UseBasicParsing = $true
    }

    If ($null -ne $Body) {
        If ($Body.GetType().Name -ne "String") {
            $RequestParams.Body = ($Body | ConvertTo-Json)
        } else {
            $RequestParams.Body = $Body
        }
    }

    # Make Web Request
    If ($AutoPaginate) {

        If ($Method -ne "GET") {
            Throw {"Pagination is only supported on GET requests."}
        }

        $Responses = New-Object System.Collections.ArrayList

        Do {
            $Response = Invoke-WebRequest @RequestParams
            If ($null -ne $Response.Content) {
                $NextURI = Get-LinkFromAPIResponse -Response $Response -Rel Next
                $Responses.Add($Response) | Out-Null
                $RequestParams = @{
                    Uri = $NextUri
                    Method = $Method
                    Headers = $Connection.Headers
                    UseBasicParsing = $true
                }
            }
        } Until (
            $null -eq $NextUri
        )
        
        If ($Raw) {
            Return $Responses
        } Else {
            Return ($Response.Content | ConvertFrom-JSON)
        }
    }
    ElseIf ($Raw) {
        $Response = Invoke-WebRequest @RequestParams
    } Else {
        $Response = Invoke-RestMethod @RequestParams
    }

    Return $Response
}
