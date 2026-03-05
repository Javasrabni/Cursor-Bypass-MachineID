#!/usr/bin/env pwsh
# Cursor Bypass for Windows - Auto Recovery Version

# Jalankan sebagai Administrator
if (-NOT ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Write-Host "⚠️  Run as Administrator!" -ForegroundColor Red
    Start-Sleep 3
    exit 1
}

$StateDir = "$env:TEMP\CursorBypass-$(Get-Date -Format 'yyyyMMdd-HHmmss')"
$BackupDir = "$StateDir\Backup"
New-Item -ItemType Directory -Path $StateDir, $BackupDir -Force | Out-Null

# Backup registry
Write-Host "`n[PHASE 1] Creating Backup..." -ForegroundColor Cyan
if (Test-Path "HKCU:\Software\Cursor") {
    reg export "HKCU\Software\Cursor" "$BackupDir\cursor-registry.reg" /y 2>$null
    Write-Host "✓ Registry backed up" -ForegroundColor Green
}

# Backup machine GUID
$MachineGuid = Get-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Cryptography" -Name "MachineGuid" -ErrorAction SilentlyContinue
if ($MachineGuid) {
    $MachineGuid.MachineGuid | Out-File "$BackupDir\machine-guid.txt"
    Write-Host "✓ Machine GUID backed up" -ForegroundColor Green
}

# Kill Cursor processes
Write-Host "`n[PHASE 2] Stopping Cursor..." -ForegroundColor Cyan
Get-Process | Where-Object {$_.ProcessName -like "*cursor*"} | Stop-Process -Force -ErrorAction SilentlyContinue
Start-Sleep 2

# Create fake registry
Write-Host "→ Creating fake configuration..." -ForegroundColor Yellow
Remove-Item -Path "HKCU:\Software\Cursor" -Recurse -Force -ErrorAction SilentlyContinue

$FakeMachineId = [Guid]::NewGuid().ToString("N")
$FakeMacId = [Guid]::NewGuid().ToString("N")

New-Item -Path "HKCU:\Software\Cursor\User\globalStorage" -Force | Out-Null
$FakeData = @{
    "telemetry.machineId" = $FakeMachineId
    "telemetry.macMachineId" = $FakeMacId
    "telemetry.enableTelemetry" = 0
}
foreach ($key in $FakeData.Keys) {
    New-ItemProperty -Path "HKCU:\Software\Cursor\User\globalStorage" -Name $key -Value $FakeData[$key] -PropertyType String -Force | Out-Null
}

Write-Host "✓ Fake IDs created: $($FakeMachineId.Substring(0, 16))..." -ForegroundColor Green

# Interactive menu
Write-Host "`n╔════════════════════════════════════════════════════════════╗" -ForegroundColor Magenta
Write-Host "║  CURSOR BYPASS ACTIVE (Windows)                             ║" -ForegroundColor Magenta
Write-Host "╚════════════════════════════════════════════════════════════╝" -ForegroundColor Magenta

while ($true) {
    Write-Host "`nCommands: [1] Start Cursor  [2] Status  [3] Restore & Exit" -ForegroundColor Cyan
    $choice = Read-Host "Select (1-3)"
    
    switch ($choice) {
        "1" {
            Start-Process "cursor.exe"
            Write-Host "Cursor launched" -ForegroundColor Green
        }
        "2" {
            Write-Host "`nStatus:" -ForegroundColor Yellow
            Write-Host "Backup: $BackupDir"
            Write-Host "Machine ID: $($FakeMachineId.Substring(0, 32))..."
        }
        "3" {
            Write-Host "`n[PHASE 3] Restoring system..." -ForegroundColor Cyan
            
            # Restore registry
            if (Test-Path "$BackupDir\cursor-registry.reg") {
                reg import "$BackupDir\cursor-registry.reg" 2>$null
                Write-Host "✓ Registry restored" -ForegroundColor Green
            }
            
            # Cleanup
            Remove-Item -Path $StateDir -Recurse -Force -ErrorAction SilentlyContinue
            Write-Host "✅ Restore complete!" -ForegroundColor Green
            exit 0
        }
    }
}
