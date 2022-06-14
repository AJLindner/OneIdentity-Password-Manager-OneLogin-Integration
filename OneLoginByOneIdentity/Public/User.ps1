Function Get-OneLoginUser {
    
    [CmdletBinding(DefaultParameterSetName="Filter")]
    param(
        [Parameter(Mandatory = $false, ValueFromPipeline, ParameterSetName="Filter")]
        [hashtable]
        $Filter,

        [Parameter(Mandatory = $false, ValueFromPipeline, ParameterSetName="Filter")]
        [Switch]
        $All,

        [Parameter(Mandatory = $false, ValueFromPipeline, ParameterSetName="ID")]
        [string]
        $ID,

        [Parameter(Mandatory = $false, ValueFromPipeline, ParameterSetName="Filter")]
        [Switch]
        $Raw = $false,

        [Parameter(Mandatory = $false)]        
        [OneLogin.Connection]
        $Connection = $Global:Connection
    )

    $Endpoint = "api/2/users"
    If ($ID) {
        $Endpoint += "/$id"
    }

    $RequestParams = @{
        Method = "Get"
        Endpoint = $Endpoint
        QueryParameters = $Filter
        Connection = $Connection
        Raw = $Raw
    }

    If ($All) {
        $RequestParams.AutoPaginate = $true
        $RequestParams.MaxPageLimit = 1000
    }

    $Response = Invoke-OneLoginAPI @RequestParams

    If ($Raw) {
        Return $Response
    }

    If ($Response.Count -eq 0) {
        Write-Error "No user found at endpoint $Endpoint"
        Return $null
    }

    $Users = ForEach ($User in $Response) {
        if ($User.custom_attributes) {
            $CustomAttributesHashtable = @{}
            $User.custom_attributes.psobject.properties | ForEach-Object { 
                $CustomAttributesHashtable[$_.name] = $_.value
            }

            $User.custom_attributes = $CustomAttributesHashtable
        }
        $User
    }
    

    Return [OneLogin.User[]]$Users
}

Function New-OneLoginUser {

    [CmdletBinding(DefaultParameterSetName="username")]
    param(
        [Parameter(Mandatory,ValueFromPipelineByPropertyName,ParameterSetName="email")]
        [Parameter(Mandatory = $false,ValueFromPipelineByPropertyName,ParameterSetName="username")]
        [string]
        $email,

        [Parameter(Mandatory,ValueFromPipelineByPropertyName,ParameterSetName="username")]
        [Parameter(Mandatory = $false,ValueFromPipelineByPropertyName,ParameterSetName="email")]  
        [string]
        $username,

        [Parameter(Mandatory = $false, ValueFromPipelineByPropertyName)]
        [ValidateSet("async","sync","disabled")]
        [String]
        $mappings = "async",

        [Parameter(Mandatory = $false, ValueFromPipelineByPropertyName)]
        [ValidateSet("true","false")]
        [string]
        $validate_policy = "true",

        [Parameter(Mandatory = $false, ValueFromPipelineByPropertyName)]
        [String]
        $password,

        [Parameter(Mandatory = $false, ValueFromPipelineByPropertyName)]
        [String]
        $group_id,

        [Parameter(Mandatory = $false, ValueFromPipelineByPropertyName)]
        [String[]]
        $role_ids,

        [Parameter(Mandatory = $false, ValueFromPipelineByPropertyName)]
        [string]
        $firstname,

        [Parameter(Mandatory = $false, ValueFromPipelineByPropertyName)]
        [string]
        $lastname,

        [Parameter(Mandatory = $false, ValueFromPipelineByPropertyName)]
        [string]
        $title,

        [Parameter(Mandatory = $false, ValueFromPipelineByPropertyName)]
        [string]
        $department,

        [Parameter(Mandatory = $false, ValueFromPipelineByPropertyName)]
        [string]
        $company,

        [Parameter(Mandatory = $false, ValueFromPipelineByPropertyName)]
        [string]
        $comment,

        [Parameter(Mandatory = $false, ValueFromPipelineByPropertyName)]
        [string]
        $phone,

        [Parameter(Mandatory = $false, ValueFromPipelineByPropertyName)]
        [OneLogin.UserState]
        $state,

        [Parameter(Mandatory = $false, ValueFromPipelineByPropertyName)]
        [OneLogin.UserStatus]
        $status,

        [Parameter(Mandatory = $false, ValueFromPipelineByPropertyName)]
        [int]
        $directory_id,

        [Parameter(Mandatory = $false, ValueFromPipelineByPropertyName)]
        [int]
        $trusted_idp_id,

        [Parameter(Mandatory = $false, ValueFromPipelineByPropertyName)]
        [int]
        $manager_ad_id,

        [Parameter(Mandatory = $false, ValueFromPipelineByPropertyName)]
        [int]
        $manager_user_id,

        [Parameter(Mandatory = $false, ValueFromPipelineByPropertyName)]
        [string]
        $samaccountname,

        [Parameter(Mandatory = $false, ValueFromPipelineByPropertyName)]
        [string]
        $member_of,

        [Parameter(Mandatory = $false, ValueFromPipelineByPropertyName)]
        [string]
        $userprincipalname,

        [Parameter(Mandatory = $false, ValueFromPipelineByPropertyName)]
        [string]
        $distinguished_name,

        [Parameter(Mandatory = $false, ValueFromPipelineByPropertyName)]
        [string]
        $external_id,
    
        [Parameter(Mandatory = $false)]
        [OneLogin.Connection]
        $Connection = $Global:Connection
    )

    $Endpoint = "api/2/users"

    # Handle Query Parameters
    $QueryDetails = @{
        mappings = $mappings
        validate_policy = $validate_policy
    }

    # Handle Password
    if ($Password) {
        $PSBoundParameters.password_confirmation = $Password
    }

    # Remove non-body params
    (@("Connection","mappings","validate_policy","id","user") + [System.Management.Automation.Cmdlet]::CommonParameters) | ForEach-Object {
        $PSBoundParameters.Remove($_) | out-null
    }

    $Response = Invoke-OneLoginAPI -Method Post -Endpoint $Endpoint -Body $PSBoundParameters -QueryParameters $QueryDetails -Connection $Connection

    Return [OneLogin.User]($Response | Select-Object * -ExcludeProperty custom_attributes)

}

