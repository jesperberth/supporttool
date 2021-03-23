$testsc = Get-StoredCredential -Target "server2.jjk.local" -Type DomainVisiblePassword

if($testsc){
    write-host "Credentials for server2.jjk.local"
}
else{
    write-host "No Credentials"
    write-host -ForegroundColor Green "Please enter credentials for Server2.jjk.local`n"
    write-host -ForegroundColor Yellow "Format: <username>"
    $creds = Get-Credential
    New-StoredCredential -Credentials $creds -Persist Enterprise -Type DomainVisiblePassword -Target "server2.jjk.local"
    }
$creds2 = Get-StoredCredential -Target "server2.jjk.local" -Type DomainVisiblePassword

if(Get-PSDrive -name "J" -ErrorAction SilentlyContinue){
Write-Host "Drives Exist"
}
else{
write-host "setup drives"
net use J: /delete /y
New-PSDrive -Name "J" -Root "\\server2.jjk.local\JJK" -Persist -PSProvider "FileSystem" -Credential $creds2
}

if(Get-Printer -name "\\server2.jjk.local\Canon C3730i PCL6 SH"-ErrorAction SilentlyContinue){
Write-Host "Printer Canon C3730i PCL6 SH exist"
}
else{
write-host "setup printer - Canon C3730i PCL6 SH"
add-printer -ConnectionName "\\server2.jjk.local\Canon C3730i PCL6 SH"

Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Windows" -Name "LegacyDefaultPrinterMode" -Value ”1”

(Get-WMIObject -ClassName win32_printer |Where-Object -Property Name -eq "\\server2.jjk.local\Canon C3730i PCL6 SH").SetDefaultPrinter()

}

if(Get-Printer -name "\\server2.jjk.local\Canon C3730i PCL6 Color"-ErrorAction SilentlyContinue){
    Write-Host "Printer Canon C3730i PCL6 Color exist"
    }
    else{
    write-host "setup printer - Canon C3730i PCL6 Color"
    add-printer -ConnectionName "\\server2.jjk.local\Canon C3730i PCL6 Color"
    }