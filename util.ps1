# ==========================================
#           WinUtil Service Toolkit
#          PowerShell Edition v0.0.5
#                 Made by P.
# ==========================================



# ==========================================
# Ustawienia kolorów konsoli
# ==========================================

[console]::BackgroundColor = "Black"
[console]::ForegroundColor = "Gray"


$ROOT = Split-Path $MyInvocation.MyCommand.Path

$LOGDIR = "$ROOT\LOG"
$REPORTDIR = "$ROOT\REPORTS"
$TOOLS = "$ROOT\TOOLS"

$LOG = "$LOGDIR\Serwis_Log.txt"



foreach($folder in @($LOGDIR,$REPORTDIR)){

    if(!(Test-Path $folder)){
        New-Item $folder -ItemType Directory | Out-Null
    }

}



# ==========================================
# ADMIN CHECK
# ==========================================

$currentUser = [Security.Principal.WindowsIdentity]::GetCurrent()

$principal = New-Object Security.Principal.WindowsPrincipal($currentUser)

$admin = $principal.IsInRole(
    [Security.Principal.WindowsBuiltInRole]::Administrator
)


if(!$admin){

    Start-Process powershell.exe `
    "-ExecutionPolicy Bypass -File `"$PSCommandPath`"" `
    -Verb RunAs

    exit

}



# ==========================================
# FUNKCJE PODSTAWOWE
# ==========================================


