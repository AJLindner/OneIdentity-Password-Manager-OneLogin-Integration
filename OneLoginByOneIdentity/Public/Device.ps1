Function Get-OneLoginDevices {
    
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, ValueFromPipeline)]
        [OneLogin.User]
        $User,

        [Parameter(Mandatory = $false)]        
        [OneLogin.Connection]
        $Connection = $Global:Connection
    )

    $Endpoint = "api/2/mfa/users/$($User.id)/devices"
    
    $Response = Invoke-OneLoginAPI -Method "GET" -Endpoint $Endpoint -Connection $Connection
    
    $Devices = ForEach ($Device in $Response) {
        # Not exactly sure why this needs to be cast multiple times
        $OLDevice = ($Device | Select-Object -Property *,@{label="is_default";expression={$_.default}} -ExcludeProperty default)
        $OLDevice | Add-Member -MemberType NoteProperty -Name User -Value $User
        [OneLogin.Device]$OLDevice

    }

    Return $Devices

}

Function Get-OneLoginAuthFactors {
    
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, ValueFromPipeline)]
        [OneLogin.User]
        $User,

        [Parameter(Mandatory = $false)]        
        [OneLogin.Connection]
        $Connection = $Global:Connection
    )

    $Endpoint = "api/2/mfa/users/$($User.id)/factors"
    
    $Response = Invoke-OneLoginAPI -Method "GET" -Endpoint $Endpoint -Connection $Connection

    Return [OneLogin.AuthFactor[]]$Response

}

Function Register-OneLoginDevice {

    [CmdletBinding()]
    param(
        [Parameter(Mandatory, ValueFromPipeline)]
        [OneLogin.User]
        $User,

        [Parameter(Mandatory)]
        [OneLogin.AuthFactor]
        $AuthFactor,

        [Parameter(Mandatory)]
        [String]
        $DisplayName,

        [Parameter(Mandatory = $false)]
        [ValidateRange(120,900)]     
        [Int]
        $ValidFor = 120,

        [Parameter(Mandatory = $false)]        
        [ValidateLength(1,160)]     
        [String]
        $CustomMessage = $null,

        [Parameter(Mandatory = $false)]           
        [Bool]
        $Verified = $false,

        [Parameter(Mandatory = $false)]        
        [OneLogin.Connection]
        $Connection = $Global:Connection
    )

    $Endpoint = "api/2/mfa/users/$($User.id)/registrations"

    $Body = @{
        factor_id = $AuthFactor.factor_id
        display_name = $DisplayName
        expires_in = $ValidFor
        verified = $Verified
    }

    if ($CustomMessage) {
        $Body.custom_message = $CustomMessage
    }

    $Response = Invoke-OneLoginAPI -Method Post -Endpoint $Endpoint -Body $Body -Connection $Connection

    if ($response.factor_data) {
        $response.factor_data = ($response.factor_data | ConvertTo-HashTable)
    }

    $Registration = [OneLogin.DeviceRegistration]$Response
    $Registration.user = $User
    $Registration.authFactor = $AuthFactor

    if ($null -eq $Registration.expires_at) {
        $Registration.expires_at = [System.DateTimeOffset]::New((Get-date).AddSeconds($ValidFor))
    }
    Return $Registration

}

Function Confirm-OneLoginDeviceRegistration {
    
    [CmdletBinding(DefaultParameterSetName = "Prompt")]
    param(

        [Parameter(Mandatory, ValueFromPipeline)]
        [OneLogin.DeviceRegistration]
        $DeviceRegistration,

        [Parameter(Mandatory, ParameterSetName = "OTP")]    
        [String]
        $OTP,

        [Parameter(Mandatory = $false)]            
        [int]
        $Timeout = 120,

        [OneLogin.Connection]
        $OneLoginConnection = $Global:Connection
    )

    if ($DeviceRegistration.Status -eq "Accepted") {
        $Devices = Get-OneLoginDevices -User $DeviceRegistration.user
        $Device = $Devices | Where-Object device_id -eq $DeviceRegistration.device_id
        Return $Device
    }

    if ($null -ne $DeviceRegistration.expires_at) {
        if ((Get-Date).ToUniversalTime() -ge $DeviceRegistration.expires_at.UTCDateTime) {
            Throw "The registration has expired. You must generate a new device registration."
        }
    }

    $APIParams = @{
        Endpoint = "api/2/mfa/users/$($DeviceRegistration.user.id)/registrations/$($DeviceRegistration.id)"
        Connection = $Connection
    }

    switch ($PSCmdlet.ParameterSetName) {
        "prompt" {
            if ($DeviceRegistration.AuthFactor.verification_method -notin @($PSCmdlet.ParameterSetName,"both")) {
                Throw "Devices of type $($DeviceRegistration.AuthFactor.verification_method) require the user's OTP to authenticate. Please retry with the -OTP parameter."
            }

            $APIParams.Method = "Get"

            $Timer = [system.diagnostics.stopwatch]::StartNew()
            Do {

                if ($null -ne $DeviceRegistration.expires_at) {
                    if ((Get-Date).ToUniversalTime() -ge $DeviceRegistration.expires_at.UTCDateTime) {
                        Throw "The registration has expired. You must generate a new device registration."
                    }
                }

                $Response = Invoke-OneLoginAPI @APIParams
                Write-Verbose "Time Elapsed : $([math]::round($timer.elapsedMilliseconds / 1000,0)) `t Status : $($Response.status)"
                Start-Sleep -Seconds 1
            } Until (
                # User Responds to Push/Voice prompt, Request times out, or Authentication Expires
                ($Response.Status -ne "pending") `
                -or ([math]::round($timer.elapsedMilliseconds / 1000,0) -ge $Timeout)
            )
            if ([math]::round($timer.elapsedMilliseconds / 1000,0) -ge $Timeout) {
                Throw "The verification of this request has timed out. Please try again."
            }
            
        }
        "OTP" {
            if ($DeviceRegistration.AuthFactor.verification_method -notin @($PSCmdlet.ParameterSetName,"both")) {
                Throw "Devices of type $($Authentication.auth_factor_name) must authenticate via user confirmation, no OTP is needed. Please retry without the -OTP parameter."
            }
            
            $Body = @{
                otp = $otp
            }
            
            $APIParams.Method = "Put"
            $APIParams.Body = $Body

            $Response = Invoke-OneLoginAPI @APIParams
            
        }
    }    

    switch ($Response.Status) {
        "Pending" {
            Throw "The provided OTP $otp is incorrect. You may try again until the registration expires."
        }
        "Rejected" {
            Throw "This device registration has been rejected, or has expired. You must generate a new device registration."
        }
        "Accepted" {
            $Devices = Get-OneLoginDevices -User $DeviceRegistration.user
            $Device = $Devices | Where-Object device_id -eq $Response.device_id
            Return $Device
        }

    }    
    
}

Function Unregister-OneLoginDevice {
    
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, ValueFromPipeline)]
        [OneLogin.Device]
        $Device,

        [Parameter(Mandatory = $false)]        
        [OneLogin.Connection]
        $Connection = $Global:Connection
    )

    $Endpoint = "api/2/mfa/users/$($Device.user.id)/devices/$($Device.device_id)"
    
    $Response = Invoke-OneLoginAPI -Method "Delete" -Endpoint $Endpoint -Connection $Connection

    Return $Response
}