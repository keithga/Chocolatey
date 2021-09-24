
[CmdletBinding()]
param(
     [string] $Filter = "$PSScriptRoot\MDT\*.chocolatey.ps1"
    )

Remove-Item -Recurse -Force $PSScriptRoot\MDT\build -ErrorAction SilentlyContinue

foreach ( $MyScript in get-childitem $Filter  )
{
    Write-Verbose "run $MyScript"
    & $MyScript
}

foreach ( $Nuget in get-childitem -recurse $PSScriptRoot\*.nuspec )
{
    choco pack $NuGet
}
