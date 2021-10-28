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

if(Get-Printer -name "Canon C3730i PCL6 SH"-ErrorAction SilentlyContinue){
Write-Host "Printer Canon C3730i PCL6 SH exist"
}
else{
    write-host "setup printer - Canon C3730i PCL6 SH"
    Add-PrinterPort -Name "CanonIP-SH" -PrinterHostAddress "192.168.1.12"
    pnputil.exe -a "C:\Temp\Driver\CNP60MA64.INF"
    Add-PrinterDriver -Name "Canon Generic Plus PCL6"
    Add-Printer -Name "Canon C3730i PCL6 SH"  -PortName "CanonIP-SH" -DriverName "Canon Generic Plus PCL6"
    printui.exe /Sr /n "Canon C3730i PCL6 SH" /a "C:\Temp\Canon_C3730i_PCL6_SH.dat" c d g r p
    (Get-WMIObject -ClassName win32_printer |Where-Object -Property Name -eq "Canon C3730i PCL6 SH").SetDefaultPrinter()
}

if(Get-Printer -name "Canon C3730i PCL6 Color"-ErrorAction SilentlyContinue){
    Write-Host "Printer Canon C3730i PCL6 Color exist"
    }
    else{
        write-host "setup printer - Canon C3730i PCL6 Color"
        Add-PrinterPort -Name "CanonIP-Color" -PrinterHostAddress "192.168.1.12"
        pnputil.exe -a "C:\Temp\Driver\CNP60MA64.INF"
        Add-PrinterDriver -Name "Canon Generic Plus PCL6"
        Add-Printer -Name "Canon C3730i PCL6 Color"  -PortName "CanonIP-Color" -DriverName "Canon Generic Plus PCL6"
        printui.exe /Sr /n "Canon C3730i PCL6 Color" /a "C:\Temp\Canon_C3730i_PCL6_Color.dat" c d g r p
    }