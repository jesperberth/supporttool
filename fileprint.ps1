﻿$testsc = Get-StoredCredential -AsCredentialObject -Target "server2"

if($testsc){
    write-host "Credentials Exist"
}
else{
    write-host "No Credentials"
    write-host -ForegroundColor Green "Please enter credentials for Server2`n"
    write-host -ForegroundColor Yellow "Format: <username>"
    $creds = Get-Credential
    New-StoredCredential -Credentials $creds -Persist Enterprise -Type Generic -Target "server2"
}
$creds2 = Get-StoredCredential -Target "server2"

if(Get-PSDrive -name "J" -ErrorAction SilentlyContinue){
Write-Host "Drives Exist"
}
else{
write-host "setup drives"
net use J: /delete /y
New-PSDrive -Name "J" -Root "\\server2\JJK" -Persist -PSProvider "FileSystem" -Credential $creds2
}

if(Get-Printer -name "\\server2\Canon C3730i PCL6 SH"-ErrorAction SilentlyContinue){
Write-Host "Printer Exist"
}
else{
write-host "setup printers"
add-printer -ConnectionName "\\server2\Canon C3730i PCL6 Color"
add-printer -ConnectionName "\\server2\Canon C3730i PCL6 SH"

Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Windows" -Name "LegacyDefaultPrinterMode" -Value ”1”

(Get-WMIObject -ClassName win32_printer |Where-Object -Property Name -eq "\\server2\Canon C3730i PCL6 SH").SetDefaultPrinter()

}