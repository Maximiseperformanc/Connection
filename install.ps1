# Connection One-Line Installer for Windows
# Usage: irm https://raw.githubusercontent.com/Maximiseperformanc/Connection/main/install.ps1 | iex

$ErrorActionPreference = "Stop"

Write-Host "🔗 Connection - Quick Installer" -ForegroundColor Cyan
Write-Host "================================`n" -ForegroundColor Cyan

# Create temp directory
$tempDir = "$env:TEMP\connection-install"
New-Item -ItemType Directory -Path $tempDir -Force | Out-Null

try {
    # Download setup script
    Write-Host "📥 Downloading setup script..." -ForegroundColor Yellow
    $setupUrl = "https://raw.githubusercontent.com/Maximiseperformanc/Connection/main/setup-windows.ps1"
    $setupPath = "$tempDir\setup-windows.ps1"

    Invoke-WebRequest -Uri $setupUrl -OutFile $setupPath -UseBasicParsing
    Write-Host "✅ Downloaded`n" -ForegroundColor Green

    # Run setup script
    Write-Host "🚀 Running setup...`n" -ForegroundColor Yellow
    & PowerShell.exe -ExecutionPolicy Bypass -File $setupPath

    Write-Host "`n✅ Installation complete!" -ForegroundColor Green

} catch {
    Write-Host "`n❌ Installation failed: $_" -ForegroundColor Red
    exit 1
} finally {
    # Cleanup
    Remove-Item -Path $tempDir -Recurse -Force -ErrorAction SilentlyContinue
}
