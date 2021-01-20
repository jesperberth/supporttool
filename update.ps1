# Update script for supporttool.ps1 - Menu driven Choco Install Tool
#
# Author: Jesper Berth, Arrow ECS, jesper.berth@arrow.com - 13. November 2018
# Version 0.0.2
#Set-ExecutionPolicy -ExecutionPolicy Unrestricted -Scope CurrentUser -ErrorAction SilentlyContinue
# Install Folder
$url = "https://raw.githubusercontent.com/jesperberth/supporttool/master/supporttool.ps1"
$url2 = "https://raw.githubusercontent.com/jesperberth/supporttool/master/fileprint.ps1"
$installdir = "$home\appdata\local\supporttool"
$supportfile = "$installdir\supporttool.ps1"
$fileprintfile = "$installdir\fileprint.ps1"

write-host "Download Updates"
# Download SupportScript
Remove-Item $supportfile
remove-item $fileprintfile

Invoke-WebRequest -Uri $url -OutFile $supportfile
Invoke-WebRequest -Uri $url2 -OutFile $fileprintfile

exit 0