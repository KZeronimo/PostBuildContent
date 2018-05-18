# Only load oh-my-posh if PS is running from ConEmu
if ($env:ConEmuTask -or $env:ConEmuPID)
{
    # Import oh-my-posh and dependecies
    Import-Module -Name posh-git -ErrorAction SilentlyContinue
    Import-Module -Name oh-my-posh
	# Shorten prompt by providing your uesername
	$DefaultUser = $env:UserName
}
else
{
    # Load posh-git
    Import-Module -Name posh-git
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
