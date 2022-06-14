<#
    .SYNOPSIS
    Authenticates a user via OneLogin MFA

    .DESCRIPTION
    This custom action script can be used in Password Manager as part of a sequence to Authenticate a user via MFA in OneLogin.

    No Activity UI is needed, this script will automatically generate the UI.

    All workflows that integrate with OneLogin should begin with a PWM_OneLogin_0_Configure_and_Connect Action before any other OneLogin actions.

    There should be a PWM_OneLogin_MFA_Authentication_1_Select_Device action directly before this.

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

    $VerificationMethod = $workflow.OneLogin.Authentication.Device.verification_method
    
    if ($VerificationMethod -eq "both") {
        if ($device.type_display_name -in $workflow.OneLogin.MagicLinkFactors) {
            $VerificationMethod = "Prompt"
        } else {
            $VerificationMethod = "OTP"
        }
    }
    
    $Workflow.OneLogin.VerificationMethod = $VerificationMethod

}

Function PostLoad($workflow,$activity) {
    
    $Device = $workflow.OneLogin.Authentication.Device

    $Verification_Controls = [Collections.Generic.List[QPM.Common.ActivityContexts.Controls.ControlInfo]]::new()

    $OTP = New-Object QPM.Common.ActivityContexts.Controls.TextBoxInfo
    $OTP.ID = "OTP"
    $OTP.Label = "Enter the OTP Code on your '$($Device.type_display_name)' device: '$($Device.user_display_name)'. Press Next when finished."

    $Prompt  = New-Object QPM.Common.ActivityContexts.Controls.LabelInfo
    $Prompt.ID = "Prompt"
    $Prompt.Label = "Please follow the prompt on your '$($Device.type_display_name)' device: '$($Device.user_display_name)'. Press Next when finished."

    switch ($Workflow.OneLogin.VerificationMethod) {
        "OTP" {
            $Verification_Controls.Add($OTP)
        }
        "Prompt" {
            $Verification_Controls.Add($Prompt)
        }
    }

    $Activity.Runtime.Controls = $Verification_Controls
   
}


Function PreExecuting($workflow,$activity) {

    switch ($Workflow.OneLogin.VerificationMethod) {
        "OTP" {
            $Entered_OTP = $activity.runtime.controls["OTP"].Value
            if ($Entered_OTP -eq '' ) {
                $Workflow.ActivityFailure("Please enter the OTP Code sent to your device.")
            }
            else {
                Try {
                    $Response = Resolve-OneLoginAuthentication -Authentication $workflow.OneLogin.Authentication -OTP $Entered_OTP -ErrorAction Stop
                } Catch {
                    $Workflow.ActivityFailure("There was an error verifying this device. Please try again.`n`n$_")
                }
            }
        }
        "Prompt" {
            Try {
                $Response = Resolve-OneLoginAuthentication -Authentication $workflow.OneLogin.Authentication -ErrorAction Stop
            } Catch {
                $Workflow.ActivityFailure("There was an error verifying this device. Please try again.`n`n$_")
            }
        }
    }

    If ($Response.Status -eq "accepted") {
        $workflow.ActivitySuccess()
    } Else {
        $workflow.ActivityFailure("Multifactor Authentication was not completed.")
    }
    
}