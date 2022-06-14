Function Get-OneLoginRateLimit {

    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $false)]        
        [OneLogin.Connection]
        $Connection = $Global:Connection
    )

    $Response = Invoke-OneLoginAPI -Method "Get" -Endpoint "auth/rate_limit" -Connection $Connection

    $RateLimit = [OneLogin.APIRateLimit]::New($Response.Data."X-RateLimit-Limit",$Response.Data."X-RateLimit-Remaining",$Response.Data."X-RateLimit-Reset")
    $Connection.RateLimit = $RateLimit

    Return $RateLimit

}