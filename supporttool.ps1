﻿# Menu driven Support Tool
#
# Author: Jesper Berth, Arrow ECS, jesper.berth@arrow.com - 13. November 2018
# Version 1.0.0
function Show-Menu
{
    param (
        [string]$Title = "Support Tool - 240321-1"
    )
    Clear-Host
    Write-Host "======== $Title ========`n"
    Write-Host "1: Install Standard Software"
    Write-Host "3: Install Programming Suite"
    Write-Host "4: Install Video Suite"
    Write-Host -ForegroundColor Yellow "5: Run TeamViewer"
    Write-Host "6: Setup Netshare and Print"
    Write-Host "==============================="
    Write-Host "77: Clear printers"
    Write-Host "88: Clear Cached Credential"
    Write-Host "99: Run Driver Tool"
    Write-Host "U: Update Tool"
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
    "vlc",
    "microsoft-edge",
    "filezilla"
    )

    foreach ($item in $programlist){
        ChocoInstall $item
    }
}

function drivertool {
    Write-Host -ForegroundColor Yellow "Detecting Hardware manufactor`n"

    $ComputerHW = Get-WmiObject -Class Win32_ComputerSystem
    $ComputerInfoManufacturer = $ComputerHW.Manufacturer

    if($ComputerInfoManufacturer -eq "Lenovo" ){
        write-host "Install Support tool for Lenovo"
        ChocoInstall lenovo-thinkvantage-system-update
    }elseif ($ComputerInfoManufacturer -eq "Hewlett Packert") {
        write-host "Hewlett Packert"
        write-host "No Support tool for this Computer"
    }else{
        write-host "No Support tool for this Computer"
    }

    write-host  "Hardware vendor: $ComputerInfoManufacturer"
}

function InstallCode {
    write-host -ForegroundColor Green "Install Programming Suite`n"
    $programlist = @(
    "vscode",
    "sublimetext3",
    "cyberduck",
    "brackets",
    "safari"
    )

    foreach ($item in $programlist){
        ChocoInstall $item
    }
}

function InstallVideo {
    write-host -ForegroundColor Green "Install Video Suite`n"
    $programlist = @(
    "handbrake.install"
    )

    foreach ($item in $programlist){
        ChocoInstall $item
    }
}
function RunSupport {
    write-host -ForegroundColor Green "Download and run Teamviewer`n"
    $uri = "https://download.teamviewer.com/download/TeamViewerQS.exe"
    $outfile = "$home\TeamViewerQS.exe"
    if(Test-Path $outfile -PathType Leaf){
        write-host -ForegroundColor Yellow "*** Starting TeamViewer Quick Support ***`n"
        & $outfile
    }
    else {
        Invoke-WebRequest -Uri $uri -OutFile $outfile
        write-host -ForegroundColor Yellow "*** Starting TeamViewer Quick Support ***`n"
        & $outfile
    }
}

function RunNetPrint {
    if(get-command Get-StoredCredential -ErrorAction SilentlyContinue){
        write-host -ForegroundColor Green "CredentialManager is installed"
    }
    else{
        write-host -ForegroundColor Red "CredentialManager is not installed`n"
        write-host "Installing NuGet and CredentialManager"
        Install-PackageProvider -Name Nuget -MinimumVersion 2.8.5.201 -Force
        install-module -Name CredentialManager -Confirm:$false -force
    }
    $installdir = "$home\appdata\Local\supporttool"
    $desktopfile = "$home\Desktop\j-Drev.cmd"
    $fileprint = "$installdir\fileprint.ps1"
    $desktopfilescript = "powershell.exe . $fileprint"
    Out-File $desktopfile -InputObject $desktopfilescript -Encoding ascii

    # Local Intranet security settings

    $registryPath = "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Internet Settings\ZoneMap\Domains\jjk.local\server2"

    if(!(Test-Path $registryPath)){
        write-host "Add server2.jjk.local to reg"
        New-Item -Path $registryPath -Force | Out-Null
        New-ItemProperty -Path $registryPath -Name file -Value 1 -PropertyType DWORD -Force | Out-Null
    }
}

function ClearStoredCredential {
    if(get-command Get-StoredCredential -ErrorAction SilentlyContinue){
        write-host -ForegroundColor Green "CredentialManager is installed"
    }
    else{
        write-host -ForegroundColor Red "CredentialManager is not installed`n"
        write-host "Installing NuGet and CredentialManager"
        Install-PackageProvider -Name Nuget -MinimumVersion 2.8.5.201 -Force
        install-module -Name CredentialManager -Confirm:$false -force
    }

    Remove-StoredCredential -Target "server2"
    Remove-StoredCredential -Target "server2.jjk.local"
}

function ClearPrinters {
    Write-Host "Remove Printers"
    Get-Printer | Remove-Printer
}

function update {
    $updatefile = "$home\appdata\local\supporttool\update.ps1"
    Start-Process powershell -ArgumentList $updatefile
    # -Verb runAs
    exit 0
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
             InstallVideo
         } '5' {
             Clear-Host
             RunSupport
         } '6' {
                Clear-Host
                RunNetPrint
         } 'u' {
             Clear-Host
             update
         } '77' {
             Clear-Host
             ClearPrinters
         } '88' {
             Clear-Host
             ClearStoredCredential
         } '99' {
             Clear-Host
             drivertool
         }
     }
     pause
 }
 until ($selection -eq 'q')