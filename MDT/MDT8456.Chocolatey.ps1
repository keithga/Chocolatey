[CmdletBinding()]
param()

$ChocoPackage = @{
    ID = 'MDT'
    Version = '6.3.8456.3'
    Tags = 'MDT ADK Winpe WAIK BDD MDT2012 MDT2013 MDT2013U1 MDT8450'
    packageName = 'Microsoft Deployment Toolkit Build 8456'
    friendlyUrl = 'https://www.microsoft.com/en-us/download/details.aspx?id=54259'
    Summary = 'Microsoft Deployment Toolkit (MDT) is a free computer program from Microsoft that assists with the deployment of Microsoft Windows and Office'
    url = 'https://download.microsoft.com/download/3/3/9/339BE62D-B4B8-4956-B58D-73C4685FC492/MicrosoftDeploymentToolkit_x86.msi'
    url64bit = 'https://download.microsoft.com/download/3/3/9/339BE62D-B4B8-4956-B58D-73C4685FC492/MicrosoftDeploymentToolkit_x64.msi'
}

$Path = "$PSScriptRoot\Build\MDT8456"

& $PSScriptRoot\..\Common\Create-ChocolateyMSIPackage.ps1 -Path $Path @ChocoPackage


@'

#Install KB4564442 Hotfix
    $ZipPackage = @{
        PackageName = 'KB4564442'
        URL = 'https://download.microsoft.com/download/3/0/6/306AC1B2-59BE-43B8-8C65-E141EF287A5E/KB4564442/MDT_KB4564442.exe' 
        UnzipLocation = (get-itemproperty 'HKLM:\software\microsoft\Deployment 4').Install_dir + "\Templates\Distribution\Tools"
        Checksum = 'CD0BC2EC616BA5F8DDD626D02747B19C90EFA1BA159303F2FF41AE693EC10B3F'
        ChecksumType = 'sha256'
    }

Install-ChocolateyZipPackage @ZipPackage

'@ | Out-File -FilePath "$Path\$($ChocoPackage.ID)\tools\chocolateyinstall.ps1" -Encoding utf8 -Append
