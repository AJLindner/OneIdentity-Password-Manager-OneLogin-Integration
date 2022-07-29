<#
    .SYNOPSIS
    Allows Password Manager to connect to OneLogin

    .DESCRIPTION
    This custom action script can be used in Password Manager to connect to OneLogin. Use the configuration options below to configure connection to your OneLogin instance.

    All workflows that integrate with OneLogin should begin with this Action before any other OneLogin actions.
#>

Function PreLoad($workflow,$activity) {
    
    # Enter your OneLogin Configuration Data below, OR, provide a file path to an external Config file
    # An example PWM_OneLogin_Config_Example.json file is included in the repository

    $OneLoginConfigData = @{

        # Absolute Path to an External Config File. This overwrites all settings defined below if you include it.
        ExternalConfigFilePath = ""

        # Your OneLogin ClientID for API Connections. It is recommended to use the Powershell SecretManagement module to securely fetch this.
        # Example: ClientID = (Get-Secret OneLoginClientID -Vault PasswordManager -AsPlainText)
        ClientID = "MyOneLoginClientID"

        # Your OneLogin ClientSecret for API Connections. It is recommended to use the Powershell SecretManagement module to securely fetch this.
        ClientSecret= "MyOneLoginClientSecret"

        # The Subdomain of your OneLogin instance
        Subdomain = "MyOneLoginSubDomain"

        # Enter the Path to the OneLoginByOneIdentity Powershell Module
        # ONLY NEEDED IF you did NOT install via Install-Module, or place in a PSModule path
        ModulePath = ""

        <#
        Email MFA can either use an OTP Code or a Magic Link. The OneLogin API 2 (v5) can not determine which is which
        So, if you have any email factors that use a Magic Link, please include the DISPLAY NAMES here
        You can check this in the OneLogin Admin Portal by going to Security -> Authentication Factors
        Then, check any "OneLogin Email" Factors. If the "MFA Type" is "Magic Link", include the "Display Name" a.k.a. "User Description"
        Example:
            MagicLinkFactors = @("Email with Magic Link","Magic Link Email")
        #>
        MagicLinkFactors = @("Email Magic Link")

        <#
        The OneLogin API allows registering new Authentication Factors ("devices"), but is has limitations in the current version 2 (v5)
        You can only register OneLogin Protect, Email, SMS, OneLogin Voice, and Authenticator.
        Password Manager will only display those Registration Factors. However, there is one other caveat.
        SMS and Email factors have the OPTION to allow the end user to provide their email or phone number.
        The API can not provide that information when registering a new Authentication Factor.
        If you have any Email or SMS Factors configured to use a "End User Provided" email or phone number,
        please list those here, using the "Display Name" a.k.a. "User Description", so they can be ignored.
        Example:
            IgnoredRegistrationFactors = @("Personal Email","Other Email","User Provided Email")
        #>
        IgnoredRegistrationFactors = @()

        <#
        When you enroll in Email or SMS for MFA, you are then prompted with an OTP Code (or a Magic Link) to verify that email address
        or phone number. If there are any Email or SMS Authentication Factors that already use a known good email or phone number
        pulled from something like an HR system or AD, you can optionally bypass that verification process. You may list those here,
        using the "Display Name" a.k.a. "User Description".
        Example:
            AutoVerifyFactors = @("Corporate Email","Corporate SMS")
        #>
        AutoVerifyFactors = @()

    }

    Try {
        Set-OneLoginConfiguration @OneLoginConfigData -ErrorAction Stop
        $workflow.ActivitySuccess()
    } Catch {
        $workflow.ActivityFailure("An error occurred connecting to OneLogin:`n`n$_`n`nPlease contact your Administrator.")
    }
    
}

Function Set-OneLoginConfiguration {
    
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [String]
        [ValidateNotNullOrEmpty()]
        $ClientID,

        [Parameter(Mandatory)]
        [String]
        [ValidateNotNullOrEmpty()]
        $ClientSecret,

        [Parameter(Mandatory = $false)]
        [String]
        $Subdomain,

        [Parameter(Mandatory = $false)]
        [String[]]
        $MagicLinkFactors,

        [Parameter(Mandatory = $false)]
        [String[]]
        $IgnoredRegistrationFactors,

        [Parameter(Mandatory = $false)]
        [String[]]
        $AutoVerifyFactors,

        [Parameter(Mandatory = $false)]
        [String]
        $ModulePath,

        [Parameter(Mandatory = $false)]
        [String]
        $ExternalConfigFilePath
    )

    # Set Execution Policy for this process to avoid unsigned code errors
    Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass -Force

    If (($ExternalConfigFilePath -ne '') -and ($ExternalConfigFilePath -ne $null)) {
        Try {
            Test-Path $ExternalConfigFilePath -ErrorAction Stop
            $Config = Get-Content $ExternalConfigFilePath | ConvertFrom-Json
            
            $ClientID = $Config.ClientID
            $ClientSecret = $Config.ClientSecret
            $Subdomain = $Config.Subdomain
            $MagicLinkFactors = $Config.MagicLinkFactors
            $IgnoredRegistrationFactors = $Config.IgnoredRegistrationFactors
            $AutoVerifyFactors = $Config.AutoVerifyFactors
            $ModulePath = $Config.ModulePath
            
        }
        Catch {
            $workflow.ActivityFailure("The External Config File Path provided could not be found or accessed. Please contact your administrator.`n`n$_")
        }
    }
    
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

    $workflow | Add-Member -MemberType NoteProperty -Name "OneLogin" -Value @{} -Force

    $workflow.OneLogin.Connection = Connect-OneLogin -ClientID $ClientID -ClientSecret $ClientSecret -Subdomain $Subdomain -ErrorAction Stop

    $workflow.OneLogin.MagicLinkFactors = $MagicLinkFactors
    $workflow.OneLogin.IgnoredRegistrationFactors = $IgnoredRegistrationFactors
    $workflow.OneLogin.AutoVerifyFactors = $AutoVerifyFactors
}

