Install-Module -Name VSSetup -Scope CurrentUser

if ((Get-VSSetupInstance).InstallationVersion -ge "17.0") {
    Write-Host "Found instance of VS 2022 - Skipping install"
    -Join ("Product Name".PadRight(20), ": ", (Get-VSSetupInstance).DisplayName, "`n", "InstallationPath".PadRight(20), ": ", (Get-VSSetupInstance).InstallationPath)
}
else {
    Write-Host "Downloading VS setup bootstrapper"
    $toolsDir = (Join-Path "$(Split-Path -parent $MyInvocation.MyCommand.Definition)" 'vs')
    $vsPath = Join-Path "$toolsDir" "\vs_enterprise.exe"
    New-Item -Path $toolsDir  -ItemType directory -Force

    $url="https://aka.ms/vs/17/release/vs_enterprise.exe"
    (New-Object System.Net.WebClient).DownloadFile($url, "$vsPath")

    Write-Host "Installing VS 2022 with Base Workloads"
    $commandArgs = @("--installPath `"$(Join-Path ${env:ProgramFiles(x86)} `"Microsoft Visual Studio\2022\Enterprise`")`"")
    $commandArgs += "--add Microsoft.VisualStudio.Workload.CoreEditor;includeRecommended"
    $commandArgs += "--add Microsoft.VisualStudio.Workload.Azure;includeRecommended"
    $commandArgs += "--remove Microsoft.VisualStudio.Component.Azure.Compute.Emulator"
    $commandArgs += "--remove Microsoft.VisualStudio.Component.Azure.Powershell"
    $commandArgs += "--add Microsoft.VisualStudio.Workload.Data;includeRecommended"
    $commandArgs += "--add Microsoft.VisualStudio.Workload.ManagedDesktop;includeRecommended"
    $commandArgs += "--add Microsoft.VisualStudio.Workload.NetWeb;includeRecommended"
    $commandArgs += "--add Microsoft.NetCore.Component.Runtime.3.1"
    $commandArgs += "--add Microsoft.NetCore.Component.Runtime.5.0"
    $commandArgs += "--add Microsoft.Net.Component.4.6.1.TargetingPack"
    $commandArgs += "--add Microsoft.Net.Component.4.6.2.TargetingPack"
    $commandArgs += "--add Microsoft.Net.Component.4.7.TargetingPack"
    $commandArgs += "--add Microsoft.Net.Component.4.7.1.TargetingPack"
    $commandArgs += "--add Microsoft.Net.Component.4.7.2.TargetingPack"
    $commandArgs += "--add Microsoft.VisualStudio.Component.ClassDesigner"
    $commandArgs += "--add Microsoft.VisualStudio.Component.CodeClone"
    $commandArgs += "--add Microsoft.VisualStudio.Component.CodeMap"
    $commandArgs += "--add Microsoft.VisualStudio.Component.GraphDocument"
    $commandArgs += "--add Microsoft.VisualStudio.Component.SQL.LocalDB.Runtime"
    $commandArgs += "--passive"
    $commandArgs += "--norestart"
    $commandArgs += "--wait"

    $p = Start-Process -FilePath $vsPath -ArgumentList $commandArgs -PassThru -Wait

    if ($p.ExitCode -eq 0 -or $p.ExitCode -eq 3010) {
        Write-Host "VS 2022 installation completed successfully" -ForegroundColor Green
    }
    else {
        Write-Error (-Join("VS 2022 installation failed ", $p.ExitCode))
    }

    $p.Dispose()
}
