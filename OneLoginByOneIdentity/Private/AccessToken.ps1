Function Get-OneLoginAccessToken {

    [CmdletBinding()]
    param(

        [Parameter(Mandatory,ValueFromPipelineByPropertyName)]
        [string]
        $ClientID,

        [Parameter(Mandatory,ValueFromPipelineByPropertyName)]
        [string]
        $ClientSecret,

        [Parameter(Mandatory,ValueFromPipelineByPropertyName)]
        [string]
        $BaseURL
    )

    # Encode Client ID & Client Secret in Base64
    $Base64Auth =[Convert]::ToBase64String([System.Text.Encoding]::UTF8.GetBytes("$($ClientID):$($ClientSecret)"))

    $TokenEndpoint = "$BaseURL/auth/oauth2/v2/token"

    $Headers = @{
        "Content-Type" = "application/json"
        "Authorization" = "Basic $Base64Auth"
    }

    $Body = @{
        "grant_type" = "client_credentials"
    } | ConvertTo-Json

    $Response = Invoke-RestMethod -Method POST -Uri $TokenEndpoint -Headers $Headers -Body $Body -UseBasicParsing

    Return [OneLogin.APIAccessToken]$Response
}

Function Revoke-OneLoginAccessToken {

    [CmdletBinding()]
    param(      

        [Parameter(Mandatory = $false)]        
        [OneLogin.Connection]
        $Connection = $Global:Connection
    
    )

    # Encode Client ID & Client Secret in Base64
    $Base64Auth =[Convert]::ToBase64String([System.Text.Encoding]::UTF8.GetBytes("$($Connection.ClientID):$($Connection.ClientSecret)"))

    $RevokeURL = "$($Connection.BaseURL)/auth/oauth2/revoke"

    $Headers = @{
        "Content-Type" = "application/json"
        "Authorization" = "Basic $Base64Auth"
    }

    $Body = @{
        "access_token" = $Connection.AccessToken.access_token
    } | ConvertTo-Json


    $Response = Invoke-RestMethod -Method POST -Uri $RevokeURL -Headers $Headers -Body $Body -UseBasicParsing

    Return $Response

}