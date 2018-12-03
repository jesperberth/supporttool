# Setup script for chocoinstall.ps1 - Menu driven Choco Install Tool
#
# Author: Jesper Berth, Arrow ECS, jesper.berth@arrow.com - 13. November 2018
# Version 0.0.1
Set-ExecutionPolicy -ExecutionPolicy Unrestricted -Scope CurrentUser
# Install Folder
$url = "https://www.berthit.dk/choco/supporttool.ps1"
$installdir = "$home\appdata\local\supporttool"
$supportfile = "$installdir\supporttool.ps1"
mkdir $installdir

# Download SupportScript
Invoke-WebRequest -Uri $url -OutFile $supportfile

# Run Script - runs script with Elevated Rights
$runscriptfile = "$installdir\run.ps1"
$runscript = "Start-Process powershell -Verb runAs 'Set-ExecutionPolicy Bypass -Scope Process -Force; Invoke-Expression $supportfile'"

# Desktop File
$desktopfile = "$home\Desktop\Support.cmd"
$desktopfilescript = "powershell.exe '$runscriptfile'" 

# Create Files
Out-File $runscriptfile -InputObject $runscript -Encoding utf8
Out-File $desktopfile -InputObject $desktopfilescript -Encoding utf8