Install-Module -Name VSSetup -Scope AllUsers

if ((Get-VSSetupInstance).InstallationVersion -ge "16.0") {
    Write-Host "Found instance of VS 2019 - Skipping install"
    -Join ("Product Name".PadRight(20), ": ", (Get-VSSetupInstance).DisplayName, "`n", "InstallationPath".PadRight(20), ": ", (Get-VSSetupInstance).InstallationPath)
}
else {
    Write-Host "Downloading VS setup bootstrapper"
    $contentPath = "C:\_PostBuildContent"
    $vsPath = Join-Path "$contentPath" "\vs_enterprise.exe"
    New-Item -Path $contentPath  -ItemType directory -Force

    iwr -Uri https://aka.ms/vs/16/release/vs_enterprise.exe -OutFile "$vsPath"

    Write-Host "Installing VS 2019 with Base Workloads"
    $commandPath = "C:\_PostBuildContent\vs_enterprise.exe"
    $commandArgs = @("--installPath `"$(Join-Path ${env:ProgramFiles(x86)} `"Microsoft Visual Studio\2019\Enterprise`")`"")
    $commandArgs += "--add Microsoft.VisualStudio.Workload.CoreEditor;includeRecommended"
    $commandArgs += "--add Microsoft.VisualStudio.Workload.Data;includeRecommended"
    $commandArgs += "--add Microsoft.VisualStudio.Workload.ManagedDesktop;includeRecommended"
    $commandArgs += "--add Microsoft.VisualStudio.Workload.NetCoreTools;includeRecommended"
    $commandArgs += "--add Microsoft.VisualStudio.Workload.NetWeb;includeRecommended"
    $commandArgs += "--add Microsoft.VisualStudio.Workload.Azure;includeRecommended"
	$commandArgs += "--add Microsoft.Net.ComponentGroup.4.6.1.DeveloperTools"
	$commandArgs += "--add Microsoft.Net.ComponentGroup.4.6.2.DeveloperTools"
	$commandArgs += "--add Microsoft.Net.ComponentGroup.4.7.DeveloperTools"
	$commandArgs += "--add Microsoft.Net.ComponentGroup.4.7.1.DeveloperTools"
	$commandArgs += "--add Microsoft.NetCore.ComponentGroup.DevelopmentTools.2.2"
	$commandArgs += "--add Microsoft.NetCore.ComponentGroup.Web.2.2"
    $commandArgs += "--add Microsoft.VisualStudio.ComponentGroup.ArchitectureTools.Managed"
	$commandArgs += "--add Microsoft.VisualStudio.Component.TestTools.WebLoadTest"
    $commandArgs += "--passive"
    $commandArgs += "--norestart"
    $commandArgs += "--wait"

    $p = Start-Process -FilePath $commandPath -ArgumentList $commandArgs -PassThru -Wait

    if ($p.ExitCode -eq 0 -or $p.ExitCode -eq 3010) {
        Write-Host "VS 2019 installation completed successfully" -ForegroundColor Green
    }
    else {
        Write-Error (-Join("VS 2019 installation failed ", $p.ExitCode))
    }

    $p.Dispose()
}
