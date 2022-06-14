<#
    .SYNOPSIS
    Authenticates a user via OneLogin MFA

    .DESCRIPTION
    This custom action script can be used in Password Manager as part of a sequence to Authenticate a user via MFA in OneLogin.

    No Activity UI is needed, this script will automatically generate the UI.

    All workflows that integrate with OneLogin should begin with a PWM_OneLogin_0_Configure_and_Connect Action before any other OneLogin actions.

    There should be a PWM_OneLogin_MFA_Authentication_2_Authenticate_Device action directly after this.

#>

Function PreLoad($workflow,$activity) {

    $ModulePath = $Workflow.OneLogin.ModulePath
    If (($ModulePath -ne '') -and ($null -ne $ModulePath)) {
        Try {
            Test-Path $ModulePath -ErrorAction Stop
        }
        Catch {
            $workflow.ActivityFailure("There was an error initializing the connection to OneLogin. Please contact your administrator.`n`n$_")
        }
        Import-Module $ModulePath
    } Else {
        Import-Module OneLoginByOneIdentity
    }
    
    $Global:Connection = $workflow.OneLogin.Connection

    $AD = $workflow.UserInfo.AccountInfo

    Try {
        $User = Get-OneLoginUser -Filter @{email=$AD.mail} -ErrorAction Stop
        $Workflow.OneLogin.User = $User
    } Catch {
        $workflow.ActivityFailure("Your OneLogin account could not be found. Please contact your administrator.")
    }

    $Devices = Get-OneLoginDevices -User $Workflow.OneLogin.User

    $ValidDevices = $Devices | Where-Object {$_.auth_factor_name -in [OneLogin.AuthFactor]::verification_methods.keys}
    
    If ($ValidDevices.count -eq 0) {
        $workflow.ActivityFailure("You do not have any valid OneLogin Protect, Email, SMS, Authenticator, or OneLogin Voice devices registered for MFA in OneLogin. Please contact your administrator.")
    } Else {
        $Workflow.OneLogin.Devices= $ValidDevices
    }
    
}

Function PostLoad($workflow,$activity) {
    
    $Devices_Controls = [Collections.Generic.List[QPM.Common.ActivityContexts.Controls.ControlInfo]]::new()
    $Devices_RadioButtons = New-Object QPM.Common.ActivityContexts.Controls.RadioButtonListInfo
    $Devices_Options = New-Object QPM.Common.ActivityContexts.Controls.ListOptions
    
    ForEach ($Device in $Workflow.OneLogin.Devices) {
        $i += 1
        $Devices_Options.Add("$($Device.device_id)", "$($Device.user_display_name) ($($Device.type_display_name))")
    }

    $Devices_RadioButtons.ID = "Devices"
    $Devices_RadioButtons.Label = "Select a Device for Multifactor Authentication"
    $Devices_RadioButtons.Text= "Devices"
    $Devices_RadioButtons.Options = $Devices_Options
    $Devices_RadioButtons.Value = $Devices_Options[0].Value

    $Devices_Controls.Add($Devices_RadioButtons)

    $Activity.Runtime.Controls = $Devices_Controls
}


Function PreExecuting($workflow,$activity) {

    $ChosenDevice = $Workflow.OneLogin.Devices | Where-Object device_id -eq $activity.runtime.controls["Devices"].Value
    
    $Authentication = Send-OneLoginAuthentication -Device $ChosenDevice
    $Workflow.OneLogin.Authentication = $Authentication
    
}