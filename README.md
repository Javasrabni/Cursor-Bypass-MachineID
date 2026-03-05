# Cursor Safe Sandbox Bypass

A Bash script that creates a safe sandboxed environment for Cursor IDE with automatic backup and recovery functionality. This script allows you to bypass Cursor's telemetry and tracking mechanisms while maintaining the ability to restore your original configuration.

## 🚨 Disclaimer

**This script is for educational purposes only.** Use at your own risk. The authors are not responsible for any misuse or damage that may occur. Always ensure you have proper backups before running system modification scripts.

## 📋 Features

- **Safe Backup & Recovery**: Automatically backs up and restores Cursor configurations
- **Telemetry Bypass**: Creates fake machine IDs and disables telemetry
- **System Isolation**: Optional system-level modifications (machine-id, MAC address)
- **Interactive Mode**: User-friendly command interface for managing the sandbox
- **Auto-Cleanup**: Automatic restoration on script exit or interruption

## 🔧 Requirements

- Linux-based operating system
- Bash shell
- Cursor IDE installed
- `sudo` access (for system modifications)
- Basic command-line tools: `ip`, `uuidgen`, `pkill`

## 📦 Installation

1. Clone or download the script:
```bash
curl -O https://raw.githubusercontent.com/your-repo/cursor-safe-sandbox.sh
chmod +x cursor-safe-sandbox.sh
```

2. Make the script executable:
```bash
chmod +x cursor-safe-sandbox.sh
```

## 🚀 Usage

### Basic Usage

Run the script to start the sandbox environment:

```bash
./cursor-safe-sandbox.sh
```

### Script Phases

The script operates in four main phases:

#### Phase 1: Backup Creation
- Backs up existing Cursor configuration
- Saves system machine-id and MAC address
- Creates a recovery state directory

#### Phase 2: Bypass Application
- Removes old Cursor data
- Creates fake telemetry IDs
- Disables telemetry and crash reporting
- Sets up anti-tracking configuration

#### Phase 3: Optional System Modifications
- Prompts for system machine-id change
- Offers MAC address spoofing
- Requires sudo privileges for these operations

#### Phase 4: Interactive Monitoring Mode
Enter interactive mode with the following commands:

| Command | Description |
|---------|-------------|
| `cursor` | Launch Cursor in sandbox mode |
| `start` | Alias for cursor command |
| `open` | Alias for cursor command |
| `status` | Display current sandbox status |
| `restore` | Restore original configuration and exit |
| `exit` | Restore and exit (same as restore) |
| `quit` | Restore and exit (same as restore) |
| `stop` | Restore and exit (same as restore) |
| `help` | Show available commands |
| `h` | Show available commands |
| `?` | Show available commands |

### Example Session

```bash
$ ./cursor-safe-sandbox.sh

╔════════════════════════════════════════════════════════════╗
║  CURSOR SAFE SANDBOX BYPASS                                ║
║  Auto-Recovery | Non-Destructive                           ║
╚════════════════════════════════════════════════════════════╝

[PHASE 1] Creating Backup...
-----------------------------
✓ Cursor config backed up
✓ machine-id backed up: a1b2c3d4e5f6...
✓ MAC backed up: 00:11:22:33:44:55 (eth0)
✅ Backup created in: /path/to/.cursor-sandbox-state-1234567890

[PHASE 2] Applying Bypass...
-----------------------------
⚠️  Please CLOSE Cursor manually if it's running!
    (Waiting 5 seconds...)
→ Removing old Cursor data...
→ Creating fake configuration...
✓ Fake IDs created:
  machineId: f6e5d4c3b2a1...
✓ Telemetry disabled

[PHASE 3] Optional System Modifications
----------------------------------------
Change system machine-id? [y/N]: y
✓ machine-id changed to: 1234567890abcdef1234567890abcdef

Spoof MAC address? [y/N]: n

╔════════════════════════════════════════════════════════════╗
║  SANDBOX ACTIVE                                            ║
║                                                            ║
║  ✅ Cursor config: FAKE                                    ║
║  ✅ Backup: /path/to/.cursor-sandbox-state-1234567890     ║
║                                                            ║
║  Commands:                                                 ║
║   - cursor  : Launch Cursor                                ║
║   - status  : Check status                                 ║
║   - restore : Restore now & exit                           ║
║   - exit    : Restore & exit                               ║
║                                                            ║
║  ⚠️  IMPORTANT:                                            ║
║   Use VPN + NEW email for signup!                          ║
╚════════════════════════════════════════════════════════════╝

[14:30:15] bypass-ready> cursor
→ Launching Cursor...
  Cursor launched (PID: 12345)

[14:30:20] bypass-ready> status
→ Status:
  Backup: /path/to/.cursor-sandbox-state-1234567890
  Config: MODIFIED
  "telemetry.machineId": "f6e5d4c3b2a1..."

[14:30:25] bypass-ready> exit
→ Restoring...
==========================================
  CLEANUP TRIGGERED (Exit code: 0)
==========================================
→ Restoring original state...
  Restoring Cursor config...
  Restoring machine-id...
  Restoring MAC address...
✅ RESTORE COMPLETE
==========================================
```

