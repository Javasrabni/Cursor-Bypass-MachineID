##  **Main Function**
This script is a **sandbox bypass for Cursor Editor** that enables usage without license restrictions with:
- ✅ **Auto-recovery** - Automatically restores system to original state
- ✅ **Non-destructive** - Doesn't damage original configuration
- ✅ **Deep bypass** - Multi-layer modifications (machine-id, MAC, config)
- ✅ **Interactive mode** - Real-time control with command prompt

## 📁 **Repository Structure**
```
Bypass-Crsr/
├── cursor-safe-sandbox.sh      # Main Linux/macOS script
├── cursor-windows-bypass.ps1   # Windows PowerShell script
├── README.md                   # This documentation
└── .cursor-sandbox-state-*/    # Automatic backup folder
```

## ⚙️ **Usage Guide (Linux/macOS)**

### **1. Preparation**
```bash
# Give execution permission
chmod +x cursor-safe-sandbox.sh

# Ensure Cursor is installed
# Download from: https://cursor.sh
```

### **2. Running the Script**
```bash
# Run as regular user (not root)
./cursor-safe-sandbox.sh
```

### **3. Workflow**
```
[PHASE 1] Backup
    ↓
[PHASE 2] Apply Bypass
    ↓
[PHASE 3] Optional Mods
    ↓
[PHASE 4] Interactive Mode
    ↓
[EXIT] Auto-Restore
```

### **4. Interactive Mode Commands**
```
cursor    : Launch Cursor Editor
status    : Check bypass status
restore   : Restore system & exit
exit      : Same as restore
help      : Show commands
```

## 🪟 **Windows Version (PowerShell)**

### **File: `cursor-windows-bypass.ps1`**
```powershell
#!/usr/bin/env pwsh
# Cursor Bypass for Windows - Auto Recovery Version

# Run as Administrator
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
```

### **Windows Usage:**
1. **Save as `cursor-windows-bypass.ps1`**
2. **Run PowerShell as Administrator**
3. **Enable execution policy if needed:**
   ```powershell
   Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
   ```
4. **Run script:**
   ```powershell
   .\cursor-windows-bypass.ps1
   ```

## ⚠️ **Warnings & Disclaimer**

### **Legal Considerations:**
- ❌ **For educational and testing purposes only**
- ❌ **Do not use for illegal activities**
- ❌ **Violates Cursor's Terms of Service**
- ✅ **Use in sandbox/VM environments**
- ✅ **Backup important data before use**

### **Security Recommendations:**
1. **Use VPN** for anonymity
2. **New email** for registration
3. **Virtual Machine** for isolation
4. **Regular restore** to original state

## 🔧 **Troubleshooting**

### **Linux/macOS Issues:**
```bash
# Permission denied
chmod +x cursor-safe-sandbox.sh

# Cursor still detected
rm -rf ~/.config/Cursor ~/.cache/Cursor
./cursor-safe-sandbox.sh

# Backup not restoring
rm -rf .cursor-sandbox-state-*
```

### **Windows Issues:**
```powershell
# Execution policy error
Set-ExecutionPolicy Bypass -Scope Process

# Registry permission error
# Run PowerShell as Administrator

# Cursor processes not closing
taskkill /F /IM cursor.exe /T
```

## 📊 **Performance & Compatibility**

| OS | Version | Status | Notes |
|----|---------|--------|-------|
| Linux | Ubuntu 20.04+ | ✅ | Best performance |
| macOS | 11.0+ | ✅ | Requires SIP consideration |
| Windows | 10/11 | ✅ | Run as Admin required |
| WSL | 2 | ⚠️ | Limited hardware spoofing |

## 🤝 **Contribution**

### **How to Contribute:**
1. Fork repository: https://github.com/Javasrabni/Bypass-Crsr
2. Create feature branch: `git checkout -b feature/new-bypass`
3. Commit changes: `git commit -m 'Add new feature'`
4. Push to branch: `git push origin feature/new-bypass`
5. Create Pull Request

### **Reporting Issues:**
- Use GitHub Issues
- Include OS version and error log
- Describe steps to reproduce

## 📜 **License & Ethics**

**⚠️ STRONG WARNING:** This script is provided **for educational and security research purposes only**. The author is not responsible for misuse. Using paid software without a license is **illegal** and violates copyright.

**Use wisely and responsibly.**

---

## 🔗 **GitHub Repository Information**

**Repository:** https://github.com/Javasrabni/Bypass-Crsr

**Quick Setup:**
```bash
# Clone repository
git clone https://github.com/Javasrabni/Bypass-Crsr.git

# Navigate to directory
cd Bypass-Crsr

# Make executable (Linux/macOS)
chmod +x cursor-safe-sandbox.sh

# Run bypass
./cursor-safe-sandbox.sh
```

**Star the repo if you find it useful! ⭐**

---
*Last Updated: $(date)*  
*Maintainer: Javasrabni*  
*For educational purposes only*
