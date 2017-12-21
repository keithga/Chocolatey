[CmdletBinding()]
param()

$ChocoPackage = @{
    Version = '10.0.15063.0'
    Tags = 'ADK Winpe WAIK USMT'
    packageName = 'Windows Assessment and Deployment Kit'
    friendlyUrl = 'https://msdn.microsoft.com/en-us/windows/hardware/dn913721.aspx'
    Summary = 'The Windows Assessment and Deployment Kit (Windows ADK) is a collection of tools that you can use to customize, assess, and deploy Windows operating systems to new computers.'
    url = 'https://go.microsoft.com/fwlink/p/?LinkId=845542'
}

$COmmonArgs = '/quiet /norestart /log $env:temp\win_adk.log'

& $PSScriptRoot\..\Common\Create-ChocolateyExePackage.ps1 -Path $PSSCriptRoot\build\th2 @ChocoPackage -ID 'windows-adk' -Features 'default' -args "$CommonArgs"
& $PSScriptRoot\..\Common\Create-ChocolateyExePackage.ps1 -Path $PSSCriptRoot\build\th2 @ChocoPackage -ID 'windows-adk-all' -Features 'all' -args "$CommonArgs /features +"
& $PSScriptRoot\..\Common\Create-ChocolateyExePackage.ps1 -Path $PSSCriptRoot\build\th2 @ChocoPackage -ID 'windows-adk-winpe' -Features 'winpe' -args "$CommonArgs /features OptionId.DeploymentTools OptionId.WindowsPreinstallationEnvironment"
& $PSScriptRoot\..\Common\Create-ChocolateyExePackage.ps1 -Path $PSSCriptRoot\build\th2 @ChocoPackage -ID 'windows-adk-deploy' -Features 'common deployment' -args "$CommonArgs /features OptionId.DeploymentTools OptionId.WindowsPreinstallationEnvironment OptionId.ImagingAndConfigurationDesigner OptionId.UserStateMigrationTool"

