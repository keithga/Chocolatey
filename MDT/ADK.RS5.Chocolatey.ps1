[CmdletBinding()]
param(
    $Version = '1809'
)

$ChocoPackagePE = @{
    Version = '10.0.17763.1'
    Tags = 'ADK Winpe WAIK'
    packageName = 'Windows Assessment and Deployment Kit'
    friendlyUrl = 'https://msdn.microsoft.com/en-us/windows/hardware/dn913721.aspx'
    Summary = 'The Windows Assessment and Deployment Kit (Windows ADK) is a collection of tools that you can use to customize, assess, and deploy Windows operating systems to new computers. Installs WinPE ONLY!'
    url = 'https://go.microsoft.com/fwlink/?linkid=2022233'
}


& $PSScriptRoot\..\Common\Create-ChocolateyExePackage.ps1 -Path $PSSCriptRoot\build\$Version @ChocoPackagePE -ID 'windows-adk-winpe' -Features 'winpe' -args "/quiet /norestart /log $env:temp\winPE_adk.log /features +"

$CommonArgs = '/quiet /norestart /log $env:temp\win_adk.log'

$ChocoPackageADK = @{
    Version = '10.0.17763.1'
    Tags = 'ADK Winpe WAIK USMT'
    packageName = 'Windows Assessment and Deployment Kit'
    friendlyUrl = 'https://msdn.microsoft.com/en-us/windows/hardware/dn913721.aspx'
    Summary = 'The Windows Assessment and Deployment Kit (Windows ADK) is a collection of tools that you can use to customize, assess, and deploy Windows operating systems to new computers.'
    url = 'https://go.microsoft.com/fwlink/?linkid=2026036'
}

& $PSScriptRoot\..\Common\Create-ChocolateyExePackage.ps1 -Path $PSSCriptRoot\build\$Version @ChocoPackageADK -ID 'windows-adk' -Features 'default' -args "$CommonArgs"
& $PSScriptRoot\..\Common\Create-ChocolateyExePackage.ps1 -Path $PSSCriptRoot\build\$Version @ChocoPackageADK -ID 'windows-adk-all' -Features 'all' -args "$CommonArgs /features +" -Dependency "id=""windows-adk-winpe"" version = ""$($ChocoPackagePE.Version)"""
& $PSScriptRoot\..\Common\Create-ChocolateyExePackage.ps1 -Path $PSSCriptRoot\build\$Version @ChocoPackageADK -ID 'windows-adk-deploy' -Features 'common deployment' -args "$CommonArgs /features OptionId.DeploymentTools OptionId.ImagingAndConfigurationDesigner OptionId.UserStateMigrationTool"  -Dependency "id=""windows-adk-winpe"" version = ""$($ChocoPackagePE.Version)"""

