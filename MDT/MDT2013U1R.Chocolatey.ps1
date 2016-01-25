[CmdletBinding()]
param()

$ChocoPackage = @{
    ID = 'MDT'
    Version = '6.3.8298.0'
    Tags = 'MDT ADK Winpe WAIK BDD MDT2012 MDT2013 MDT2013U1'
    packageName = 'Microsoft Deployment Toolkit 2013 Update 1 Rerelease'
    friendlyUrl = 'https://www.microsoft.com/en-us/download/details.aspx?id=48595'
    Summary = 'Microsoft Deployment Toolkit (MDT) is a free computer program from Microsoft that assists with the deployment of Microsoft Windows and Office'
    url = 'https://download.microsoft.com/download/0/D/E/0DE81822-D03F-4075-93B6-DDEAA0E095F7/MicrosoftDeploymentToolkit2013_x86.msi'
    url64bit = 'https://download.microsoft.com/download/0/D/E/0DE81822-D03F-4075-93B6-DDEAA0E095F7/MicrosoftDeploymentToolkit2013_x64.msi'
}

& $PSScriptRoot\Create-ChocolateyMSIPackage.ps1 -Path $PSScriptRoot\Build\MDTu1 @ChocoPackage
