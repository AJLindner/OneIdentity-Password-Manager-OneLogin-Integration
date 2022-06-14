Function Get-LinkFromAPIResponse {

    [CmdletBinding()]
    param(

        [Parameter(Mandatory,ValueFromPipeline)]
        [Microsoft.PowerShell.Commands.BasicHtmlWebResponseObject]
        $Response,

        [Parameter(Mandatory = $false)]
        [ValidateSet("first","last","next")]
        [String]
        $Rel
    )

    if ($response.headers.keys -notcontains "link") {
        return $null
    }

    $Links = $Response.headers.link.split(",")

    $FormattedLinks = ForEach ($Link in $Links) {
        If ($link -ne '') {
            $Split = $Link.Split(";")
        
            [PSCustomObject]@{
                URL = $Split[0].TrimStart("<").TrimEnd(">")
                Rel = ($Split[1].Split("="))[1].Trim('"')
            }
        }
    }

    if ($PSBoundParameters.Keys -contains "Rel") {
        Return $FormattedLinks | Where-Object rel -eq $rel | Select-Object -expand url
    }
    else {
        Return $FormattedLinks
    }

}

Function Split-Uri {

    [CmdletBinding()]
    param(

        [Parameter(Mandatory,ValueFromPipeline)]
        [System.URI]
        $Uri
    
    )

    $Tenant = "$($URI.scheme)://$($URI.host)"
    $Endpoint = $URI.AbsolutePath
    $QueryString = $URI.Query
    $QueryParams = @{}
    If ($QueryString) {
        $Queries = ($QueryString.Split("?")).Split("&")
        ForEach ($Query in $Queries) {
            if ($query -ne '') {
                $SplitQuery = $Query.Split("=")
                $QueryParams.($SplitQuery[0]) = $SplitQuery[1]
            }
        }
    }

    Return [PSCustomObject]@{
        Tenant = $Tenant
        Endpoint = $Endpoint
        QueryString = $QueryString
        QueryParams = $QueryParams
    }

}

Function Join-Uri {

    [CmdletBinding()]
    param(

        [Parameter(Mandatory,ValueFromPipeline)]
        [Object]
        $SplitURI
    
    )

    If ($SplitURI.QueryParams.Count -gt 0) {
        $Queries = New-Object System.Collections.ArrayList
        
        ForEach ($Query in $SplitURI.QueryParams.GetEnumerator()) {
            $Queries.Add("$($Query.Name)=$($Query.Value)") | Out-Null
        }
    
        $Query = $Queries -Join "&"
        $SplitURI.QueryString = "?$Query"
    }
   
    Return "$($SplitURI.Tenant)$($SplitURI.Endpoint)$($SplitURI.QueryString)"
}

Function Resolve-OneLoginUri {

    [CmdletBinding()]
    param(

        [Parameter(Mandatory,ValueFromPipeline,ValueFromPipelineByPropertyName)]
        [String]
        $BaseURI,

        [Parameter(Mandatory,ValueFromPipelineByPropertyName)]
        [String]
        $Endpoint,

        [Parameter(Mandatory = $false,ValueFromPipelineByPropertyName)]
        [HashTable]
        $QueryParameters,

        [Parameter(Mandatory = $false,ValueFromPipelineByPropertyName)]
        [Boolean]
        $AutoPaginate,

        [Parameter(Mandatory = $false,ValueFromPipelineByPropertyName)]
        [Int]
        $MaxPageLimit
    
    )

    $SplitURI = Split-URI "$BaseURI/$Endpoint"

    If ($QueryParameters.count -gt 0) {
        
        ForEach ($Query in $QueryParameters.GetEnumerator()) {
            If ([bool]($Query.Value)) {
                $SplitURI.QueryParams.($Query.Name)=$Query.Value
            }
        }

    }

    If ($AutoPaginate) {
        ForEach ($PageQuery in @("Page","Limit","Cursor")) {
            If ($SplitURI.QueryParams.Keys -contains $PageQuery) {
                $SplitURI.QueryParams.Remove($PageQuery)
            }
        }
        $SplitURI.QueryParams.Page = 1
        $SplitURI.QueryParams.Limit = $MaxPageLimit
    }

    $URI = Join-URI $SplitURI

    Return $URI

}