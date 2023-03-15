$installOptions = "";

$processorArchitecture = (Get-ItemProperty -Path 'HKLM:\System\CurrentControlSet\Control\Session Manager\Environment').PROCESSOR_ARCHITECTURE;
Write-Host "$processorArchitecture Processor Architecture Detected";

if ($processorArchitecture -eq "AMD64") {
    Write-Host "Supported";

    $installOptions = "--add Microsoft.VisualStudio.Workload.NetWeb;includeRecommended";
    $installOptions += " --add Microsoft.VisualStudio.Workload.ManagedDesktop;includeRecommended";
    $installOptions += " --add Microsoft.VisualStudio.Workload.NativeDesktop;includeRecommended";
    $installOptions += " --add Microsoft.VisualStudio.ComponentGroup.NativeDesktop.Llvm.Clang";
    $installOptions += " --add Microsoft.VisualStudio.Workload.Azure;includeRecommended";
    $installOptions += " --add Microsoft.VisualStudio.Workload.NetCrossPlat;includeRecommended";
    $installOptions += " --add Microsoft.VisualStudio.Workload.Data;includeRecommended";
    $installOptions += " --add Microsoft.NetCore.Component.Runtime.3.1";
    $installOptions += " --add Microsoft.NetCore.Component.Runtime.5.0";
    $installOptions += " --add Microsoft.VisualStudio.Component.TestTools.WebLoadTest";
    $installOptions += " --add icrosoft.VisualStudio.ComponentGroup.ArchitectureTools.Managed";
    $installOptions += " --remove Microsoft.VisualStudio.Component.Azure.Powershell";
}
elseif ($processorArchitecture -eq "ARM64") {
    Write-Host "Supported";

    $installOptions = "--add Microsoft.VisualStudio.Workload.NetWeb;includeRecommended";
    $installOptions += " --add Microsoft.VisualStudio.Workload.ManagedDesktop;includeRecommended";
    $installOptions += " --add Microsoft.VisualStudio.Workload.NativeDesktop;includeRecommended";
    $installOptions += " --add Microsoft.VisualStudio.ComponentGroup.NativeDesktop.Llvm.Clang";
    $installOptions += " --add Microsoft.VisualStudio.Component.TestTools.WebLoadTest";
}
else {
    Write-Host "NOT Supported";
}

if (! [String]::IsNullOrEmpty($installOptions)) {
    $installOptions += " --passive";
    $installOptions += " --norestart";
    $installOptions += " --wait";

    Write-Host "Installing Visual Studio with the following options";
    Write-Host $installOptions;

    winget install Microsoft.VisualStudio.2022.Enterprise --source winget --silent --accept-source-agreements --accept-package-agreements --override $installOptions
}
