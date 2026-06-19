# 💾 Disk Analyzer Dashboard

A PowerShell + HTML tool combo to visualize disk space usage on Windows — find what's eating your storage in seconds.

## Features

- 📁 Visual treemap of disk usage by folder
- 🎯 Highlights top 10 storage hogs automatically
- 🧹 One-click safe cleanup suggestions
- 📊 Breakdown by file type (media, installers, cache, etc.)
- 💾 Supports multiple drives (C:, D:, etc.)
- 🖥️ Clean dark-mode HTML dashboard

## Tech Stack

- **Data collection:** PowerShell (`DiskAnalyzer.ps1`)
- **Visualization:** HTML + CSS + JS (`DiskDashboard.html`)
- No installation needed — runs entirely locally

## Getting Started

```bash
git clone https://github.com/bytesizedjoy10-tech/disk-analyzer.git
cd disk-analyzer

# Step 1: Run PowerShell scanner (as Administrator)
powershell -ExecutionPolicy Bypass -File DiskAnalyzer.ps1

# Step 2: Open the dashboard
start DiskDashboard.html
```

## Example Output

Identified on a real 237GB drive:
- PES 2017 mod files: ~18GB
- CapCut AppData cache: ~12GB  
- Chrome cache: ~4GB
- Residual OneDrive/iCloud placeholders: ~3GB

## Contributing

PRs welcome — especially for macOS/Linux support!

---
Inspired by WinDirStat, but lighter and open source.
