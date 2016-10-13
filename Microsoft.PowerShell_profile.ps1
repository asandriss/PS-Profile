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
