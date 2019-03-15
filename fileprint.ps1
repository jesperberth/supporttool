$testsc = Get-StoredCredential -AsCredentialObject -Target "server2.jjk.local"

if($testsc -ne $null){
    write-host "Exist"
}
else{
    write-host "Dosnt exist"
    write-host -ForegroundColor Green "Please enter credentials for Server2.jjk.local`n"
    write-host -ForegroundColor Yellow "Format: jjk\<username>"
    $creds = Get-Credential
    New-StoredCredential -Credentials $creds -Persist Enterprise -Type Generic -Target "server2.jjk.local"
}
$creds2 = Get-StoredCredential -Target "server2.jjk.local"

if(Get-PSDrive -name "J" -ErrorAction SilentlyContinue){
Write-Host "Drives Exist"
}
else{
write-host "setup drives"
New-PSDrive -Name "J" -Root "\\server2.jjk.local\JJK" -Persist -PSProvider "FileSystem" -Credential $creds2
}

if(Get-Printer -name "\\server2.jjk.local\OKI ES8473 MFP SH" Get-PSDrive -name "J" -ErrorAction SilentlyContinue){
Write-Host "Printer Exist"
}
else{
write-host "setup printers"
#add-printer -ConnectionName "\\server2.jjk.local\OKI ES8473 MFP COLOR"
#add-printer -ConnectionName "\\server2.jjk.local\OKI ES8473 MFP SH"
}