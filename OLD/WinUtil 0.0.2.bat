@echo off
chcp 65001 >nul
title PATRYK SERVICE TOOLKIT v1.0

:: ==========================
:: AUTO ADMIN
:: ==========================

net session >nul 2>&1

if %errorlevel% neq 0 (
    echo Uruchamianie jako administrator...
    powershell -Command "Start-Process '%~f0' -Verb RunAs"
    exit
)

:: ==========================

set ROOT=%~dp0
set LOG=%ROOT%Serwis_Log.txt
set REPORT=%ROOT%REPORTS


if not exist "%REPORT%" mkdir "%REPORT%"


:MENU
cls
color 0A

echo.
echo ==================================================
echo          PATRYK SERVICE TOOLKIT v1.0
echo ==================================================
echo.
echo  SYSTEM
echo  [1] Chris Titus Tech WinUtil
echo  [2] PowerShell Administrator
echo  [3] CMD Administrator
echo  [4] Windows Update / Naprawa
echo.
echo  DIAGNOSTYKA
echo  [5] Raport komputera
echo  [6] Diagnostyka dyskow
echo  [7] Narzedzia hardware
echo  [8] Test pamieci RAM
echo.
echo  SERWIS
echo  [9] Optymalizacja uslug
echo [10] Narzedzia odzysku danych
echo [11] Otworz folder narzedzi
echo.
echo [0] Wyjscie
echo.

choice /c 1234567890 /n /m "Wybierz: "


if errorlevel 10 goto EXIT
if errorlevel 9 goto TOOLS
if errorlevel 8 goto RECOVERY
if errorlevel 7 goto SERVICES
if errorlevel 6 goto RAM
if errorlevel 5 goto HARDWARE
if errorlevel 4 goto DISK
if errorlevel 3 goto REPORT
if errorlevel 2 goto CMD
if errorlevel 1 goto WINUTIL



:WINUTIL

echo [%date% %time%] WinUtil >> "%LOG%"

powershell -ExecutionPolicy Bypass -Command "irm christitus.com/win | iex"

pause
goto MENU



:CMD

start cmd
goto MENU



:REPORT

cls
echo Tworzenie raportu...

set FILE=%REPORT%\Raport_%COMPUTERNAME%.txt


(
echo ===============================
echo PATRYK SERVICE REPORT
echo ===============================

echo.
echo DATA:
date /t
time /t

echo.
echo KOMPUTER:
wmic computersystem get manufacturer,model

echo.
echo CPU:
wmic cpu get name

echo.
echo RAM:
wmic memorychip get capacity,speed

echo.
echo GPU:
wmic path win32_VideoController get name

echo.
echo DYSKI:
wmic diskdrive get model,size,status

echo.
echo BIOS:
wmic bios get smbiosbiosversion

echo.
echo WINDOWS:
ver

)> "%FILE%"


echo Gotowe:
echo %FILE%

echo [%date% %time%] Raport >> "%LOG%"

pause
goto MENU




:DISK

cls

echo Diagnostyka dyskow

if exist "%ROOT%TOOLS\CrystalDiskInfo\DiskInfo64.exe" (
start "" "%ROOT%TOOLS\CrystalDiskInfo\DiskInfo64.exe"
) else (
echo Brak CrystalDiskInfo
)


if exist "%ROOT%TOOLS\CrystalDiskMark\DiskMark64.exe" (
start "" "%ROOT%TOOLS\CrystalDiskMark\DiskMark64.exe"
)

pause
goto MENU





:HARDWARE

cls

echo Narzedzia sprzetowe


if exist "%ROOT%TOOLS\HWiNFO\HWiNFO64.exe" (
start "" "%ROOT%TOOLS\HWiNFO\HWiNFO64.exe"
)


if exist "%ROOT%TOOLS\CPU-Z\cpuz_x64.exe" (
start "" "%ROOT%TOOLS\CPU-Z\cpuz_x64.exe"
)


if exist "%ROOT%TOOLS\GPU-Z\GPU-Z.exe" (
start "" "%ROOT%TOOLS\GPU-Z\GPU-Z.exe"
)


pause
goto MENU





:RAM

cls

echo TEST RAM

echo.
echo Dostepne opcje:
echo.
echo 1 - Windows Memory Diagnostic
echo 2 - Otworz ISO MemTest
echo.

choice /c 12


if errorlevel 2 (
explorer "%ROOT%ISO"
)

if errorlevel 1 (
mdsched.exe
)

goto MENU





:SERVICES

cls

echo Optymalizacja uslug Windows

echo.
echo Tu dodamy bezpieczne profile:
echo - gaming
echo - laptop
echo - serwis
echo.

pause
goto MENU





:RECOVERY

cls

echo Odzysk danych

explorer "%ROOT%TOOLS"

pause
goto MENU





:TOOLS

explorer "%ROOT%TOOLS"

goto MENU




:EXIT

echo [%date% %time%] Zamknieto launcher >> "%LOG%"

exit