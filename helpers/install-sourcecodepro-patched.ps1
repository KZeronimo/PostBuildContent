# install source SourceCodePro
cinst sourcecodepro -y

# install SourceCodeProPatched
cinst chocolatey-font-helpers.extension
Import-Module "$env:ChocolateyInstall\helpers\chocolateyInstaller.psm1" -Force

$fontUrl = 'https://github.com/gabrielelana/awesome-terminal-fonts/blob/patching-strategy/patched/SourceCodePro+Powerline+Awesome+Regular.ttf?raw=true'
$destinationFolder = Join-Path $Env:Temp 'SourceCodeProPatched'
$destination = Join-Path $destinationFolder 'SourceCodePro+Powerline+Awesome+Regular.ttf'

Write-Host "Downloading SourceCodePro+Powerline+Awesome+Regular" -ForegroundColor Green
New-Item -path $destinationFolder -type directory -force
(New-Object System.Net.WebClient).DownloadFile($fontUrl, $destination)

Write-Host "Installing SourceCodePro+Powerline+Awesome+Regular" -ForegroundColor Green
Install-ChocolateyFont $destination

Remove-Item $destinationFolder -Recurse
