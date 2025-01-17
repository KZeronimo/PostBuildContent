Param (
    [Parameter(Mandatory = $true)]
    [string]$Url,
    [Parameter(Mandatory = $false)]
    [string]$FontFilesFilter = '*'

)

choco install chocolatey-font-helpers.extension -y
Import-Module "$env:ChocolateyInstall\helpers\chocolateyInstaller.psm1" -Force

$fontsDir = (Join-Path "$(Split-Path -parent $MyInvocation.MyCommand.Definition)" 'fonts')
$uri = $url -as [System.Uri]
$fileName = $uri.Segments[($uri.Segments.Length - 1)]
$filePath = (Join-Path $fontsDir $fileName)
$fileExtension = (New-Object System.IO.FileInfo($fileName)).Extension

if (! (Test-Path -Path $fontsDir -PathType Container)) {
    New-Item -ItemType Directory -Path $fontsDir | Out-Null
}

Write-Host "Downloading font file $fileName ..." -ForegroundColor Green
Invoke-WebRequest -UseBasicParsing $Url -OutFile $filePath
if ($fileExtension.ToLower() -eq '.zip') {
	Expand-Archive -Path $filePath -DestinationPath $fontsDir -Force | Out-Null
}

Write-Host "Installing font file $fileName ..." -ForegroundColor Green
$fontFiles = Get-ChildItem $fontsDir -Recurse -Filter $FontFilesFilter
Install-ChocolateyFont $fontFiles.FullName -multiple

Remove-Item $fontsDir -Recurse -Force
