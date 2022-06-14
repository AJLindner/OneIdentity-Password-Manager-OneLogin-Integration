<#
    .SYNOPSIS
    Verifies MFA Registration for a new user in OneLogin

    .DESCRIPTION
    This custom action script can be used in Password Manager as part of a sequence to register a new user in OneLogin. After creating the new user and selecting a device to register,
    the user will then Verify that MFA method if it was not configured for auto verification. This will either be a Push notification, Email Magic Link, or OTP code.

    No Activity UI is needed, this script will automatically generate the UI.

    All workflows that integrate with OneLogin should begin with a PWM_OneLogin_0_Configure_and_Connect Action first.

    There should be a PWM_OneLogin_MFA_Enrollment_1_Create_and_Enroll action directly before this.
#>

Function PreLoad($workflow,$activity) {

    If (!($Workflow.OneLogin.NeedsEnrollment)) {
        $Workflow.ActivitySuccess()
    }

    If ($Workflow.OneLogin.Registration.Status -eq "Accepted") {
        $Workflow.ActivitySuccess()
    }

    Import-Module QuestOneLogin
    $Global:Connection = $workflow.OneLogin.Connection
}
    
Function PostLoad($workflow,$activity) {
    
    $authFactor = $workflow.OneLogin.Registration.AuthFactor
    $Workflow.OneLogin.VerificationMethod = $authFactor.verification_method
    $Verification_Controls = [Collections.Generic.List[QPM.Common.ActivityContexts.Controls.ControlInfo]]::new()

    $OTP = New-Object QPM.Common.ActivityContexts.Controls.TextBoxInfo
    $OTP.ID = "OTP"

    $Prompt  = New-Object QPM.Common.ActivityContexts.Controls.LabelInfo
    $Prompt.ID = "RegistrationCode"

    Switch ($authFactor.verification_method)  {
        "Prompt" {
            if ($authFactor.auth_factor_name -eq "OneLogin Voice") {
                $Prompt.Label = "Please follow the voice prompts on the call received from OneLogin to register your device. Press Next when finished."
            }
            if ($authFactor.auth_factor_name -eq "OneLogin") {
                $Prompt.Label = "Please download the OneLogin Protect app and register with activation code: $($workflow.OneLogin.Registration.factor_data.verification_token). Press Next when finished."
            }
            $Verification_Controls.Add($Prompt)
        }
        "OTP" {
            if ($authFactor.auth_factor_name -eq "Google Authenticator") {
                $Prompt.Label = "Please add OneLogin to your Authenticator app with activation code: $($workflow.OneLogin.Registration.factor_data.verification_token)."
                $OTP.Label = "Please enter the OTP code on your Authenticator App."
                $Verification_Controls.Add($Prompt)
            }
            if  ($authFactor.auth_factor_name -eq "SMS") {
                $OTP.Label = "Please enter the OTP code sent to your phone number at $($workflow.UserInfo.AccountInfo.TelephoneNumber). Press Next when finished."
            }
            $Verification_Controls.Add($OTP)
        }
        "Both" {
            if ($authFactor.name -in $workflow.OneLogin.MagicLinkFactors) {
                $Prompt.Label = "Please follow the OneLogin link sent to your email at $($workflow.UserInfo.AccountInfo.mail). Press Next when finished."
                $Verification_Controls.Add($Prompt)
                $Workflow.OneLogin.VerificationMethod = "Prompt"
            }
            else {
                $OTP.Label = "A Confirmation Code was sent to your configured address. Please enter your Confirmation Code. Press Next when finished."
                $Verification_Controls.Add($OTP)
                $Workflow.OneLogin.VerificationMethod = "OTP"
            }
        }
    }

    $Activity.Runtime.Controls = $Verification_Controls
}

Function PreExecuting($workflow,$activity) {
## Finish handling for the confirmation call. Use $Workflow.OneLogin.VerificationMethod (will be either Prompt or OTP)
    
    if ((Get-Date).ToUniversalTime() -ge $Workflow.OneLogin.Registration.expires_at.UTCDateTime) {
        $Workflow.ActivityFailure("The registration has expired. You must generate a new device registration.")
    }

    switch ($Workflow.OneLogin.Verificationmethod){
        "OTP" {
            $Entered_OTP = $activity.runtime.controls["OTP"].Value
            if ($Entered_OTP -eq '' ) {
                $Workflow.ActivityFailure("Please enter the OTP Code sent to your device.")
            }
            else {
                Try {
                    Confirm-OneLoginDeviceRegistration -DeviceRegistration $Workflow.OneLogin.Registration -OTP $Entered_OTP -ErrorAction Stop
                } Catch {
                    $Workflow.ActivityFailure("There was an error verifying this device. Please try again.`n`n$_")
                }
            }
        }
        "Prompt" {
            Try {
                Confirm-OneLoginDeviceRegistration -DeviceRegistration $Workflow.OneLogin.Registration -ErrorAction Stop
            } Catch {
                $Workflow.ActivityFailure("There was an error verifying this device. Please try again.`n`n$_")
            }
        }
    }
}