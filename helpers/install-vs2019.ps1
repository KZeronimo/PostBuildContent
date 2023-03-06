Install-Module -Name VSSetup -Scope CurrentUser

if ((Get-VSSetupInstance).InstallationVersion -ge "16.0") {
    Write-Host "Found instance of VS 2019 - Skipping install"
    -Join ("Product Name".PadRight(20), ": ", (Get-VSSetupInstance).DisplayName, "`n", "InstallationPath".PadRight(20), ": ", (Get-VSSetupInstance).InstallationPath)
}
else {
    Write-Host "Downloading VS setup bootstrapper"
    $toolsDir = (Join-Path "$(Split-Path -parent $MyInvocation.MyCommand.Definition)" 'vs')
    $vsPath = Join-Path "$toolsDir" "\vs_enterprise.exe"
    New-Item -Path $toolsDir  -ItemType directory -Force

    $url="https://aka.ms/vs/16/release/vs_enterprise.exe"
    (New-Object System.Net.WebClient).DownloadFile($url, "$vsPath")

    Write-Host "Installing VS 2019 with Base Workloads"
    $commandArgs = @("--installPath `"$(Join-Path ${env:ProgramFiles(x86)} `"Microsoft Visual Studio\2019\Enterprise`")`"")
    $commandArgs += "--add Microsoft.VisualStudio.Workload.CoreEditor;includeRecommended"
    $commandArgs += "--add Microsoft.VisualStudio.Workload.Data;includeRecommended"
    $commandArgs += "--add Microsoft.VisualStudio.Workload.ManagedDesktop;includeRecommended"
    $commandArgs += "--add Microsoft.VisualStudio.Workload.NetCoreTools;includeRecommended"
    $commandArgs += "--add Microsoft.VisualStudio.Workload.NetWeb;includeRecommended"
    $commandArgs += "--add Microsoft.VisualStudio.Workload.Azure;includeRecommended"
    $commandArgs += "--add Microsoft.VisualStudio.Workload.NativeDesktop;includeRecommended"
	$commandArgs += "--add Microsoft.Net.Component.4.6.1.TargetingPack"
	$commandArgs += "--add Microsoft.Net.Component.4.6.2.TargetingPack"
	$commandArgs += "--add Microsoft.Net.Component.4.7.TargetingPack"
    $commandArgs += "--add Microsoft.Net.Component.4.7.1.TargetingPack"
    $commandArgs += "--add Microsoft.Net.ComponentGroup.4.8.DeveloperTools"
    $commandArgs += "--add Microsoft.VisualStudio.ComponentGroup.ArchitectureTools.Managed"
	$commandArgs += "--add Microsoft.VisualStudio.Component.TestTools.WebLoadTest"
    $commandArgs += "--passive"
    $commandArgs += "--norestart"
    $commandArgs += "--wait"

    $p = Start-Process -FilePath $vsPath -ArgumentList $commandArgs -PassThru -Wait

    if ($p.ExitCode -eq 0 -or $p.ExitCode -eq 3010) {
        Write-Host "VS 2019 installation completed successfully" -ForegroundColor Green
    }
    else {
        Write-Error (-Join("VS 2019 installation failed ", $p.ExitCode))
    }

    $p.Dispose()
}
