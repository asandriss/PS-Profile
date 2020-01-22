Import-Module -Name posh-git

Start-SshAgent

function Test-Administrator {
    $user = [Security.Principal.WindowsIdentity]::GetCurrent();
    (New-Object Security.Principal.WindowsPrincipal $user).IsInRole([Security.Principal.WindowsBuiltinRole]::Administrator)
}

function sln($path = '.', $fileName = '') {
    if($fileName) {
        $s = ls $path $fileName
    } else {
        $s = ls $path *.sln -Rec | select -First 1;
    }

    if($s) { 
        start $s.FullName
    } else {
        write-host 'Solution file was not found' -foreground "yellow"
    }
}

# Make PS history permanent in order this to work need PSGet, PSUrl and PSGetLine installed

$HistoryFilePath = Join-Path ([Environment]::GetFolderPath('UserProfile')) .ps_history
Register-EngineEvent PowerShell.Exiting -Action { Get-History | Export-Clixml $HistoryFilePath } | out-null
if (Test-path $HistoryFilePath) { Import-Clixml $HistoryFilePath | Add-History }
# if you don't already have this configured...
Set-PSReadlineKeyHandler -Key UpArrow -Function HistorySearchBackward
Set-PSReadlineKeyHandler -Key DownArrow -Function HistorySearchForward

# Init VC build tools
# & "c:\Program Files (x86)\Microsoft Visual Studio\2019\Community\VC\Auxiliary\Build\vcvarsall.bat" x86

function Invoke-BatchFile
{
    param([string]$Path, [string]$Parameters)

    $tempFile = [IO.Path]::GetTempFileName()

    ## Store the output of cmd.exe.  We also ask cmd.exe to output
    ## the environment table after the batch file completes
    cmd.exe /c " `"$Path`" $Parameters && set " > $tempFile

    ## Go through the environment variables in the temp file.
    ## For each of them, set the variable in our local environment.
    Get-Content $tempFile | Foreach-Object {
        if ($_ -match "^(.*?)=(.*)$") {
            Set-Content "env:\$($matches[1])" $matches[2]
        }
        else {
            $_
        }
    }

    Remove-Item $tempFile
}

$VcVars = 'c:\Program Files (x86)\Microsoft Visual Studio\2019\Community\VC\Auxiliary\Build\vcvarsall.bat'
Invoke-BatchFile $VcVars x64
