# Menu driven Support Tool
#
# Author: Jesper Berth, Arrow ECS, jesper.berth@arrow.com - 13. November 2018
# Version 0.0.1
function Show-Menu
{
    param (
        [string]$Title = "Support Tool"
    )
    Clear-Host
    Write-Host "=========== $Title ============`n"
    Write-Host "1: Install Standard Software"
    Write-Host "2: Install Adobe Creative Suite"
    Write-Host "3: Install Programming Suite"
    Write-Host "4: Run Support Tool"
    Write-Host "==============================="
    Write-Host "Q: Press 'Q' to quit."
    Write-Host "==============================="
}

function InstallChoco {
    write-host "Install Choco`n"
    Set-ExecutionPolicy Bypass -Scope Process -Force; Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
}

function ChocoInstalled {
    write-host "Checking if choco is installed?`n"
        if(get-command choco -ErrorAction SilentlyContinue){
            write-host "Choco is installed`n"
        }
        else {
            write-host -ForegroundColor red "Choco is not Installed`n"
            InstallChoco
        }
    
    
}

function ChocoInstall($program){

    write-host -ForegroundColor Green "Install $program`n"
    choco install $program -y
}

function InstallStandard {
    write-host -ForegroundColor Green "Install Standard Software`n"
    
    $programlist = @(
    "office365business",
    "microsoft-teams",
    "googlechrome",
    "firefox",
    "7zip",
    "adobereader",
    "flashplayerplugin",
    "flashplayeractivex"
    )

    foreach ($item in $programlist){
        ChocoInstall $item
    }
}

function InstallAdobeCreative {
    write-host -ForegroundColor Green "Install Adobe Creative Suite`n"
    $programlist = @(
    "adobe-creative-cloud"
    )

    foreach ($item in $programlist){
        ChocoInstall $item
    }
}

function InstallCode {
    write-host -ForegroundColor Green "Install Programming Suite`n"
    $programlist = @(
    "vscode"
    )

    foreach ($item in $programlist){
        ChocoInstall $item
    }
}
function RunSupport {
    write-host -ForegroundColor Green "Download and run Teamviewer`n"
    $uri = "https://download.teamviewer.com/download/TeamViewerQS.exe"
    $outfile = "$home\TeamViewerQS.exe"
    Invoke-WebRequest -Uri $uri -OutFile $outfile
    write-host -ForegroundColor Yellow "*** Starting TeamViewer Quick Support ***`n"
    & $outfile
}

ChocoInstalled
do
 {
     Show-Menu
     $selection = Read-Host "Please make a selection"
     switch ($selection)
     {
         '1' {
             Clear-Host            
             InstallStandard
         } '2' {
             Clear-Host
             InstallAdobeCreative
         } '3' {
             Clear-Host
             InstallCode
         } '4' {
             Clear-Host
             RunSupport
            }
     }
     pause
 }
 until ($selection -eq 'q')