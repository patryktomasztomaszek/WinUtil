@echo off
setlocal EnableDelayedExpansion

title SERWIS WINDOWS - Launcher
color 0A

set LOG=%~dp0Serwis_Log.txt

:: ==============================
:: ADMIN CHECK
:: ==============================

net session >nul 2>&1

if %errorlevel% neq 0 (
    powershell -Command "Start-Process '%~f0' -Verb RunAs"
    exit
)

:: ==============================
:: START LOG
:: ==============================

echo =============================== >> "%LOG%"
echo Start %date% %time% >> "%LOG%"
echo =============================== >> "%LOG%"


:MENU
cls

echo.
echo ========================================
echo          SERWIS WINDOWS TOOL
echo       Made by P       ver. 0.0.1
echo ========================================
echo.
echo 1. Chris Titus Tech WinUtil
echo 2. Massgrave Activation
echo 3. PowerShell Administrator
echo 4. CMD Administrator
echo.
echo 5. Diagnostyka Windows
echo 6. Narzedzia dyskowe
echo 7. Siec
echo 8. Optymalizacja uslug
echo.
echo 9. Wyjscie
echo.

choice /c 123456789 /n /m "Wybor: "


if errorlevel 9 goto EXIT
if errorlevel 8 goto SERVICES
if errorlevel 7 goto NETWORK
if errorlevel 6 goto DISKS
if errorlevel 5 goto DIAG
if errorlevel 4 goto CMD
if errorlevel 3 goto PS
if errorlevel 2 goto MASS
if errorlevel 1 goto WINUTIL



:: ==============================
:: WINUTIL
:: ==============================

:WINUTIL

echo [%date% %time%] WinUtil >> "%LOG%"

cls
echo Uruchamiam Chris Titus WinUtil...

powershell.exe -NoProfile -ExecutionPolicy Bypass -Command "irm https://christitus.com/win | iex"

pause
goto MENU



:: ==============================
:: MASSGRAVE
:: ==============================

:MASS

echo [%date% %time%] Massgrave >> "%LOG%"

cls
echo Uruchamiam Massgrave...

powershell.exe -NoProfile -ExecutionPolicy Bypass -Command "irm https://get.activated.win | iex"

pause
goto MENU



:: ==============================
:: POWERSHELL
:: ==============================

:PS

echo [%date% %time%] PowerShell >> "%LOG%"

start "" powershell.exe

goto MENU



:: ==============================
:: CMD
:: ==============================

:CMD

echo [%date% %time%] CMD >> "%LOG%"

start "" cmd.exe

goto MENU



:: ==============================
:: DIAGNOSTYKA
:: ==============================

:DIAG

cls

echo ========================================
echo          DIAGNOSTYKA WINDOWS
echo ========================================
echo.
echo 1. SFC Scan
echo 2. DISM RestoreHealth
echo 3. CHKDSK
echo 4. Informacje systemowe
echo 5. Historia niezawodnosci
echo 6. Test RAM
echo 7. Powrot
echo.

choice /c 1234567 /n /m "Wybor: "


if errorlevel 7 goto MENU


if errorlevel 6 (
echo [%date% %time%] Test RAM >> "%LOG%"
mdsched.exe
goto DIAG
)


if errorlevel 5 (
perfmon /rel
goto DIAG
)


if errorlevel 4 (
msinfo32
goto DIAG
)


if errorlevel 3 (
echo [%date% %time%] CHKDSK >> "%LOG%"
chkdsk C:
pause
goto DIAG
)


if errorlevel 2 (
echo [%date% %time%] DISM >> "%LOG%"
DISM /Online /Cleanup-Image /RestoreHealth
pause
goto DIAG
)


if errorlevel 1 (
echo [%date% %time%] SFC >> "%LOG%"
sfc /scannow
pause
goto DIAG
)



:: ==============================
:: DYSKI
:: ==============================

:DISKS

cls

echo ========================================
echo          NARZEDZIA DYSKOWE
echo ========================================
echo.
echo 1. Zarzadzanie dyskami
echo 2. DiskPart
echo 3. Defragmentacja / TRIM
echo 4. SMART
echo 5. Powrot
echo.


choice /c 12345 /n /m "Wybor: "


if errorlevel 5 goto MENU


if errorlevel 4 (
wmic diskdrive get model,status
pause
goto DISKS
)


if errorlevel 3 (
defrag C: /L
pause
goto DISKS
)


if errorlevel 2 (
diskpart
goto DISKS
)


if errorlevel 1 (
start diskmgmt.msc
goto DISKS
)



:: ==============================
:: SIEC
:: ==============================

:NETWORK

cls

echo ========================================
echo              SIEC
echo ========================================
echo.
echo 1. IP Config
echo 2. Flush DNS
echo 3. Reset Winsock
echo 4. Reset TCP/IP
echo 5. Karty sieciowe
echo 6. Powrot
echo.


choice /c 123456 /n /m "Wybor: "


if errorlevel 6 goto MENU


if errorlevel 5 (
ncpa.cpl
goto NETWORK
)


if errorlevel 4 (
netsh int ip reset
pause
goto NETWORK
)


if errorlevel 3 (
netsh winsock reset
pause
goto NETWORK
)


if errorlevel 2 (
ipconfig /flushdns
pause
goto NETWORK
)


if errorlevel 1 (
ipconfig /all
pause
goto NETWORK
)



:: ==============================
:: USLUGI
:: ==============================

:SERVICES

cls

echo ========================================
echo        OPTYMALIZACJA USLUG
echo ========================================
echo.
echo Sekcja przygotowana.
echo.
echo Tutaj dodamy:
echo - backup uslug
echo - profile gaming
echo - laptop HDD
echo - biuro
echo - przywracanie ustawien
echo.

pause
goto MENU



:: ==============================
:: EXIT
:: ==============================

:EXIT

echo [%date% %time%] Koniec >> "%LOG%"

exit