function Test-Internet {

    try {

        $null = Invoke-WebRequest `
            -Uri "1.1.1.1" `
            -Method Head `
            -TimeoutSec 5 `
            -UseBasicParsing `
            -ErrorAction Stop

        return $true

    }
    catch {

        return $false

    }

}

function LOG($text){

"[$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')] $text" |
Out-File $LOG -Append -Encoding UTF8

}



function PAUSE{

Read-Host "ENTER aby kontynuowac"

}



LOG "START TOOLKIT"



# ==========================================
# SYSTEM TOOLS
# ==========================================


function WINUTIL {

    #Clear-Host

    LOG "Chris Titus WinUtil"

    $WinUtil = Join-Path $TOOLS ".\winutil.ps1"

    if (Test-Internet) {

        Write-Host ""
        Write-Host "Internet wykryty." -ForegroundColor Green
        Write-Host "Uruchamiam najnowsza wersje WinUtil..." -ForegroundColor Blue
        Write-Host ""

        powershell.exe `
            -NoProfile `
            -ExecutionPolicy Bypass `
            -Command "irm https://christitus.com/win | iex"

    }
    elseif (Test-Path $WinUtil) {

        Write-Host ""
        Write-Host "Brak Internetu." -ForegroundColor Red
        Write-Host "Uruchamiam lokalna kopie WinUtil..." -ForegroundColor Blue
        Write-Host ""

        powershell.exe `
            -NoProfile `
            -ExecutionPolicy Bypass `
            -File $WinUtil

    }
    else {

        Write-Host ""
        Write-Host "Brak polaczenia z Internetem." -ForegroundColor Red
        Write-Host "Nie znaleziono lokalnej kopii WinUtil:" -ForegroundColor Red
        Write-Host $WinUtil
        Write-Host ""

    }

    PAUSE

}



function MASSGRAVE {

    #Clear-Host

    LOG "Massgrave"


    $Massgrave = Join-Path $TOOLS ".\mas_AIO.cmd"

    if (Test-Internet) {

        Write-Host ""
        Write-Host "Internet wykryty."
        Write-Host "Uruchamiam najnowsza wersje Massgrave..."
        Write-Host ""

        powershell.exe `
            -NoProfile `
            -ExecutionPolicy Bypass `
            -Command "irm https://get.activated.win | iex"

    }
    elseif (Test-Path $Massgrave) {

        Write-Host ""
        Write-Host "Brak Internetu." -ForegroundColor Red
        Write-Host "Uruchamiam lokalna kopie Massgrave..."
        Write-Host ""

        Start-Process `
            -FilePath $Massgrave `
            -Verb RunAs `
            -Wait

    }
    else {

        Write-Host ""
        Write-Host "Brak polaczenia z Internetem."
        Write-Host "Nie znaleziono lokalnej kopii Massgrave:"
        Write-Host $Massgrave
        Write-Host ""

    }

    PAUSE

}



# ==========================================
# RAPORT
# ==========================================


function RAPORT{


$file="$REPORTDIR\Raport_$env:COMPUTERNAME.html"


LOG "Raport systemu"


$os=Get-CimInstance Win32_OperatingSystem
$cpu=Get-CimInstance Win32_Processor
$gpu=Get-CimInstance Win32_VideoController
$bios=Get-CimInstance Win32_BIOS
$board=Get-CimInstance Win32_BaseBoard


$ram=Get-CimInstance Win32_PhysicalMemory |
Measure-Object Capacity -Sum


$disk=Get-CimInstance Win32_DiskDrive



$html=@"

<html>

<head>

<title>Raport serwisowy</title>

<style>

body{
font-family:Arial;
}

table{
border-collapse:collapse;
}

td{
border:1px solid black;
padding:5px;
}

</style>

</head>


<body>


<h1>PATRYK SERVICE TOOLKIT</h1>


<table>


<tr><td>PC</td><td>$env:COMPUTERNAME</td></tr>

<tr><td>Windows</td><td>$($os.Caption)</td></tr>

<tr><td>Build</td><td>$($os.BuildNumber)</td></tr>

<tr><td>CPU</td><td>$($cpu.Name)</td></tr>

<tr><td>RAM</td><td>$([math]::Round($ram.Sum/1GB,2)) GB</td></tr>

<tr><td>GPU</td><td>$($gpu.Name)</td></tr>

<tr><td>BIOS</td><td>$($bios.SMBIOSBIOSVersion)</td></tr>

<tr><td>Board</td><td>$($board.Product)</td></tr>


</table>


<h2>Dyski</h2>


<table>

$(foreach($d in $disk){

"<tr><td>$($d.Model)</td><td>$($d.Status)</td></tr>"

})


</table>


</body>

</html>

"@



$html | Out-File $file -Encoding UTF8


Start-Process $file


PAUSE

}



# ==========================================
# MENU DIAGNOSTYKA
# ==========================================


function MENU-DIAGNOSTYKA{


while($true){


Clear-Host


Write-Host "

==============================
      DIAGNOSTYKA WINDOWS
==============================

1. SFC Scan

2. DISM RestoreHealth

3. CHKDSK

4. Historia niezawodnosci

5. Informacje systemowe

6. Test RAM


0. Powrot


"


$x=Read-Host "Wybor"



switch($x){


1{

LOG "SFC"

sfc /scannow

PAUSE

}


2{

LOG "DISM"

DISM /Online /Cleanup-Image /RestoreHealth

PAUSE

}


3{

LOG "CHKDSK"

chkdsk C:

PAUSE

}


4{

perfmon /rel

}


5{

msinfo32

}


6{

mdsched.exe

}


0{

return

}


}



}



}



# ==========================================
# MENU DYSKI
# ==========================================


function MENU-DYSKI{


while($true){


Clear-Host


Write-Host "

==============================
        NARZEDZIA DYSKOWE
==============================

1. Zarzadzanie dyskami

2. DiskPart

3. TRIM SSD

4. SMART


0. Powrot


"



$x=Read-Host "Wybor"



switch($x){


1{

diskmgmt.msc

}


2{

diskpart

}


3{

defrag C: /L

PAUSE

}


4{

Get-CimInstance Win32_DiskDrive |
Select Model,Status |
Format-Table

PAUSE

}


0{

return

}


}



}



}



# ==========================================
# MENU SIEC
# ==========================================


function MENU-SIEC{


while($true){


Clear-Host


Write-Host "

==============================
              SIEC
==============================

1. IP Config

2. Flush DNS

3. Reset Winsock

4. Reset TCP/IP

5. Karty sieciowe


0. Powrot


"



$x=Read-Host "Wybor"



switch($x){


1{

ipconfig /all

PAUSE

}


2{

ipconfig /flushdns

PAUSE

}


3{

netsh winsock reset

PAUSE

}


4{

netsh int ip reset

PAUSE

}


5{

ncpa.cpl

}


0{

return

}


}



}



}



# ==========================================
# HARDWARE
# ==========================================


function HARDWARE{


if(Test-Path "$TOOLS\HWiNFO\HWiNFO64.exe"){
Start-Process "$TOOLS\HWiNFO\HWiNFO64.exe"
}


if(Test-Path "$TOOLS\CPU-Z\cpuz_x64.exe"){
Start-Process "$TOOLS\CPU-Z\cpuz_x64.exe"
}


if(Test-Path "$TOOLS\GPU-Z\GPU-Z.exe"){
Start-Process "$TOOLS\GPU-Z\GPU-Z.exe"
}


}



# ==========================================
# MENU GLOWNE
# ==========================================


function MENU-GLOWNE{


while($true){


Clear-Host


Write-Host "

    ==========================================
             WinUtil Service Toolkit
            PowerShell Edition v0.0.5
                   Made by P.0
    ==========================================

    1. Chris Titus WinUtil
    2. Massgrave
    3. PowerShell Administrator
    4. CMD Administrator

    5. Raport komputera
    6. Diagnostyka Windows
    7. Narzedzia dyskowe
    8. Siec
    9. Narzedzia Hardware

    0. Wyjscie
    "



$x=Read-Host "Wybor"



switch($x){


1{
WINUTIL
}


2{
MASSGRAVE
}


3{
Start-Process powershell
}


4{
Start-Process cmd
}


5{
RAPORT
}


6{
MENU-DIAGNOSTYKA
}


7{
MENU-DYSKI
}


8{
MENU-SIEC
}


9{
HARDWARE
}


0{

LOG "STOP TOOLKIT"

exit

}


}



}



}



# START

MENU-GLOWNE