# =====================================
# PATRYK SERVICE TOOLKIT
# PowerShell Edition
# =====================================

$Root = Split-Path $MyInvocation.MyCommand.Path

$Log = "$Root\LOG\Serwis_Log.txt"

if (!(Test-Path "$Root\LOG")) {
    New-Item "$Root\LOG" -ItemType Directory | Out-Null
}


function Write-Log {

    param(
        [string]$Text
    )

    "$(Get-Date) - $Text" | Out-File $Log -Append

}


# ADMIN CHECK

$currentUser = [Security.Principal.WindowsIdentity]::GetCurrent()

$principal = New-Object Security.Principal.WindowsPrincipal($currentUser)

if (!$principal.IsInRole(
    [Security.Principal.WindowsBuiltInRole]::Administrator
)) {

    Start-Process powershell `
    "-ExecutionPolicy Bypass -File `"$PSCommandPath`"" `
    -Verb RunAs

    exit
}


Write-Log "START TOOLKIT"