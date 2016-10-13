# Import-Module -Name posh-git 

Start-SshAgent


# Load posh-git example profile
. 'C:\Users\fedor.hajdu\Documents\Projects\posh-git\profile.example.ps1'

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