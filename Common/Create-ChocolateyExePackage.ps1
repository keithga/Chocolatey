<#

.SYNOPSIS
New Chocolatey Package

.DESCRIPTION
Create a new MSI Chocolatey Package

.NOTES

will automatically download the MSI packages, generate the CRC and download string

#>

[CmdletBinding()]
param(
       [Parameter(Mandatory=$true)]
       [string] $Path,

       [Parameter(Mandatory=$true)]
       [string] $ID,

       [Parameter(Mandatory=$true)]
       [string] $PackageName,

       [Parameter(Mandatory=$true)]
       [string] $friendlyURL,

       [Parameter(Mandatory=$true)]
       [string] $Summary,

       [Parameter(Mandatory=$true)]
       [string] $Version,

       [Parameter(Mandatory=$true)]
       [string] $Tags,

       [Parameter(Mandatory=$true)]
       [string] $url,

       [Parameter(Mandatory=$false)]
       [string] $Args,

       [Parameter(Mandatory=$false)]
       [string] $Features = "default"

)

#region PREP_ENVIRONMENT

    if ( -not (Test-Path "$Path\$ID\tools") )
    {
        New-Item -Path "$Path\$ID\tools" -Force -ItemType Directory | Out-Null
    }

    if ( $url ) 
    { 
        $localfilex86 = [System.IO.Path]::GetTempFileName() + ".exe"
        (New-Object System.Net.WebClient).DownloadFile($url, $localfilex86)
        $filex86crc = Get-FileHash -Path $localfilex86 -Algorithm MD5 | select-object -ExpandProperty hash
        while ( Test-path $localfilex86 ) { Start-Sleep 1; Remove-Item -Force $localfilex86 -ErrorAction SilentlyContinue; write-verbose "delete..."}
    }

#endregion

#region CREATE_MANIFEST

@"
<?xml version="1.0" encoding="utf-8"?>
<package xmlns="http://schemas.microsoft.com/packaging/2010/07/nuspec.xsd">
  <metadata>
    <id>$ID</id>
    <title>$PackageName</title>
    <version>$version</version>
    <authors>Microsoft</authors>
    <owners>Keith Garner</owners>
    <summary>$Summary</summary>
    <description>This package will silently install $PackageName to the default location with $Features features.</description>
    <projectUrl>$friendlyURL</projectUrl>
    <tags>$tags admin</tags>
    <copyright>Microsoft</copyright>
    <licenseUrl>http://www.microsoft.com/en-us/legal/intellectualproperty/copyright/default.aspx</licenseUrl>
    <iconUrl>https://raw.github.com/keithga/Chocolatey/master/Resources/win_logo.png</iconUrl>
    <requireLicenseAcceptance>false</requireLicenseAcceptance>
    <releaseNotes></releaseNotes>
  </metadata>
</package>
"@ | Out-File -FilePath "$Path\$ID\$($ID).nuspec" -Encoding utf8

#endregion

#region CREATE_CHOCOLATEYINSTALL

Write-Verbose "Create $Path\$ID\tools\chocolateyinstall.ps1"

@"

<#
.SYNOPSIS
Install $ID

.DESCRIPTION
Installs the $PackageName using the Chocolatey framework

.LINK
$friendlyURL
#>

`$ChocoPackage = @{
    packageName = '$PackageName'
    url = '$url'
$( if ( $filex86crc ) { "    checksum = '$filex86crc'" } )
    silentArgs = "$Args"
    fileType = 'exe'
    validExitCodes = @(0,3010)
}

Install-ChocolateyPackage @ChocoPackage
"@ | Out-File -FilePath "$Path\$ID\tools\chocolateyinstall.ps1" -Encoding utf8

#endregion 

#region CREATE_CHOCOLATEYUNINSTALL

Write-Verbose "Create $Path\$ID\tools\chocolateyuninstall.ps1"

@"

<#
.SYNOPSIS
Uninstall $ID

.DESCRIPTION
Uninstalls the $PackageName using the Chocolatey framework

.LINK
$friendlyURL
#>

`$Key = @( 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Uninstall\*',
          'HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\*',
          'HKLM:\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall\*' ) |
   Get-ItemProperty -ErrorAction SilentlyContinue | 
   where-object DisplayName -match '$PackageName'

`$Key | Out-String | Write-Verbose

`$ChocoPackage = @{
    SilentArgs = '/uninstall /quiet'
    packageName = '$PackageName'
    fileType = 'exe'
    file = `$key.BundleCachePath
    validExitCodes = @(0,3010)
}

Uninstall-ChocolateyPackage @ChocoPackage

"@ | Out-File -FilePath "$Path\$ID\tools\chocolateyuninstall.ps1" -Encoding utf8

#endregion

