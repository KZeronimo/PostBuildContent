# Only load oh-my-posh if PS is running from ConEmu or Windows Terminal
if ($env:ConEmuTask -or $env:ConEmuPID -or $env:WT_SESSION)
{
    # Import oh-my-posh and dependecies
    Import-Module -Name posh-git -ErrorAction SilentlyContinue
    Import-Module -Name oh-my-posh
    # Set Theme
    Set-Theme Agnoster
	# Shorten prompt by providing your uesername
	$DefaultUser = $env:USERNAME
	# Substituions in WT for Cascadia Code Nerd Fonts
	if ($env:WT_SESSION)
	{
		$ThemeSettings.PromptSymbols.ElevatedSymbol = [char]::ConvertFromUtf32(0x26A1)
		$ThemeSettings.PromptSymbols.FailedCommandSymbol = [char]::ConvertFromUtf32(0xE20D)
	}
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
