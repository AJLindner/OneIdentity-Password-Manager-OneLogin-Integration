$Global:Connection = $null

# Import Classes from C# Files
$ClassReferences = @"
using System;
using System.Collections;
using System.Collections.Generic;`n`n
"@

$ClassSources = Get-Content "$PSScriptRoot\Classes\*.cs"
$ClassData = $ClassReferences + ($ClassSources -join "`n")
Add-Type -TypeDefinition $ClassData

# Import nested functions
$Public = @( Get-ChildItem -Path $PSScriptRoot\Public\*.ps1 -ErrorAction SilentlyContinue )
$Private = @( Get-ChildItem -Path $PSScriptRoot\Private\*.ps1 -ErrorAction SilentlyContinue )

# Dot source the files
Foreach ($import in @($Public + $Private)) {
    Try {
        . $import.fullname
    }
    Catch {
        Write-Error -Message "Failed to import function $($import.fullname): $_"
    }
}