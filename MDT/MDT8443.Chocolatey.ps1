[CmdletBinding()]
param()

$ChocoPackage = @{
    ID = 'MDT'
    Version = '6.3.8443.0'
    Tags = 'MDT ADK Winpe WAIK BDD MDT2012 MDT2013 MDT2013U1 MDT8443'
    packageName = 'Microsoft Deployment Toolkit Build 8443'
    friendlyUrl = 'https://www.microsoft.com/en-us/download/details.aspx?id=48595'
    Summary = 'Microsoft Deployment Toolkit (MDT) is a free computer program from Microsoft that assists with the deployment of Microsoft Windows and Office'
    url = 'https://download.microsoft.com/download/3/3/9/339BE62D-B4B8-4956-B58D-73C4685FC492/MicrosoftDeploymentToolkit_x86.msi'
    url64bit = 'https://download.microsoft.com/download/3/3/9/339BE62D-B4B8-4956-B58D-73C4685FC492/MicrosoftDeploymentToolkit_x64.msi'
}

& $PSScriptRoot\Create-ChocolateyMSIPackage.ps1 -Path $PSScriptRoot\Build\MDTu1 @ChocoPackage
