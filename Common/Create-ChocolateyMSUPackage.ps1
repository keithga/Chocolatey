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
       [string] $url64bit,

       [Parameter(Mandatory=$false)]
       [string] $Features = "default"

)

#region PREP_ENVIRONMENT

function Get-MSIProperties ( $Path )
{
        write-verbose "Open: $Path"
        $WindowsInstaller = New-Object -com WindowsInstaller.Installer
        $MSIDatabase = $WindowsInstaller.GetType().InvokeMember("OpenDatabase","InvokeMethod",$Null,$WindowsInstaller,@($Path,0))
        if ( $MSIDatabase )
        {
                $View = $MSIDatabase.GetType().InvokeMember("OpenView","InvokeMethod",$null,$MSIDatabase,"SELECT * FROM Property")
                $View.GetType().InvokeMember("Execute", "InvokeMethod", $null, $View, $null) | out-null
                while($Record = $View.GetType().InvokeMember("Fetch","InvokeMethod",$null,$View,$null))
                {
                        @{ $Record.GetType().InvokeMember("StringData","GetProperty",$null,$Record,1) =
                           $Record.GetType().InvokeMember("StringData","GetProperty",$null,$Record,2)}
                }
                $View.GetType().InvokeMember("Close","InvokeMethod",$null,$View,$null) | out-null
        }
}



    if ( -not (Test-Path "$Path\$ID\tools") )
    {
        New-Item -Path "$Path\$ID\tools" -Force -ItemType Directory | Out-Null
    }

    if ( $url ) 
    { 
        $localfilex86 = [System.IO.Path]::GetTempFileName() + ".msi"
        (New-Object System.Net.WebClient).DownloadFile($url, $localfilex86)
        $filex86crc = Get-FileHash -Path $localfilex86 -Algorithm MD5 | select-object -ExpandProperty hash
        while ( Test-path $localfilex86 ) { Start-Sleep 1; Remove-Item -Force $localfilex86 -ErrorAction SilentlyContinue; write-verbose "delete..."}
    }

    if ( $url64bit ) 
    { 
        $localfilex64 = [System.IO.Path]::GetTempFileName() + ".msi"
        (New-Object System.Net.WebClient).DownloadFile($url64bit, $localfilex64)
        $filex64crc = Get-FileHash -Path $localfilex64 -Algorithm MD5 | select-object -ExpandProperty hash
        while ( Test-path $localfilex64 ) { Start-Sleep 1; Remove-Item -Force $localfilex64 -ErrorAction SilentlyContinue; write-verbose "delete..."}
    }

#endregion

#region CREATE_MANIFEST

@"
<?xml version="1.0" encoding="utf-8"?>
<!-- Do not remove this test for UTF-8: if “Ω” doesn’t appear as greek uppercase omega letter enclosed in quotation marks, you should use an editor that supports UTF-8, not this one. -->
<package xmlns="http://schemas.microsoft.com/packaging/2010/07/nuspec.xsd">
  <metadata>
    <!-- Read this before publishing packages to chocolatey.org: https://github.com/chocolatey/chocolatey/wiki/CreatePackages -->
    <id>$ID</id>
    <title>$PackageName</title>
    <version>$version</version>
    <authors>Microsoft</authors>
    <owners>Keith Garner</owners>
    <summary>$Summary</summary>
    <description>This package will silently install $PackageName .</description>
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
$( if ( $url64bit ) { "    url64bit = '$url64bit'" } )
$( if ( $filex86crc ) { "    checksum = '$filex86crc'" } )
$( if ( $filex64crc ) { "    checksum64 = '$filex64crc'" } )
    silentArgs = '/quiet /norestart'
    fileType = 'msu'
    validExitCodes = @(0,3010)
}

# ONLY run on Windows 7 (Version 6.1)
if ( [Environment]::OSVersion.Version.ToString().StartsWith("6.1") )
{
    Install-ChocolateyPackage @ChocoPackage
}
"@ | Out-File -FilePath "$Path\$ID\tools\chocolateyinstall.ps1" -Encoding utf8

#endregion 

