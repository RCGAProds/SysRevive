<div align="center">
   
# SysRevive - Windows System Repair Script

![Windows](https://img.shields.io/badge/Windows-10%20%7C%2011-0078D6?style=for-the-badge&logo=windows&logoColor=white)
![PowerShell](https://img.shields.io/badge/PowerShell-5.1%2B-5391FE?style=for-the-badge&logo=powershell&logoColor=white)
![License](https://img.shields.io/badge/License-CC%20BY--NC%204.0-green?style=for-the-badge)
![Languages](https://img.shields.io/badge/Languages-ES%20%7C%20EN-orange?style=for-the-badge)

**PowerShell-based system recovery utility designed to repair Windows installations after unexpected shutdowns, power outages, or file system corruption**

[Features](#-features) • [Installation](#-installation) • [Usage](#️-usage) • [Workflow](#-repair-workflow) • [Logs](#-logs--diagnostics) • [Safety](#-security--responsibility-notes)

</div>

---

## 📋 Overview

This project is intended as a **technical portfolio piece**, showcasing system-level troubleshooting, defensive scripting, and operational safety practices.

**SysRevive - Windows System Repair Script** is an automated PowerShell solution that combines multiple Windows built-in repair utilities (SFC, DISM) in a structured, automated workflow with comprehensive error checking and progress reporting. Particularly useful after:

- 🔌 Power outages or unexpected shutdowns
- 💥 System crashes or blue screens (BSOD)
- 🗂️ File system corruption
- 🔄 Failed Windows updates
- ⚠️ System instability issues

---

## ✨ Features

### 🌍 Bilingual Support

- **Full Spanish and English interface** - select your preferred language at startup
- Translations for all messages and prompts

### 🛡️ Safety & Validation

- **Administrator safety checks** - automatic privilege verification
- **Automatic system restore point creation** before repairs begin
- **Disk space validation** - minimum 10GB recommended
- **Process duration warning** with detailed time estimates

### 🔍 Multi-Phase Integrity Verification

- **Phase 1**: System File Checker (SFC) initial scan
- **Phase 2**: DISM image health verification and repair
- **Phase 3**: Final SFC verification
- **Phase 4**: System Cleanup

### 🎨 Intuitive User Interface

- Color-coded status messages (Info, Success, Warning, Error)
- Real-time progress indicators with timestamps
- Visual separators and formatted output
- Execution time tracking per phase

### 📊 Detailed Reporting

- Exit code tracking for each operation
- Duration tracking for all phases
- Clear logging references for post-analysis
- Final summary with recommendations

---

## 🔧 Repair Workflow

The script follows a **defensive, layered repair strategy**:

### Pre-Flight Checks

- ✓ Administrator privileges verification
- ✓ Available disk space validation (minimum 10GB)
- ✓ System restore point creation
- ✓ User confirmation after duration warning

### Phase 1 – System File Checker (SFC)

```powershell
sfc /scannow
```

- Initial integrity scan and repair of protected system files
- Duration: **05-30 minutes**

### Phase 2 – DISM Image Repair

```powershell
DISM /Online /Cleanup-Image /CheckHealth
DISM /Online /Cleanup-Image /ScanHealth
DISM /Online /Cleanup-Image /RestoreHealth
```

- Image health check
- Component store scan
- Online image restoration
- Duration: **10-40 minutes**

### Phase 3 – Final Verification

```powershell
sfc /scannow
```

- Second SFC run to validate system consistency
- Ensures all repairs were successful
- Duration: **05-30 minutes**

### Phase 4 – Cleanup

```powershell
DISM /Online /Cleanup-Image /StartComponentCleanup
```

- Component cleanup to remove superseded files
- Frees up disk space
- Duration: **01-10 minutes**

**Total Estimated Time: 20 minutes to 2 hours (Depends on disk performance)**

---

## 💻 Requirements

| Requirement             | Details                           |
| ----------------------- | --------------------------------- |
| **Operating System**    | Windows 10 / Windows 11           |
| **PowerShell Version**  | 5.1 or later                      |
| **Privileges**          | Administrator rights required     |
| **Free Disk Space**     | Minimum 10GB on system drive (C:) |
| **Internet Connection** | Recommended for DISM operations   |
| **Time Required**       | 20 minutes to 2 hours             |

---

## 📥 Installation

### Option 1: Direct Download

1. Download both files from this repository:

   ```
   windows_repair_launcher.bat
   repair_windows.ps1
   ```

2. Place both files in the same folder (e.g., `C:\SystemRepair\`)

### Option 2: Git Clone

```bash
git clone https://github.com/RCGAProds/SysRevive.git
cd SysRevive
```

---

## ▶️ Usage

### Method 1: Using the Launcher (Recommended)

1. **Right-click** on `windows_repair_launcher.bat`
2. Select **"Run as administrator"**
3. Follow the on-screen prompts

### Method 2: Direct PowerShell Execution

1. Open **PowerShell as Administrator**
2. Navigate to the script directory
3. Execute:

```powershell
Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass
.\repair_windows.ps1
```

### Execution Steps

#### Step 1: Language Selection

```
╔═══════════════════════════════════════════════════════════╗
║          SELECCION DE IDIOMA / LANGUAGE SELECTION        ║
╚═══════════════════════════════════════════════════════════╝

  1. Español
  2. English

Select language / Seleccione idioma (1-2): _
```

#### Step 2: Duration Warning & Confirmation

The script will display:

- Estimated duration for each phase
- Total estimated time (20 min - 2 hours)
- Important recommendations before starting

```
╔═══════════════════════════════════════════════════════════╗
║                  IMPORTANT INFORMATION                    ║
╚═══════════════════════════════════════════════════════════╝

  ESTIMATED PROCESS DURATION
  ═══════════════════════════════════════════════════════════

  The repair process consists of 4 phases:
  • Phase 1 (Initial SFC): 05-30 minutes
  • Phase 2 (DISM): 10-40 minutes
  • Phase 3 (Final SFC): 05-30 minutes
  • Phase 4 (Cleanup): 01-10 minutes

  TOTAL ESTIMATED TIME: 20 minutes to 2 hours (Depends on disk performance)

  ═══════════════════════════════════════════════════════════

  IMPORTANT BEFORE CONTINUING:

  ✓ Make sure your computer is plugged into power
  ✓ Do not turn off or restart the computer during the process
  ✓ Close all open applications
  ✓ Save all your work before continuing
  ✓ The computer may become slow during the process
```

#### Step 3: Monitor Progress

The script will automatically execute all phases with real-time status updates:

```
[14:32:15] ⚙  Creating system restore point...
[14:32:18] ✓  Restore point created successfully
[14:32:19] ℹ  Free space on drive C: 45.23 GB

═══════════════════════════════════════════════════════════
  PHASE 1: System File Checker (SFC)
═══════════════════════════════════════════════════════════

[14:32:20] ⚙  Running SFC /scannow...
[14:32:20] ℹ  This process may take 05-30 minutes. Please wait...
```

#### Step 4: Review Results & Optional Restart

⚠️ **Do not interrupt the process once started**

---

## 📁 Logs & Diagnostics

After execution, review the following logs for detailed diagnostics and **incident analysis**:

The tool generates two types of logs for incident analysis:

1. **Launcher/Script Log:** Found in the script folder as `repair_powershell_YYYYMMDD_HHMMSS.log`. This tracks the script's logic and exit codes.
2. **Native Windows Logs:**
   - **SFC:** `C:\Windows\Logs\CBS\CBS.log`
   - **DISM:** `C:\Windows\Logs\DISM\dism.log`

### SFC Log Location

```
C:\Windows\Logs\CBS\CBS.log
```

**Contents**: System File Checker operations, file replacements, integrity violations

### DISM Log Location

```
C:\Windows\Logs\DISM\dism.log
```

**Contents**: Image servicing operations, component store repairs, Windows Update downloads

### Analyzing Logs

**Extract SFC-specific information:**

```powershell
findstr /c:"[SR]" C:\Windows\Logs\CBS\CBS.log > C:\SFC-Results.txt
```

**Check DISM errors and warnings:**

```powershell
Get-Content C:\Windows\Logs\DISM\dism.log | Select-String "Error|Warning" -Context 2,2
```

These logs are essential for **root cause investigation** and understanding what was repaired.

---

## 🔍 Troubleshooting

### Common Issues

#### ❌ "Script requires Administrator privileges"

**Solution**:

```
1. Right-click windows_repair_launcher.bat
2. Select "Run as administrator"
3. Click "Yes" on UAC prompt
```

#### ❌ "Execution Policy Error"

**Solution**: The launcher automatically bypasses execution policy. For manual execution:

```powershell
Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass
```

#### ❌ "Low disk space warning"

**Solution**:

- Free up at least 10GB on C: drive
- Empty Recycle Bin
- Run Disk Cleanup (cleanmgr.exe)
- Remove temporary files

#### ❌ "Cannot create restore point"

**Solution**:

- Ensure System Protection is enabled for C: drive
- Check sufficient privileges
- Script will continue even if restore point creation fails

#### ❌ "SFC found corrupt files but could not fix some of them"

**Explanation**:

- This is why DISM runs before final SFC verification
- DISM repairs the Windows image source files
- The final SFC pass should then succeed
- Review `CBS.log` for specific file details

---

## ❓ FAQ

### Q: Is this safe to run?

**A**: Yes. This script only uses official Windows built-in tools (SFC and DISM). It creates a restore point before starting and doesn't modify the registry or install third-party software.

### Q: Will I lose my files?

**A**: No. These tools only repair system files, not user data. Your documents, photos, and personal files are not affected.

### Q: Can I use my computer during the repair?

**A**: Not recommended. The computer will be slow, and interrupting the process could cause issues. Best to let it run unattended.

### Q: Do I need an internet connection?

**A**: DISM may download files from Windows Update if local files are corrupted. Internet connection is recommended but not always required.

### Q: What if the script gets stuck?

**A**: Some phases take a very long time (up to 40 minutes for DISM). Check the timestamp. If no progress after 60+ minutes, the process may be frozen.

### Q: Where are the log files?

**A**:

- SFC logs: `C:\Windows\Logs\CBS\CBS.log`
- DISM logs: `C:\Windows\Logs\DISM\dism.log`

### Q: Should I restart after completion?

**A**: Yes, highly recommended. The script will prompt for automatic restart.

---

## 🎯 Intended Use

This tool is intended for:

- ✔️ **Educational purposes** - learning system repair techniques
- ✔️ **Personal system recovery** - fixing your own computer
- ✔️ **Technical demonstrations** - showcasing PowerShell skills
- ✔️ **Portfolio and skill showcase** - professional development

It is **not intended for production environments** without prior validation, adaptation, and risk assessment.

---

## 🔐 Security & Responsibility Notes

- ⚠️ The script performs **read/write operations on system components**
- 💾 A restore point is created whenever possible, but **no guarantee is provided**
- 🔒 Always ensure critical data is backed up before running system repairs
- 🛡️ Use at your own risk

**The author is not responsible for any data loss or system issues that may occur.**

---

## 🤝 Contributing

Contributions are welcome! This is a portfolio project, but improvements are appreciated.

### Areas for Contribution

- 🌐 Additional language translations
- 🎨 UI/UX improvements
- 📊 Enhanced reporting features
- 📖 Documentation improvements

### How to Contribute

1. **Fork** the repository
2. **Create** a feature branch (`git checkout -b feature/AmazingFeature`)
3. **Commit** your changes (`git commit -m 'Add some AmazingFeature'`)
4. **Push** to the branch (`git push origin feature/AmazingFeature`)
5. **Open** a Pull Request

---

## 📜 License

This project is licensed under the **Creative Commons Attribution-NonCommercial 4.0 International (CC BY-NC 4.0)** license.

### You are free to:

- ✔️ **Share** — copy and redistribute the material in any medium or format
- ✔️ **Adapt** — remix, transform, and build upon the material

### Under the following terms:

- **Attribution** — You must give appropriate credit to the author, provide a link to the license, and indicate if changes were made
- **NonCommercial** — You may not use the material for commercial purposes

### Restrictions:

- ❌ **Commercial use is strictly prohibited** without explicit permission
- ❌ No enterprise deployment or integration into paid products/services

Full license text available at: https://creativecommons.org/licenses/by-nc/4.0/

See the [`LICENSE`](LICENSE) file for full details.

---

## 👤 Author

**Carlos García**  
IT Support | Junior SOC Analyst

### Commercial Usage

If you are interested in **commercial usage or integration**, please contact me to discuss a separate licensing agreement.

---

## 🙏 Acknowledgments

- Microsoft for SFC and DISM utilities
- PowerShell community for scripting best practices
- All contributors providing feedback and improvements

---

<div align="center">

**Made with ❤️ as a technical portfolio piece**

⭐ Star this repository if you found it helpful!

© 2026 Carlos García

</div>
