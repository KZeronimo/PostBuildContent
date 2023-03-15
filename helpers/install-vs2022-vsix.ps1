Install-Module -Name VSSetup -Scope CurrentUser

$processorArchitecture = (Get-ItemProperty -Path 'HKLM:\System\CurrentControlSet\Control\Session Manager\Environment').PROCESSOR_ARCHITECTURE;
Write-Host "$processorArchitecture Processor Architecture Detected";

if ($processorArchitecture -eq "AMD64" -or $processorArchitecture -eq "ARM64") {
    Write-Host "Supported"
    Write-Host "Installing common Visual Studio extenstions"

    # Install extenstions suppored on both architectures

    Write-Host "Installing $processorArchitecture Visual Studio extenstions"
}

if ($processorArchitecture -eq "AMD64") {
    # Install Open Command Line VSIX AMD Only
    & C:\_PostBuildContent\helpers\install-vsix.ps1 -Name OpenCommandLine -Url https://marketplace.visualstudio.com/_apis/public/gallery/publishers/MadsKristensen/vsextensions/OpenCommandLine64/2.5.238/vspackage

    # Install Clean Solution VSIX AMD Only
    & C:\_PostBuildContent\helpers\install-vsix.ps1 -Name CleanSolution -Url https://marketplace.visualstudio.com/_apis/public/gallery/publishers/MadsKristensen/vsextensions/CleanSolution/1.4.35/vspackage

    # Install License Header Manager VSIX AMD Only
    & C:\_PostBuildContent\helpers\install-vsix.ps1 -Name LicenseHeaderManager -Url https://marketplace.visualstudio.com/_apis/public/gallery/publishers/StefanWenig/vsextensions/LicenseHeaderManager/5.0.1/vspackage

    # Install VS Theme Pack VSIX AMD Only
    & C:\_PostBuildContent\helpers\install-vsix.ps1 -Name VS-ColorThemes -Url https://marketplace.visualstudio.com/_apis/public/gallery/publishers/idex/vsextensions/vsthemepack/1.2/vspackage

    # Install Azure IoT Edge Tools VSIX AMD Only
    & C:\_PostBuildContent\helpers\install-vsix.ps1 -Name IoTEdgeTools -Url https://marketplace.visualstudio.com/_apis/public/gallery/publishers/vsc-iot/vsextensions/vs17iotedgetools/2.0.8/vspackage
}
elseif ($processorArchitecture -eq "ARM64") {
}
else {
    Write-Host "NOT Supported";
}
