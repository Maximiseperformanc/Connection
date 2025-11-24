# Connection Setup Script for Windows
# Installs all tools needed for remote mobile development

Write-Host "🔗 Connection - Mobile Development Setup" -ForegroundColor Cyan
Write-Host "========================================`n" -ForegroundColor Cyan

# Check if running as Administrator
$isAdmin = ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
if (-not $isAdmin) {
    Write-Host "⚠️  This script needs Administrator privileges for some installations." -ForegroundColor Yellow
    Write-Host "Please right-click PowerShell and select 'Run as Administrator'`n" -ForegroundColor Yellow

    $continue = Read-Host "Continue anyway? (y/n)"
    if ($continue -ne 'y') {
        exit
    }
}

Write-Host "`n📦 Step 1/5: Checking Prerequisites..." -ForegroundColor Yellow

# Check Node.js
Write-Host "  Checking Node.js..." -NoNewline
if (Get-Command node -ErrorAction SilentlyContinue) {
    $nodeVersion = node --version
    Write-Host " ✅ Found $nodeVersion" -ForegroundColor Green
} else {
    Write-Host " ❌ Not Found" -ForegroundColor Red
    Write-Host "`n  Installing Node.js via winget..." -ForegroundColor Yellow
    winget install OpenJS.NodeJS.LTS
    Write-Host "  ✅ Node.js installed" -ForegroundColor Green
}

# Check Git
Write-Host "  Checking Git..." -NoNewline
if (Get-Command git -ErrorAction SilentlyContinue) {
    $gitVersion = git --version
    Write-Host " ✅ Found $gitVersion" -ForegroundColor Green
} else {
    Write-Host " ❌ Not Found" -ForegroundColor Red
    Write-Host "`n  Installing Git via winget..." -ForegroundColor Yellow
    winget install Git.Git
    Write-Host "  ✅ Git installed" -ForegroundColor Green
}

Write-Host "`n🔧 Step 2/5: Installing Core Tools..." -ForegroundColor Yellow

# Install VS Code (if not present)
Write-Host "  Installing VS Code..." -NoNewline
if (Get-Command code -ErrorAction SilentlyContinue) {
    Write-Host " ✅ Already installed" -ForegroundColor Green
} else {
    winget install Microsoft.VisualStudioCode --silent
    Write-Host " ✅ Installed" -ForegroundColor Green
}

# Install Tailscale
Write-Host "  Installing Tailscale VPN..." -NoNewline
if (Get-Command tailscale -ErrorAction SilentlyContinue) {
    Write-Host " ✅ Already installed" -ForegroundColor Green
} else {
    winget install Tailscale.Tailscale --silent
    Write-Host " ✅ Installed" -ForegroundColor Green
}

# Install Happy-Coder
Write-Host "  Installing Happy-Coder..." -NoNewline
$happyInstalled = npm list -g happy-coder 2>&1 | Select-String "happy-coder"
if ($happyInstalled) {
    Write-Host " ✅ Already installed" -ForegroundColor Green
} else {
    npm install -g happy-coder
    Write-Host " ✅ Installed" -ForegroundColor Green
}

Write-Host "`n⚙️  Step 3/5: Configuring Services..." -ForegroundColor Yellow

# Configure VS Code Tunnel
Write-Host "  Setting up VS Code Remote Tunnel..." -NoNewline
try {
    # Install tunnel service
    code tunnel service install 2>&1 | Out-Null
    Write-Host " ✅ Service installed" -ForegroundColor Green

    Write-Host "`n  📝 You need to authenticate VS Code Tunnel:" -ForegroundColor Yellow
    Write-Host "     Run: code tunnel user login" -ForegroundColor White
    Write-Host "     Then: code tunnel service start`n" -ForegroundColor White
} catch {
    Write-Host " ⚠️  Manual setup needed" -ForegroundColor Yellow
}

