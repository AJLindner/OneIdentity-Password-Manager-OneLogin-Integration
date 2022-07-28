Function Send-OneLoginAuthentication {
    
    [CmdletBinding()]
    param(
      
        [Parameter(Mandatory, ValueFromPipeline)]        
        [OneLogin.Device]
        $Device,
       
        [Parameter(Mandatory = $false)]
        [ValidateRange(120,900)]     
        [Int]
        $ValidFor = 120,

        [Parameter(Mandatory = $false)]        
        [ValidateLength(1,160)]     
        [String]
        $CustomMessage = $null,
        
        [Parameter(Mandatory = $false)]            
        [Object]
        $OneLoginConnection = $Global:Connection
    )


    $Endpoint = "api/2/mfa/users/$($Device.User.id)/verifications"   

    $Body = @{
        device_id = $Device.device_id
        expires_in = $ValidFor
    }
    
    if ($null -ne $CustomMessage) {
        $Body.custom_message = $CustomMessage
    }

    $Response = Invoke-OneLoginAPI -Method "POST" -Endpoint $Endpoint -Body $Body -Connection $Connection
    
    $Authentication = [OneLogin.Authentication]$Response
    $Authentication.Device = $Device
    $Authentication.expires_at = (Get-Date).AddSeconds($ValidFor)
    $Authentication.Status = "Pending"

    Return $Authentication

}

Function Resolve-OneLoginAuthentication {
    
    [CmdletBinding(DefaultParameterSetName = 'Prompt')]
    param(

        [Parameter(Mandatory, ValueFromPipeline)]
        [OneLogin.Authentication]
        $Authentication,

        [Parameter(Mandatory, ParameterSetName = "OTP")]    
        [String]
        $OTP,

        [Parameter(Mandatory = $false)]            
        [int]
        $Timeout = 120,

        [Parameter(Mandatory = $false)]
        [OneLogin.Connection]
        $OneLoginConnection = $Global:Connection

    )

    if ($Authentication.expires_at.datetime -le (Get-Date)) {
        Throw "The provided Authentication is expired. Please issue a new Authentication trigger with Send-OneLoginAuthentication"
    }

    $APIParams = @{
        Endpoint = "api/2/mfa/users/$($Authentication.user_id)/verifications/$($Authentication.id)"
        Connection = $Connection
    }

    switch ($PSCmdlet.ParameterSetName) {
        "prompt" {
            if ($Authentication.Device.verification_method -notin @($PSCmdlet.ParameterSetName,"both")) {
                Throw "Devices of type $($Authentication.auth_factor_name) require the user's OTP to authenticate. Please retry with the -OTP parameter."
            }
            $APIParams.Method = "Get"

            $Timer = [system.diagnostics.stopwatch]::StartNew()
            Do {
                $Response = Invoke-OneLoginAPI @APIParams
                Write-Verbose "Time Elapsed : $([math]::round($timer.elapsedMilliseconds / 1000,0)) `t Status : $($Response.status)"
                Start-Sleep -Seconds 1
            } Until (
                # User Responds to Push/Voice prompt, Request times out, or Authentication Expires
                ($Response.Status -ne "pending") `
                -or ([math]::round($timer.elapsedMilliseconds / 1000,0) -ge $Timeout) `
                -or ($Authentication.expires_at.datetime -le (Get-Date))
            )
            
        }
        "OTP" {
            if ($Authentication.Device.verification_method -notin @($PSCmdlet.ParameterSetName,"both")) {
                Throw "Devices of type $($Authentication.auth_factor_name) must authenticate via user confirmation, no OTP is needed. Please retry without the -OTP parameter."
            }
            
            $Body = @{
                otp = $otp
            }

            If ($Authentication.auth_factor_name = "Google Authenticator") {
                $Body.device_id = $Authentication.device_id
            }
            
            $APIParams.Method = "Put"
            $APIParams.Body = $Body

            $Response = Invoke-OneLoginAPI @APIParams
            
        }
    }

    $Authentication.Status = $Response.status
    Return $Authentication

}

Function New-OneLoginTemporaryOTP {
    [CmdletBinding()]
    param(
      
        [Parameter(Mandatory, ValueFromPipeline)]        
        [OneLogin.User]
        $User,
        
        [Parameter(Mandatory = $false)]            
        [Int]
        [ValidateRange(120,259200)]
        $ValidFor = 259200,

        [Parameter(Mandatory = $false)]            
        [bool]
        $Reusable = $false,

        [Parameter(Mandatory = $false)]            
        [Object]
        $OneLoginConnection = $Global:Connection
    
    )

    $Endpoint = "api/2/mfa/users/$($User.id)/mfa_token"

    $Body = @{
        expires_in = 120
        reusable = $true
    }

    $Response = Invoke-OneLoginAPI -Method "Post" -Endpoint $Endpoint -Body $Body -Connection $Connection

    Return $Response
}