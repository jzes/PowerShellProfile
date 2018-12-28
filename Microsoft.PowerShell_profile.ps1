$user = "C:\Users\jpsneto"
$programas = "$user\programas\"
colortool -q "$programas\schemes\monokai.itemcolors"
Set-location $user

function Write-BranchName () {
    try {
        $branch = git rev-parse --abbrev-ref HEAD
		
		$gitStatus = (git status | Out-String).Split()
		
        if ($gitStatus -contains "Untracked" -and $gitStatus -contains "files:") {
            # we're probably in detached HEAD state, so print the SHA
            Write-Host " ($branch)" -ForegroundColor "red"
        }
		elseif($gitStatus -contains "Changes" -and $gitStatus -contains "not" -and $gitStatus -contains "staged"){
            # we're on an actual branch, so print it
            Write-Host " ($branch)" -ForegroundColor "red"
        }
        elseif($gitStatus -contains "Changes" -and $gitStatus -contains "committed:"){
            # we're on an actual branch, so print it
            Write-Host " ($branch)" -ForegroundColor "yellow"
        }		
		else{
			# we're on an actual branch, so print it
            Write-Host " ($branch)" -ForegroundColor "green"
		}
    } catch {
        # we'll end up here if we're in a newly initiated git repo
        Write-Host " (no branches yet)" -ForegroundColor "yellow"
    }
}

function prompt {
    $base = "~ "
    $path = "$($executionContext.SessionState.Path.CurrentLocation)"
    $userPrompt = "$('>' * ($nestedPromptLevel + 1)) "

    Write-Host "`n$base" -NoNewline

    if (Test-Path .git) {
        Write-Host $path -NoNewline -ForegroundColor "green"
        Write-BranchName
    }
    else {
        # we're not in a repo so don't bother displaying branch name/sha
        Write-Host $path -ForegroundColor "green"
    }

    return $userPrompt
}
# Chocolatey profile
$ChocolateyProfile = "$env:ChocolateyInstall\helpers\chocolateyProfile.psm1"
if (Test-Path($ChocolateyProfile)) {
  Import-Module "$ChocolateyProfile"
}

#caminhos
$lab = "$user\workdir\repos\"

#modulos
Import-Module $user\programas\RSSCleanCode.psm1
Import-Module $user\programas\setFont.psm1
Import-Module $user\programas\LSColor.psm1

Set-ConsoleFont 6