Function Remove-OneLoginUser {
    
    [CmdletBinding(DefaultParameterSetName="User")]
    param(
        [Parameter(Mandatory = $true, ValueFromPipeline, ParameterSetName="User")]
        [OneLogin.User]
        $User,

        [Parameter(Mandatory = $true, ValueFromPipelineByPropertyName, ParameterSetName="ID")]
        [string]
        $ID,

        [Parameter(Mandatory = $false)]        
        [OneLogin.Connection]
        $Connection = $Global:Connection
    )

    if ($PSCmdlet.ParameterSetName -eq "User") {
        $ID = $User.id
    }

    $Endpoint = "api/2/users/$ID"

    $Response = Invoke-OneLoginAPI -Method Delete -Endpoint $Endpoint -Connection $Connection

    Return $Response
}

Function Set-OneLoginUser {

    [CmdletBinding(DefaultParameterSetName="User")]
    param(
        [Parameter(Mandatory = $false, ValueFromPipeline, ParameterSetName="User")]
        [OneLogin.User]
        $User,

        [Parameter(Mandatory = $false, ValueFromPipelineByPropertyName)]
        [ValidateSet("async","sync","disabled")]
        [String]
        $mappings = "async",

        [Parameter(Mandatory = $false, ValueFromPipelineByPropertyName)]
        [ValidateSet("true","false")]
        [string]
        $validate_policy = "true",

        [Parameter(Mandatory = $false, ValueFromPipelineByPropertyName)]
        [String]
        $password,

        [Parameter(Mandatory = $true, ParameterSetName="ID")]
        [string]
        $ID,

        [Parameter(Mandatory = $false, ParameterSetName="ID")]
        [string]
        $email,

        [Parameter(Mandatory = $false, ParameterSetName="ID")] 
        [string]
        $username,

        [Parameter(Mandatory = $false, ParameterSetName="ID")]
        [String]
        $group_id,

        [Parameter(Mandatory = $false, ParameterSetName="ID")]
        [String[]]
        $role_ids,

        [Parameter(Mandatory = $false, ParameterSetName="ID")]
        [string]
        $firstname,

        [Parameter(Mandatory = $false, ParameterSetName="ID")]
        [string]
        $lastname,

        [Parameter(Mandatory = $false, ParameterSetName="ID")]
        [string]
        $title,

        [Parameter(Mandatory = $false, ParameterSetName="ID")]
        [string]
        $department,

        [Parameter(Mandatory = $false, ParameterSetName="ID")]
        [string]
        $company,

        [Parameter(Mandatory = $false, ParameterSetName="ID")]
        [string]
        $comment,

        [Parameter(Mandatory = $false, ParameterSetName="ID")]
        [string]
        $phone,

        [Parameter(Mandatory = $false, ParameterSetName="ID")]
        [OneLogin.UserState]
        $state,

        [Parameter(Mandatory = $false, ParameterSetName="ID")]
        [OneLogin.UserStatus]
        $status,

        [Parameter(Mandatory = $false, ParameterSetName="ID")]
        [int]
        $directory_id,

        [Parameter(Mandatory = $false, ParameterSetName="ID")]
        [int]
        $trusted_idp_id,

        [Parameter(Mandatory = $false, ParameterSetName="ID")]
        [int]
        $manager_ad_id,

        [Parameter(Mandatory = $false, ParameterSetName="ID")]
        [int]
        $manager_user_id,

        [Parameter(Mandatory = $false, ParameterSetName="ID")]
        [string]
        $samaccountname,

        [Parameter(Mandatory = $false, ParameterSetName="ID")]
        [string]
        $member_of,

        [Parameter(Mandatory = $false, ParameterSetName="ID")]
        [string]
        $userprincipalname,

        [Parameter(Mandatory = $false, ParameterSetName="ID")]
        [string]
        $distinguished_name,

        [Parameter(Mandatory = $false, ParameterSetName="ID")]
        [string]
        $external_id,
    
        [Parameter(Mandatory = $false)]
        [OneLogin.Connection]
        $Connection = $Global:Connection
    )

    if ($PSCmdlet.ParameterSetName -eq "User") {
        $ID = $User.id
        $Body = $User | Select-Object email, username, group_id, role_ids, firstname, lastname, title, department, company, comment, phone, state, status, directory_id, trusted_idp_id, manager_ad_id, manager_user_id, samaccountname, member_of, userprincipalname, distinguished_name, external_id
        
    }
    else {
        (@("Connection","mappings","validate_policy","id","user") + [System.Management.Automation.Cmdlet]::CommonParameters) | ForEach-Object {
            $PSBoundParameters.Remove($_) | out-null
        }
    
        $Body = $PSBoundParameters
    }

    $Endpoint = "api/2/users/$ID"

    # Handle Query Parameters
    $QueryDetails = @{
        mappings = $mappings
        validate_policy = $validate_policy
    }

    # Handle Password
    if ($Password) {
        $Body.password_confirmation = $Password
    }

    $Response = Invoke-OneLoginAPI -Method Put -Endpoint $Endpoint -Body $Body -QueryParameters $QueryDetails -Connection $Connection

    Return [OneLogin.User]($Response | Select-Object * -ExcludeProperty custom_attributes)

}