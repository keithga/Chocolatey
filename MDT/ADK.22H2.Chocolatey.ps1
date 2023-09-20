[CmdletBinding()]
param(
    $Version = '22H2'
)

$CommonArgs = '/quiet /norestart /log $env:temp\winPE_adk.log'

$ChocoPackagePE = @{
    Version = '10.1.22621.2'
    Tags = 'ADK Winpe WAIK'
    packageName = 'WinPE add-on for the Windows Assessment and Deployment Kit'
    friendlyUrl = 'https://docs.microsoft.com/en-us/windows-hardware/get-started/adk-install'
    Summary = 'The Windows Assessment and Deployment Kit (Windows ADK) is a collection of tools that you can use to customize, assess, and deploy Windows operating systems to new computers. Installs WinPE ONLY!'
    url = 'https://go.microsoft.com/fwlink/?linkid=2243391'
}

& $PSScriptRoot\..\Common\Create-ChocolateyExePackage.ps1 -Path $PSSCriptRoot\build\$Version @ChocoPackagePE -ID 'windows-adk-winpe' -Features 'winpe' -args "$CommonArgs /features +"

$CommonArgs = '/quiet /norestart /log $env:temp\win_adk.log'

$ChocoPackageADK = @{
    Version = '10.1.22621.2'
    Tags = 'ADK Winpe WAIK USMT'
    packageName = 'Windows Assessment and Deployment Kit'
    friendlyUrl = 'https://docs.microsoft.com/en-us/windows-hardware/get-started/adk-install'
    Summary = 'The Windows Assessment and Deployment Kit (Windows ADK) is a collection of tools that you can use to customize, assess, and deploy Windows operating systems to new computers.'
    url = 'https://go.microsoft.com/fwlink/?linkid=2243390'
}

& $PSScriptRoot\..\Common\Create-ChocolateyExePackage.ps1 -Path $PSSCriptRoot\build\$Version @ChocoPackageADK -ID 'windows-adk' -Features 'default' -args "$CommonArgs"
& $PSScriptRoot\..\Common\Create-ChocolateyExePackage.ps1 -Path $PSSCriptRoot\build\$Version @ChocoPackageADK -ID 'windows-adk-all' -Features 'all' -args "$CommonArgs /features +" -Dependency "id=""windows-adk-winpe"" version = ""$($ChocoPackagePE.Version)"""
& $PSScriptRoot\..\Common\Create-ChocolateyExePackage.ps1 -Path $PSSCriptRoot\build\$Version @ChocoPackageADK -ID 'windows-adk-deploy' -Features 'common deployment' -args "$CommonArgs /features OptionId.DeploymentTools OptionId.ImagingAndConfigurationDesigner OptionId.UserStateMigrationTool"  -Dependency "id=""windows-adk-winpe"" version = ""$($ChocoPackagePE.Version)"""

