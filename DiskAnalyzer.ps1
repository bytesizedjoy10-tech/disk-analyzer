# DiskAnalyzer.ps1 - Windows Disk Space Scanner
# Run as Administrator for full access
# Output: JSON for DiskDashboard.html

param(
    [string]$Drive = "C",
    [int]$TopN = 20,
    [string]$OutFile = "disk_data.json"
)

Write-Host "Scanning $Drive:\ drive..." -ForegroundColor Cyan

$DriveInfo = Get-PSDrive -Name $Drive | Select-Object Used, Free
$TotalGB   = [math]::Round(($DriveInfo.Used + $DriveInfo.Free) / 1GB, 1)
$UsedGB    = [math]::Round($DriveInfo.Used / 1GB, 1)
$FreeGB    = [math]::Round($DriveInfo.Free / 1GB, 1)
$FreePct   = [math]::Round(($DriveInfo.Free / ($DriveInfo.Used + $DriveInfo.Free)) * 100, 1)

Write-Host "  Drive: ${Drive}:\ | Total: ${TotalGB}GB | Used: ${UsedGB}GB | Free: ${FreeGB}GB (${FreePct}%)"

Write-Host "Scanning top folders (may take 1-2 minutes)..."
$Folders = Get-ChildItem "${Drive}:\" -ErrorAction SilentlyContinue | ForEach-Object {
    try {
        $Size = (Get-ChildItem $_.FullName -Recurse -ErrorAction SilentlyContinue | Measure-Object Length -Sum).Sum
        [PSCustomObject]@{ Name = $_.Name; Path = $_.FullName; SizeGB = [math]::Round($Size / 1GB, 2) }
    } catch { $null }
} | Where-Object { $_ -ne $null } | Sort-Object SizeGB -Descending | Select-Object -First $TopN

$TempPaths = @("$env:TEMP","$env:LOCALAPPDATA\Temp","C:\Windows\Temp","$env:LOCALAPPDATA\Google\Chrome\User Data\Default\Cache","$env:APPDATA\Spotify\Data")
$TempSizeGB = 0
foreach ($p in $TempPaths) {
    if (Test-Path $p) {
        $s = (Get-ChildItem $p -Recurse -ErrorAction SilentlyContinue | Measure-Object Length -Sum).Sum
        $TempSizeGB += [math]::Round($s / 1GB, 2)
    }
}

$Output = @{
    scanned_at   = (Get-Date -Format "yyyy-MM-dd HH:mm:ss")
    drive        = "${Drive}:"
    total_gb     = $TotalGB
    used_gb      = $UsedGB
    free_gb      = $FreeGB
    free_pct     = $FreePct
    cleanable_gb = $TempSizeGB
    top_folders  = $Folders
}

$Output | ConvertTo-Json -Depth 3 | Out-File -FilePath $OutFile -Encoding UTF8
Write-Host "Done! Output saved to: $OutFile" -ForegroundColor Green
Write-Host "Open DiskDashboard.html to visualize results." -ForegroundColor Cyan