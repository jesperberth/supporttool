# Menu driven Support Tool
#
# Author: Jesper Berth, Arrow ECS, jesper.berth@arrow.com - 13. November 2018
# Version 0.0.1
function Show-Menu
{
    param (
        [string]$Title = "Support Tool - 150319-2"
    )
    Clear-Host
    Write-Host "========= $Title ==========`n"
    Write-Host "1: Install Standard Software"
    Write-Host "2: Install Adobe Creative Suite"
    Write-Host "3: Install Programming Suite"
    Write-Host "4: Install Video Suite"
    Write-Host "5: Run Support Tool"
    Write-Host "6: Setup Netshare and Print"
    Write-Host "==============================="
    Write-Host "99: Run Driver Tool"
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
    "vlc",
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
    "vscode",
    "sublimetext3",
    "cyberduck",
    "brackets"
    )

    foreach ($item in $programlist){
        ChocoInstall $item
    }
}

function InstallVideo {
    write-host -ForegroundColor Green "Install Video Suite`n"
    $programlist = @(
    "handbrake.install",
    ""
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
    # Ask for local credentials
    write-host -ForegroundColor Green "Please enter credentials for Server2.jjk.local`n"
    write-host -ForegroundColor Yellow "Format: jjk\<username>"
    $creds = Get-Credential
    New-StoredCredential -Credentials $creds -Persist LocalMachine -Type DomainPassword -Target Server2.jjk.local
 
    $creds2 = Get-StoredCredential -Target Server2
 
    New-PSDrive -Name "J" -Root "\\server2.jjk.local\JJK" -Persist -PSProvider "FileSystem" -Credential $creds2
    add-printer -ConnectionName "\\server2.jjk.local\OKI ES8473 MFP COLOR"
    add-printer -ConnectionName "\\server2.jjk.local\OKI ES8473 MFP SH"
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
         } '99' {
                 Clear-Host
                 drivertool
                }
     }
     pause
 }
 until ($selection -eq 'q')