# Setup script for chocoinstall.ps1 - Menu driven Choco Install Tool
#
# Author: Jesper Berth, Arrow ECS, jesper.berth@arrow.com - 13. November 2018
# Version 0.0.2
Set-ExecutionPolicy -ExecutionPolicy Unrestricted -Scope CurrentUser -ErrorAction SilentlyContinue
# Install Folder
$url = "https://raw.githubusercontent.com/jesperberth/supporttool/master/supporttool.ps1"
$url2 = "https://raw.githubusercontent.com/jesperberth/supporttool/master/fileprint.ps1"
$url3 = "https://raw.githubusercontent.com/jesperberth/supporttool/master/update.ps1"
$installdir = "$home\appdata\local\supporttool"
$supportfile = "$installdir\supporttool.ps1"
$fileprintfile = "$installdir\fileprint.ps1"
$updatefile = "$installdir\update.ps1"

If(!(test-path $installdir))
{
      New-Item -ItemType Directory -Force -Path $installdir
}

# Download SupportScript
Invoke-WebRequest -Uri $url -OutFile $supportfile
Invoke-WebRequest -Uri $url2 -OutFile $fileprintfile
Invoke-WebRequest -Uri $url3 -OutFile $updatefile

# Run Script - runs script with Elevated Rights
$runscriptfile = "$installdir\run.ps1"
$runscript = "Start-Process powershell -Verb runAs 'Set-ExecutionPolicy Bypass -Scope Process -Force; Invoke-Expression $supportfile'"

# Desktop File
$desktopfile = "$home\Desktop\Support.cmd"
$desktopfilescript = "powershell.exe $runscriptfile"

# Create Files
Out-File $runscriptfile -InputObject $runscript -Encoding utf8
Out-File $desktopfile -InputObject $desktopfilescript -Encoding ascii

Exit
