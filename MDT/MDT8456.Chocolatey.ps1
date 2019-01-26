[CmdletBinding()]
param()

$ChocoPackage = @{
    ID = 'MDT'
    Version = '6.3.8456.0'
    Tags = 'MDT ADK Winpe WAIK BDD MDT2012 MDT2013 MDT2013U1 MDT8450'
    packageName = 'Microsoft Deployment Toolkit Build 8456'
    friendlyUrl = 'https://www.microsoft.com/en-us/download/details.aspx?id=54259'
    Summary = 'Microsoft Deployment Toolkit (MDT) is a free computer program from Microsoft that assists with the deployment of Microsoft Windows and Office'
    url = 'https://download.microsoft.com/download/C/E/6/CE63C73A-31D6-4473-9216-19D7B88FD2DF/MicrosoftDeploymentToolkit_x86.msi'
    url64bit = 'https://download.microsoft.com/download/C/E/6/CE63C73A-31D6-4473-9216-19D7B88FD2DF/MicrosoftDeploymentToolkit_x64.msi'
}

& $PSScriptRoot\..\Common\Create-ChocolateyMSIPackage.ps1 -Path $PSScriptRoot\Build\MDT8456 @ChocoPackage