# Start Tailscale
Write-Host "  Starting Tailscale..." -NoNewline
try {
    tailscale up 2>&1 | Out-Null
    $tailscaleIP = tailscale ip -4
    Write-Host " ✅ Connected" -ForegroundColor Green
    Write-Host "     Your Tailscale IP: $tailscaleIP" -ForegroundColor Cyan
} catch {
    Write-Host " ⚠️  Manual setup needed" -ForegroundColor Yellow
    Write-Host "     Run: tailscale up" -ForegroundColor White
}

Write-Host "`n🔐 Step 4/5: Configuring Wake-on-LAN..." -ForegroundColor Yellow

# Get MAC address
$macAddress = (Get-NetAdapter | Where-Object {$_.Status -eq "Up"} | Select-Object -First 1).MacAddress
Write-Host "  Your MAC Address: $macAddress" -ForegroundColor Cyan
Write-Host "  Use this in your phone's Wake-on-LAN app`n" -ForegroundColor White

# Enable Wake-on-LAN in network adapter
Write-Host "  Enabling Wake-on-LAN..." -NoNewline
try {
    $adapter = Get-NetAdapter | Where-Object {$_.Status -eq "Up"} | Select-Object -First 1
    Set-NetAdapterPowerManagement -Name $adapter.Name -WakeOnMagicPacket Enabled -ErrorAction SilentlyContinue
    Write-Host " ✅ Enabled" -ForegroundColor Green
} catch {
    Write-Host " ⚠️  Manual setup needed" -ForegroundColor Yellow
    Write-Host "     Go to: Device Manager > Network Adapter > Properties > Power Management" -ForegroundColor White
    Write-Host "     Enable: 'Allow this device to wake the computer'" -ForegroundColor White
}

Write-Host "`n✅ Step 5/5: Creating Configuration Files..." -ForegroundColor Yellow

# Create config directory
$configDir = "$HOME\.connection"
if (-not (Test-Path $configDir)) {
    New-Item -ItemType Directory -Path $configDir | Out-Null
}

# Save configuration
$config = @{
    tailscaleIP = $tailscaleIP
    macAddress = $macAddress
    setupDate = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
}
$config | ConvertTo-Json | Out-File "$configDir\config.json"
Write-Host "  ✅ Configuration saved to: $configDir\config.json" -ForegroundColor Green

Write-Host "`n" + "="*50 -ForegroundColor Cyan
Write-Host "🎉 Setup Complete!" -ForegroundColor Green
Write-Host "="*50 + "`n" -ForegroundColor Cyan

Write-Host "📱 Next Steps:" -ForegroundColor Yellow
Write-Host ""
Write-Host "1. Install phone apps:" -ForegroundColor White
Write-Host "   • Tailscale VPN" -ForegroundColor Cyan
Write-Host "   • Happy-Coder" -ForegroundColor Cyan
Write-Host "   • Mocha WOL (iOS) or Wake On Lan (Android)" -ForegroundColor Cyan
Write-Host ""
Write-Host "2. Configure VS Code Tunnel:" -ForegroundColor White
Write-Host "   code tunnel user login" -ForegroundColor Cyan
Write-Host "   code tunnel service start" -ForegroundColor Cyan
Write-Host ""
Write-Host "3. Start Happy-Coder server:" -ForegroundColor White
Write-Host "   happy-coder start" -ForegroundColor Cyan
Write-Host ""
Write-Host "4. Test from phone:" -ForegroundColor White
Write-Host "   • Open vscode.dev → Connect to Tunnel" -ForegroundColor Cyan
Write-Host "   • Open Happy-Coder app → Connect" -ForegroundColor Cyan
Write-Host "   • Browser → http://$tailscaleIP:3001" -ForegroundColor Cyan
Write-Host ""
Write-Host "📖 Full documentation: ./docs/SETUP.md" -ForegroundColor Yellow
Write-Host ""
Write-Host "✨ Happy coding from anywhere! ✨" -ForegroundColor Green
Write-Host ""
