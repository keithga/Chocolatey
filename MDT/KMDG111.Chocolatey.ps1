[CmdletBinding()]
param()

$ChocoPackage = @{
    ID = 'KMDF'
    Version = '1.11'
    Tags = 'Win7 Win2008 KMDF Kernel-Mode'
    packageName = 'Microsoft Kernel-Mode Driver Framework version 1.11'
    friendlyUrl = 'https://www.microsoft.com/en-us/download/details.aspx?id=38423'
    Summary = 'KMDF supports kernel-mode drivers that are written specifically to use it. KMDF driver packages that are built by using Windows Driver Kit for Windows 8 can automatically redistribute and install version 1.11 of the files.'
    url = 'http://download.microsoft.com/download/E/0/3/E0337D5A-8918-45D0-91DB-EAF6C0973248/kmdf-1.11-Win-6.1-x86.msu'
    url64bit = 'http://download.microsoft.com/download/E/0/3/E0337D5A-8918-45D0-91DB-EAF6C0973248/kmdf-1.11-Win-6.1-x64.msu'
}

& $PSScriptRoot\Create-ChocolateyMSUPackage.ps1 -Path $PSScriptRoot\Build\KMDF @ChocoPackage