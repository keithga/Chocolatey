[CmdletBinding()]
param()

$ChocoPackage = @{
    ID = 'MDT'
    Version = '6.3.8450.1'
    Tags = 'MDT ADK Winpe WAIK BDD MDT2012 MDT2013 MDT2013U1 MDT8450'
    packageName = 'Microsoft Deployment Toolkit Build 8450'
    friendlyUrl = 'https://www.microsoft.com/en-sg/download/details.aspx?id=57917'
    Summary = 'Microsoft Deployment Toolkit (MDT) is a free computer program from Microsoft that assists with the deployment of Microsoft Windows and Office'
    url = 'https://download.microsoft.com/download/0/7/b/07b3b260-f008-4b1c-8eaa-74bcc5c7d646/MicrosoftDeploymentToolkit_x86.msi'
    url64bit = 'https://download.microsoft.com/download/0/7/b/07b3b260-f008-4b1c-8eaa-74bcc5c7d646/MicrosoftDeploymentToolkit_x64.msi'
}

& $PSScriptRoot\..\Common\Create-ChocolateyMSIPackage.ps1 -Path $PSScriptRoot\Build\MDT8450 @ChocoPackage
