function Get-ScriptDirectory {
  $thisName = $MyInvocation.MyCommand.Name
  [IO.Path]::GetDirectoryName((Get-Content function:$thisName).File)
}

# install source SourceCodePro
cinst sourcecodepro -y

# install SourceCodeProPatched
$fontHelpersPath = (Join-Path (Get-ScriptDirectory ) 'FontHelpers.ps1')
  # TODO - executing font helpers at this point seems redundant and causes errors - investigate
  #. $fontHelpersPath

$fontUrl = 'https://github.com/gabrielelana/awesome-terminal-fonts/blob/patching-strategy/patched/SourceCodePro+Powerline+Awesome+Regular.ttf?raw=true'
$destinationFolder = Join-Path $Env:Temp 'SourceCodeProPatched'
$destination = Join-Path $destinationFolder 'SourceCodePro+Powerline+Awesome+Regular.ttf'

Write-Host "Downloading SourceCodePro+Powerline+Awesome+Regular"
New-Item -path $destinationFolder -type directory -force
(New-Object System.Net.WebClient).DownloadFile($fontUrl, $destination)

$shell = New-Object -ComObject Shell.Application
$fontsFolder = $shell.Namespace(0x14)

$fontFiles = Get-ChildItem $destination -Recurse -Filter *.ttf

# unfortunately the font install process totally ignores shell flags :(
# http://social.technet.microsoft.com/Forums/en-IE/winserverpowershell/thread/fcc98ba5-6ce4-466b-a927-bb2cc3851b59
# so resort to a nasty hack of compiling some C#, and running as admin instead of just using CopyHere(file, options)
$commands = $fontFiles |
  % { Join-Path $fontsFolder.Self.Path $_.Name } |
  ? { Test-Path $_ } |
  % { "Remove-SingleFont '$_' -Force;" }

# http://blogs.technet.com/b/deploymentguys/archive/2010/12/04/adding-and-removing-fonts-with-windows-powershell.aspx
$fontFiles |
  % { $commands += "Add-SingleFont '$($_.FullName)';" }

$toExecute = ". $fontHelpersPath;" + ($commands -join ';')
Write-Host "Installing SourceCodePro+Powerline+Awesome+Regular"
Start-Process powershell -Verb runAs -ArgumentList $toExecute -Wait -WindowStyle hidden

Remove-Item $destinationFolder -Recurse
