# Introduction 
This repo contains the tools needed to integrate [One Identity Password Manager](https://www.oneidentity.com/products/password-manager/) with [OneLogin By One Identity](https://www.onelogin.com/) using the OneLogin v2 API.

# Description
The "OneLoginByOneIdentity" Powershell Module included in this repo is a stripped-down and limited fork of the larger, in progress, "OneLoginByOneIdentity" powershell module, which includes wrapper functions around the OneLogin v2 API Endpoint. This version of the module only includes the classes and functions that are in-scope and necessary for integration with Password Manager to manage users and security factors, and provide multi-factor authentication.

The "Examples" folder includes specific integration examples with Password Manager. These code samples can be used as starting points to build custom integrations with Password Manager and OneLogin, but should not be considered production-ready, or specified to meet the requirements of your environment.

# Module Installation

## 1. Clone the Repo
Clone this Repo to your machine via `git clone`. Alternatively, download the repo and extract the .zip file.

## 2. Install the module
Since this module is not listed in any repositories, you will need to install it manually. If you do not wish to install the module on your Password Manager server, you can optionally use the `ModulePath` key in the `PWM_OneLogin_0_Configure_and_Connect` activity and point it to the `.psd1` file of the module directory.

To install manually:

1. Select a directory included in the `PSModulePath` environment variable. You can list these directories from Powershell with the command `$Env:PSModulePath`
   
   By default, Windows machines will always have a module path listed here `$Env:ProgramFiles\WindowsPowerShell\Modules`. This is the recommended directory for installing this module.
2. Copy the `OneLoginByOneIdentity` folder to that directory.
3. That's it. Now, test that you can reference the module by importing it with `Import-Module OneLoginByOneIdentity`


# How to Use the Module
Refer to the [Online Help Documentation](https://github.com/AJLindner/OneIdentity-Password-Manager-OneLogin-Integration/blob/master/Docs/OneLoginByOneIdentity.md) or the Comment-Based Help. Use `Get-Command -Module OneLoginByOneIdentity` to list all commands. Get help for specific commands via `Get-Help -Name "Command-Name"`.

Any scripts utilizing this module should first import it, either by name if it is installed in a `PSModulePath` directory, or by filepath to the `.psd1` file if it is not.

```powershell
Import-Module OneLoginByOneIdentity

Import-Module c:\path\to\module\folder\OneLoginByOneIdentity.psd1
```

However, you do not need to manually import the module if it is installed in a `PSModulePath` directory. Calling any of the commands in the module will cause Powershell to automatically import it for you.

# How to Integrate with Password Manager
To integrate with Password Manager, refer to the examples included in the "Examples" folder. Each of the `.ps1` files included in the examples can be used to create a Custom Activity in Password Manager. No UI Elements are needed for those activities, as the `.ps1` scripts will dynamically build UI elements for you.

Each example has multiple steps that need to run in order when building your Password Manager workflow. Every workflow that integrates with OneLogin should first begin with a "PWM_OneLogin_0_Configure_and_Connect" step as the very first step in the workflow. Other integration activities can follow, like steps 1 and 2 for `MFA Authentication`.

When you create a Custom Activity for the `Configure and Connect` step, the configuration settings you define will exist for that action globally. Meaning, you can configure the connection once and re-use that same activity across all the workflows you need it for. If you need multiple separate configurations, you can create separate actions to handle that.

Additionally, you will need to enable API access in OneLogin.

## Enable API Access in OneLogin
Refer to the [OneLogin Developers Documentation](https://developers.onelogin.com/api-docs/2/getting-started/working-with-api-credentials) to configure access to the OneLogin API. You will need a `Client Secret` and `Client ID`. Do not worry about making API calls to generate an access token, etc. Authentication and all other API calls are already wrapped and handled via the Powershell Module.

## Creating Custom Activities

### Enable Extensibility
In the Password Manager Admin Web Interface `/PMAdmin`, go to `General Settings` -> `Extensibility` and select the Radio Button for `Extensibility On`. You may toggle `Troubleshooting` on and off here as well if needed to troubleshoot your scripts.

### Create a Custom Activity
1. In the Password Manager Admin Web Interface `/PMAdmin`, navigate to any `Workflow` inside of any `Management Policy`.
2. In the `activities pane` on the left, expand the `custom` option and select `Add new custom activity`.
3. In the `Activity Name` tab, provide an appropriate `short name` for use in Powershell Scripts, and a `Display Name` that you will see when adding the activity to your workflows.

   If you are copying the examples, we recommend ensuring that the `short name` matches the name of the associated Powershell Script.
4. In the `Powershell Script` tab, paste in the contents of the `.ps1` example you are copying, or the custom script that you would like to execute. You can modify the script in advance before pasting it in, or you can use the integrated editor to change it afterwards.
5. Click `OK`. You can now drag this activity into any workflow.

## Configuring the PWM_OneLogin_0_Configure_and_Connect Activity
In order for API-based integration to work, you must include a `PWM_OneLogin_0_Configure_and_Connect` activity in each workflow. This activity requires some configuration that is unique to your OneLogin implementation. The comments in the `PWM_OneLogin_0_Configure_and_Connect.ps1` file explain each of the keys that must be defined, either in the .ps1 file itself, or in a separate .json file. These keys are included here for reference as well.

Note that this custom activity, or the external .json file if you choose to use it, will contain sensitive information that provides API access to your OneLogin instance. Because of this, it is highly recommended that you utilize a secret store with Powershell to fetch this information securely. We recommend Microsoft's [Secret Management Module](https://www.powershellgallery.com/packages/Microsoft.PowerShell.SecretManagement/1.1.2), which can be used with a local vault, or vaults registered with integration partners, like Azure Key Vault. You will need to ensure that the Password Manager Service Account has access to get these secrets, as that is the account under which these scripts will run.

All configuration items are keys inside the `$OneLoginConfig` hashtable inside the `PreLoad` function.

```Powershell
# Enter your OneLogin Configuration Data below, OR, provide a file path to an external Config file
# An example PWM_OneLogin_Config_Example.json file is included in the repository

$OneLoginConfigData = @{
    
    # Absolute Path to an External Config File. This overwrites all settings defined below if you include it.
    ExternalConfigFilePath = ""

    # Your OneLogin ClientID for API Connections. It is recommended to use the Powershell SecretsManagement module to securely fetch this.
    # Example:
        # ClientID = (Get-Secret OneLoginClientID -Vault PasswordManager -AsPlainText)
    ClientID = ""

    # Your OneLogin ClientSecret for API Connections. It is recommended to use the Powershell SecretsManagement module to securely fetch this.
    ClientSecret= ""

    # The Region of your OneLogin instance, either "US" or "EU"
    Region = "US"

    # Enter the Path to the OneLoginByOneIdentity Powershell Module
    # ONLY NEEDED IF you did NOT install via Install-Module
    ModulePath = ""

    <#
    Email MFA can either use an OTP Code or a Magic Link. The OneLogin V2 API can not determine which is which
    So, if you have any email factors that use a Magic Link, please include the DISPLAY NAMES here
    You can check this in the OneLogin Admin Portal by going to Security -> Authentication Factors
    Then, check any "OneLogin Email" Factors. If the "MFA Type" is "Magic Link", include the "Display Name" a.k.a. "User Description"
    Example:
        MagicLinkFactors = @("Email with Magic Link","Magic Link Email")
    #>
    MagicLinkFactors = @()

    <#
    The OneLogin API allows registering new Authentication Factors ("devices"), but is has limitations in the current version V2
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
```

## Example : Multifactor Authentication via the OneLogin API
Per the example files, if you wanted a Password Manager Workflow to authenticate a user against one of their OneLogin Security Factors via the API, you would include Custom Activities built from the following example files:

1. `PWM_OneLogin_0_Configure_and_Connect.ps1`
2. `PWM_OneLogin_MFA_Authentication_1_Select_Device.ps1`
3. `PWM_OneLogin_MFA_Authentication_2_Authenticate_Device.ps1`
