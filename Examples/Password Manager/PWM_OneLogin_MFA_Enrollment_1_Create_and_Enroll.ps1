<#
    .SYNOPSIS
    Registers a new user in OneLogin for MFA

    .DESCRIPTION
    This custom action script can be used in Password Manager as part of a sequence to register a new user in OneLogin. If the user does not exist in OneLogin, they will be created.
    If they do not already have at least 1 Multifactor Authentication method registered, they will be prompted to do so.

    No Activity UI is needed, this script will automatically generate the UI.

    All workflows that integrate with OneLogin should begin with a PWM_OneLogin_0_Configure_and_Connect Action before any other OneLogin actions.

    There should be a PWM_OneLogin_MFA_Enrollment_2_Verify action directly after this.

#>

Function PreLoad($workflow,$activity) {

    Import-Module QuestOneLogin
    $Global:Connection = $workflow.OneLogin.Connection

    $AD = $workflow.UserInfo.AccountInfo

    Try {
        $User = Get-OneLoginUser -Filter @{email=$AD.mail} -ErrorAction Stop
    } Catch {
        $User = New-OneLoginUser -Email $AD.mail -Username $AD.UserPrincipalName -firstname $AD.givenname -lastname $AD.sn
    }
       
    $Workflow.OneLogin.User = $User

    $Devices = Get-OneLoginDevices -User $Workflow.OneLogin.User
    
    If ($Devices.count -eq 0) {
        $DefaultFactors = Get-OneLoginAuthFactors -User $Workflow.OneLogin.User | Where-Object {$_.auth_factor_name -in [OneLogin.AuthFactor]::verification_methods.keys}
        $AllowedRegistrationFactors = $DefaultFactors | Where-Object {$_.name -notin $workflow.OneLogin.IgnoredRegistrationFactors}
        $Workflow.OneLogin.AuthFactors = $AllowedRegistrationFactors
        $Workflow.OneLogin.NeedsEnrollment = $true
    } Else {
        $Workflow.OneLogin.NeedsEnrollment = $false
        $Workflow.ActivitySuccess()
    }
    
}
    
Function PostLoad($workflow,$activity) {
    
    $AuthFactors_Controls = [Collections.Generic.List[QPM.Common.ActivityContexts.Controls.ControlInfo]]::new()
    $AuthFactors_RadioButtons = New-Object QPM.Common.ActivityContexts.Controls.RadioButtonListInfo
    $AuthFactors_Options = New-Object QPM.Common.ActivityContexts.Controls.ListOptions
    $AuthFactor_Name = New-Object QPM.Common.ActivityContexts.Controls.TextBoxInfo
    
    ForEach ($Factor in $Workflow.OneLogin.AuthFactors) {
        $AuthFactors_Options.Add($Factor.Name, $Factor.Name)
    }
    
    $AuthFactors_RadioButtons.ID = "Available_Auth_Factors"
    $AuthFactors_RadioButtons.Label = "Select an Authentication Method to Enroll"
    $AuthFactors_RadioButtons.Text= "AuthenticationFactors"
    $AuthFactors_RadioButtons.Options = $AuthFactors_Options
    $AuthFactors_RadioButtons.Value = $AuthFactors_Options[0].Value

    $AuthFactor_Name.ID = "Device_Name"
    $AuthFactor_Name.Label = "Enter a name for your new authentication method."
    

    $AuthFactors_Controls.Add($AuthFactors_RadioButtons)
    $AuthFactors_Controls.Add($AuthFactor_Name)

    $Activity.Runtime.Controls = $AuthFactors_Controls
    
}

Function PreExecuting($workflow,$activity) {
    
    If ($activity.runtime.controls["Device_Name"].Value -eq '') {
        $workflow.ActivityFailure("Please enter a name.")
    }
    Else {
        $ChosenFactor = $Workflow.OneLogin.AuthFactors | Where-Object Name -eq $activity.runtime.controls["Available_Auth_Factors"].Value
        $RegistrationParams = @{
            User = $workflow.OneLogin.User
            AuthFactor = $ChosenFactor
            DisplayName = $activity.runtime.controls["Device_Name"].Value
            Verified = ($ChosenFactor.Name -in $workflow.OneLogin.AutoVerifyFactors)
        }
        $Registration = Register-OneLoginDevice -User $workflow.OneLogin.User -AuthFactor $ChosenFactor -DisplayName $activity.runtime.controls["Device_Name"].Value

        $Workflow.OneLogin.Registration = $Registration
    }

}