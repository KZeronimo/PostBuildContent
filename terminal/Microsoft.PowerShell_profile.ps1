# Only load oh-my-posh if PS is running from ConEmu, Windows Terminal, or Terminal in vscode
if ($env:ConEmuTask -or $env:ConEmuPID -or $env:WT_SESSION -or $env:TERM_PROGRAM -eq "vscode")
{
    # Shorten prompt by providing your uesername
    $env:POSH_SESSION_DEFAULT_USER = [System.Environment]::UserName
    # Import oh-my-posh and dependecies
    Import-Module -Name posh-git -ErrorAction SilentlyContinue
    oh-my-posh --init --shell pwsh --config $env:POSH_THEMES_PATH\agnoster-mesh.omp.json | Invoke-Expression
}
else
{
    # Load posh-git
    Import-Module -Name posh-git -ErrorAction SilentlyContinue
}

# Chocolatey profile
$ChocolateyProfile = "$env:ChocolateyInstall\helpers\chocolateyProfile.psm1"
if (Test-Path($ChocolateyProfile))
{
  Import-Module "$ChocolateyProfile"
}

# Load posh-docker module
if (Get-Module -ListAvailable -Name posh-docker)
{
    Import-Module -Name posh-docker
}

# Alias
Set-Alias -Name c -Value clear
Function Exit { exit; }; Set-Alias -Name q -Value Exit
Function HomeDir { cd ~; }; Set-Alias -Name ~ -Value HomeDir
Function Up1Dir { cd ..; }; Set-Alias -Name .. -Value Up1Dir
Function Up2Dir { cd ../..; }; Set-Alias -Name ... -Value Up2Dir
Function SandboxSourceDir { cd c:/_Src/Sdbx; ls; }; Set-Alias -Name sdbx -Value SandboxSourceDir
Function ProdSourceDir { cd c:/_Src/Prod; ls; }; Set-Alias -Name prod -Value ProdSourceDir
Function DotFileGit { & git --git-dir=$env:UserProfile/.myconf/ --work-tree=$env:UserProfile $args; }; Set-Alias -Name cfg -Value DotFileGit
