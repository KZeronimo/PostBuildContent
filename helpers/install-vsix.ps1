Param (
    [Parameter(Mandatory = $true)]
    [string]$Name,
    [Parameter(Mandatory = $true)]
    [string]$Url,
    [Parameter(Mandatory = $false)]
    $SessionGuid = (New-Guid)
) #end param

Import-Module "$env:ChocolateyInstall\helpers\chocolateyInstaller.psm1" -Force

# From https://florianwinkelbauer.com/posts/2019-03-07-install-vsix-powershell/
function Get-VsixFile {
    param(
        [Parameter(Mandatory = $true)]
        [string]$Url,
        [Parameter(Mandatory = $true)]
        [string]$SessionGuid
    )

    $file = New-TemporaryFile
    # create a session that will be used to download from marketplace.visualstudio.com
    $session = New-Object Microsoft.PowerShell.Commands.WebRequestSession
    $cookie = New-Object System.Net.Cookie("Gallery-Service-UserIdentifier", $SessionGuid, "/", "marketplace.visualstudio.com")
    $session.Cookies.Add($cookie)

    try {
        Invoke-WebRequest -UseBasicParsing -Uri $Url -Method Get -WebSession $session -OutFile $file
        return $file
    }
    catch {
        Remove-Item $file -Force
        throw $_
    }
}

$installPath = (Get-VSSetupInstance).InstallationPath

if (!$installPath) {
    throw "There was an error finding latest Visual Studio install location. Please make sure Visual Studio is installed correctly."
}

Write-Host "Downloading the $Name Visual Studio Extension ... "
$file = Get-VsixFile -Url $Url -SessionGuid $SessionGuid

if ($null -ne $file) {
    Write-Host "Installing the $Name Visual Studio Extension ... "
    $vsixInstaller = gci -File -Recurse -Filter vsixinstaller.exe -Path $installPath
    $result = Install-Vsix -Installer $vsixInstaller.FullName -InstallFile $file
}
else {
    throw "Visual Studio Extension $Name is not available for install."
}

if ($result -eq 2004) {
    #2004: Blocking Process (need to close VS)
    throw "A process is blocking the installation of the Visual Studio Extension. Please close all Visual Studio instances and try again."
}

if ($result -gt 0 -and $result -ne 1001) {
    #1001: Already installed
    throw "There was an error installing the $Name Visual Studio Extension. The exit code returned was $result."
}

Write-Host "Successfully installed the $Name Visual Studio Extension with result $result." -ForegroundColor Green
