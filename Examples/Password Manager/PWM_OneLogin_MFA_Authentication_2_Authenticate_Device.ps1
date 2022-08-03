<#
    .SYNOPSIS
    Authenticates a user via OneLogin MFA

    .DESCRIPTION
    This custom action script can be used in Password Manager as part of a sequence to Authenticate a user via MFA in OneLogin.

    In this step, the user is prompted to either enter their otp, or complete a push authentication, depending on the selected Security Factor.

    No Activity UI is needed, this script will automatically generate the UI.

    All workflows that integrate with OneLogin should begin with a PWM_OneLogin_0_Configure_and_Connect Action before any other OneLogin actions.

    There should be a PWM_OneLogin_MFA_Authentication_1_Select_Device action directly before this.

#>



Function PreLoad($workflow,$activity) {

    # Set Execution Policy for this process to avoid unsigned code errors
    Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass -Force

    # Set the Security Protocol to TLS 1.2
    [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

    $ModulePath = $Workflow.OneLogin.ModulePath
    If (($ModulePath -ne '') -and ($null -ne $ModulePath)) {
        Try {
            Test-Path $ModulePath -ErrorAction Stop
        }
        Catch {
            $workflow.ActivityFailure("There was an error initializing the connection to OneLogin. Please contact your administrator. [$_]")
        }
        Import-Module $ModulePath
    } Else {
        Import-Module OneLoginByOneIdentity
    }
    
    $Global:Connection = $workflow.OneLogin.Connection

    $Device = $Workflow.OneLogin.ChosenDevice
    $VerificationMethod = $Device.verification_method
    
    if ($VerificationMethod -eq "both") {
        if ($device.type_display_name -in $workflow.OneLogin.MagicLinkFactors) {
            $VerificationMethod = "Prompt"
        } else {
            $VerificationMethod = "OTP"
        }
    }

    $Workflow.OneLogin.VerificationMethod = $VerificationMethod
       
    If ($VerificationMethod -eq "OTP") {
        Try {
            $Authentication = Send-OneLoginAuthentication -Device $Device
            $Workflow.OneLogin.Authentication = $Authentication
        } Catch {
            $workflow.ActivityFailure("There was an error initializing the Authentication request. [$_]")
        }
    }

}

Function PostLoad($workflow,$activity) {
    
    $Device = $Workflow.OneLogin.ChosenDevice

    $Verification_Controls = [Collections.Generic.List[QPM.Common.ActivityContexts.Controls.ControlInfo]]::new()

    $OTPLabel  = New-Object QPM.Common.ActivityContexts.Controls.LabelInfo
    $OTPLabel.ID = "OTPLabel"
    $OTPLabel.Label = "Enter the Confirmation Code from your '$($Device.type_display_name)' Authentication Factor: '$($Device.user_display_name)', and press Continue, or press Back to select a different Authentication Factor."

    $OTP = New-Object QPM.Common.ActivityContexts.Controls.TextBoxInfo
    $OTP.ID = "OTP"
    $OTP.Label = "OTP"

    $Prompt  = New-Object QPM.Common.ActivityContexts.Controls.LabelInfo
    $Prompt.ID = "Prompt"
    $Prompt.Label = "Press Continue to send a Push Notification to your '$($Device.type_display_name)' Authentication Factor: '$($Device.user_display_name)', or press Back to select a different Authentication Factor."

    switch ($Workflow.OneLogin.VerificationMethod) {
        "OTP" {
            $Verification_Controls.Add($OTPLabel)
            $Verification_Controls.Add($OTP)
        }
        "Prompt" {
            $Verification_Controls.Add($Prompt)
        }
    }

    $Activity.Runtime.Controls = $Verification_Controls
   
}

Function PreExecuting($workflow,$activity) {

    # Set Execution Policy for this process to avoid unsigned code errors
    Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass -Force

    switch ($Workflow.OneLogin.VerificationMethod) {
        "OTP" {
            $Entered_OTP = $activity.runtime.controls["OTP"].Value
            if ($Entered_OTP -eq '' ) {
                $Workflow.ActivityFailure("Please enter the OTP Code from your chosen Authentication Factor.")
            }
            else {
                Try {
                    $Response = Resolve-OneLoginAuthentication -Authentication $workflow.OneLogin.Authentication -OTP $Entered_OTP -ErrorAction Stop
                } Catch {
                    $Workflow.ActivityFailure("There was an unexpected error verifying this Authentication Factor. Please try again. [$_]")
                }
            }
        }
        "Prompt" {
            Try{
                $Authentication = Send-OneLoginAuthentication -Device $Workflow.OneLogin.ChosenDevice
                $Workflow.OneLogin.Authentication = $Authentication
            } Catch {
                $workflow.ActivityFailure("There was an error initializing the Authentication request. [$_]")
            }
            
            Try {
                $Response = Resolve-OneLoginAuthentication -Authentication $workflow.OneLogin.Authentication -ErrorAction Stop
            } Catch {
                $Workflow.ActivityFailure("There was an unexpected error verifying this Authentication Factor. Please try again. [$_]")
            }
        }
    }

    If ($Response.Status -eq "accepted") {
        $workflow.ActivitySuccess()
    } Else {
        $global.AddFailedAuthAttempt($workflow.UserInfo.Domain, $workflow.UserInfo.Id, [QPM.Common.Enums.AuthCategory]"Internal")
        switch ($Workflow.OneLogin.VerificationMethod) {
            "OTP" {
                $workflow.ActivityFailure("Authentication Failure. Invalid Confirmation Code. A new code has been sent. Please try again, or press Back to select a different Authentication Factor.  [$_]")
            }
            "Prompt" {
                $workflow.ActivityFailure("Authentication Failure. Verification unsuccessful. Please try again, or press Back to select a different Authentication Factor.  [$_]")
            }
        }
    }
    
}