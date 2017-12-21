[CmdletBinding()]
param()

$ChocoPackage = @{
    ID = 'MDT'
    Version = '6.3.8330.0'
    Tags = 'MDT ADK Winpe WAIK BDD MDT2012 MDT2013 MDT2013U1 MDT2013U2'
    packageName = 'Microsoft Deployment Toolkit 2013 Update 2'
    friendlyUrl = 'http://www.microsoft.com/en-us/download/details.aspx?id=50407'
    Summary = 'Microsoft Deployment Toolkit (MDT) is a free computer program from Microsoft that assists with the deployment of Microsoft Windows and Office'
    url = 'https://download.microsoft.com/download/3/0/1/3012B93D-C445-44A9-8BFB-F28EB937B060/MicrosoftDeploymentToolkit2013_x86.msi'
    url64bit = 'https://download.microsoft.com/download/3/0/1/3012B93D-C445-44A9-8BFB-F28EB937B060/MicrosoftDeploymentToolkit2013_x64.msi'
}

& $PSScriptRoot\..\Common\Create-ChocolateyMSIPackage.ps1 -Path $PSScriptRoot\Build\MDTu2 @ChocoPackage