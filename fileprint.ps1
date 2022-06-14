$testsc = Get-StoredCredential -Target "server2" -Type DomainVisiblePassword

if($testsc){
    write-host "Credentials for server2"
}
else{
    write-host "No Credentials"
    write-host -ForegroundColor Green "Please enter credentials for Server2`n"
    write-host -ForegroundColor Yellow "Format: <username>"
    $creds = Get-Credential
    New-StoredCredential -Credentials $creds -Persist Enterprise -Type DomainVisiblePassword -Target "server2"
    }

$creds2 = Get-StoredCredential -Target "server2" -Type DomainVisiblePassword

if(Get-PSDrive -name "J" -ErrorAction SilentlyContinue){
    Write-Host "Drives Exist"
}
else{
    write-host "setup drives"
    net use J: /delete /y
    New-PSDrive -Name "J" -Root "\\server2\JJK" -Persist -PSProvider "FileSystem" -Credential $creds2
}