## 🔒 Security Considerations

### What the Script Does
- **Safe Backup**: Creates timestamped backups before any modifications
- **Non-Destructive**: All changes are reversible
- **User Control**: Interactive prompts for system-level changes
- **Auto-Recovery**: Automatic cleanup on script termination

### What the Script Modifies
1. **Cursor Configuration** (`~/.config/Cursor/`)
   - Creates fake telemetry IDs
   - Disables telemetry and crash reporting

2. **Optional System Changes** (with user consent)
   - `/etc/machine-id` (requires sudo)
   - Network interface MAC address (requires sudo)

### Safety Features
- **Trap Handlers**: Catches interrupts and ensures cleanup
- **Error Handling**: Continues execution even if individual commands fail
- **Backup Validation**: Only restores if valid backup exists
- **Permission Checks**: Verifies sudo access before attempting system changes

## 🐛 Troubleshooting

### Common Issues

#### Permission Denied
```bash
❌ Failed to change machine-id (permission denied)
```
**Solution**: Ensure you have sudo privileges and run with appropriate permissions.

#### Cursor Still Running
```bash
⚠️  Please CLOSE Cursor manually if it's running!
```
**Solution**: Close all Cursor instances manually before proceeding.

#### Backup Failed
```bash
⚠ Could not backup Cursor config
```
**Solution**: Check if Cursor is installed and accessible in standard locations.

### Recovery Commands

If the script exits unexpectedly, you can manually restore:

1. Find your backup directory:
```bash
ls -la ~/.cursor-sandbox-state-*
```

2. Restore manually if needed:
```bash
# Restore Cursor config
cp -r ~/.cursor-sandbox-state-*/cursor-backup/Cursor ~/.config/

# Restore machine-id (requires sudo)
sudo cp ~/.cursor-sandbox-state-*/machine-id-backup /etc/machine-id
```

## 📁 File Structure

```
cursor-safe-sandbox.sh
├── .cursor-sandbox-state-TIMESTAMP/    # Temporary backup directory
│   ├── backup-valid                   # Backup validation marker
│   ├── sandbox.pid                    # Process ID file
│   ├── cursor-backup/                 # Original Cursor config
│   ├── machine-id-backup              # Original system machine-id
│   └── mac-backup                     # Original MAC address
└── README.md                          # This documentation
```

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test thoroughly
5. Submit a pull request

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## ⚠️ Important Notes

- **Always use a VPN** when creating new accounts
- **Use a new email address** for registration
- **Backup your data** before running system modifications
- **Test in a safe environment** before production use
- **This script modifies system files** - use with caution

## 🔗 Related Resources

- [Cursor IDE Official Website](https://cursor.sh/)
- [Linux Sandboxing Best Practices](https://github.com/jpzk/cursor-linux-sandbox)^10^
- [Bash Script Security Guidelines](https://gist.github.com/faelmori/b627dac543ce6cad80f1e9b9247db72a)^6^

---

**Remember**: This tool is designed for privacy and educational purposes. Respect software licenses and terms of service.

10 Citations

Bash-Cheat-Sheet/README.md at main · RehanSaeed/Bash-Cheat-Sheet
https://github.com/RehanSaeed/Bash-Cheat-Sheet/blob/main/README.md

bash-handbook/README.md at master · denysdovhan/bash-handbook
https://github.com/denysdovhan/bash-handbook/blob/master/README.md

How to Write a Good README File for Your GitHub Project
https://www.freecodecamp.org/news/how-to-write-a-good-readme-file/

Bash-Scripts/README.md at master · djeada/Bash-Scripts
https://github.com/djeada/Bash-Scripts/blob/master/README.md

bash-script/README.md at master · MrPoudel/bash-script
https://github.com/MrPoudel/bash-script/blob/master/README.md

README.md · GitHub
https://gist.github.com/faelmori/b627dac543ce6cad80f1e9b9247db72a

the-art-of-command-line/README.md at master · jlevy/the-art-of-command-line
https://github.com/jlevy/the-art-of-command-line/blob/master/README.md

This is my first bash script! This creates a README.md file inside a bunch of folders · GitHub
https://gist.github.com/njtierney/fc443f09842ff55221f4db3f08216fd2

Bash-scripts/README.md at master · LucHermitte/Bash-scripts
https://github.com/LucHermitte/Bash-scripts/blob/master/README.md

GitHub - jpzk/cursor-linux-sandbox: Linux sandbox for Cursor using bwrap and linux namespaces
https://github.com/jpzk/cursor-linux-sandbox