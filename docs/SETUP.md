# Complete Setup Guide - Connection

Step-by-step instructions to set up remote mobile development.

---

## Prerequisites

Before starting, ensure you have:
- Windows 10/11, macOS 10.15+, or Linux
- Administrator/sudo access
- Internet connection
- GitHub account (for VS Code tunnels)
- Tailscale account (free - create at https://login.tailscale.com/start)

**Estimated Time**: 30-45 minutes

---

## Step 1: Run Automated Setup (15 minutes)

### Windows

**Option A: One-Line Install (Recommended)**
```powershell
irm https://raw.githubusercontent.com/Maximiseperformanc/Connection/main/install.ps1 | iex
```

**Option B: Clone and Run**
```powershell
git clone https://github.com/Maximiseperformanc/Connection.git
cd Connection
.\setup-windows.ps1
```

### macOS/Linux

```bash
git clone https://github.com/Maximiseperformanc/Connection.git
cd Connection
chmod +x setup-linux.sh
./setup-linux.sh
```

**What gets installed**:
- Node.js 18+ (if not present)
- Git (if not present)
- VS Code with CLI tools
- Tailscale VPN client
- Happy-Coder (npm global package)
- Configuration files

---

## Step 2: Configure VS Code Remote Tunnel (5 minutes)

The setup script installs the tunnel service, but you need to authenticate:

**1. Login to VS Code Tunnel**
```bash
code tunnel user login
```
This opens a browser window. Sign in with:
- GitHub account (recommended)
- Microsoft account

**2. Start the Tunnel Service**

**Windows:**
```powershell
code tunnel service start
```

**macOS/Linux:**
```bash
code tunnel service install
code tunnel service start
```

**3. Get Your Tunnel Name**
```bash
code tunnel service status
```

You'll see something like:
```
Tunnel name: your-pc-name
Status: Connected
```

**Save this name** - you'll use it to connect from your phone.

---

## Step 3: Configure Tailscale (5 minutes)

**1. Start Tailscale**

**Windows:**
```powershell
tailscale up
```

**macOS/Linux:**
```bash
sudo tailscale up
```

This opens a browser for authentication. Sign in with:
- Google account
- GitHub account
- Microsoft account

**2. Get Your Tailscale IP**
```bash
tailscale ip -4
```

Example output: `100.64.0.1`

**Save this IP** - you'll use it to access your PC from phone.

**3. Verify Connection**
```bash
tailscale status
```

You should see your PC listed with an IP starting with `100.x.x.x`

---

## Step 4: Configure Happy-Coder (10 minutes)

Happy-Coder lets you control Claude Code from your phone.

**1. Start Happy-Coder Server**
```bash
happy-coder start
```

You'll see:
```
Happy-Coder server started!
Session URL: https://happy.engineering/session/xxxxx-xxxxx
```

**2. Save the Session URL**

Copy the URL shown in your terminal. This is your **private** connection link.

**3. Keep It Running**

Happy-Coder needs to stay running while you code. Options:

**Option A: Run in background (Windows)**
```powershell
Start-Process -NoNewWindow happy-coder start
```

**Option B: Run in tmux/screen (Linux/Mac)**
```bash
tmux new -d -s happy 'happy-coder start'
# Reconnect later with: tmux attach -t happy
```

**Option C: Run as service**
See `docs/TROUBLESHOOTING.md` for service setup instructions.

---

## Step 5: Configure Wake-on-LAN (5 minutes)

Wake-on-LAN lets you turn on your PC from your phone.

**1. Enable in BIOS**

Restart your PC and enter BIOS (usually F2, F12, or Delete key). Look for:
- "Wake on LAN"
- "Wake on PCI"
- "Power On by PCI-E device"

Set to **Enabled**.

**2. Enable in Operating System**

**Windows:**
```powershell
# 1. Open Device Manager
devmgmt.msc

# 2. Network Adapters > Your Adapter > Properties
# 3. Power Management tab:
#    ☑ Allow this device to wake the computer
#    ☑ Only allow magic packets to wake computer

# 3. Advanced tab:
#    Set "Wake on Magic Packet" to Enabled
```

**macOS:**
```bash
# System Settings > Energy Saver
# ☑ Wake for network access
```

**Linux:**
```bash
sudo ethtool -s eth0 wol g
# Replace eth0 with your network interface name
```

**3. Get Your MAC Address**

**Windows:**
```powershell
ipconfig /all
# Look for "Physical Address" like: 1A-2B-3C-4D-5E-6F
```

**macOS/Linux:**
```bash
ifconfig | grep ether
# Look for: ether 1a:2b:3c:4d:5e:6f
```

**Save this MAC address** - you'll enter it in the WOL app.

**4. Configure Router (if on WiFi)**

Some routers block WOL packets. Check your router settings:
- Enable "WAN Wake-on-LAN" or "Remote Wake-up"
- Forward UDP port 9 to your PC's local IP (optional)

---

## Step 6: Install Phone Apps (5 minutes)

Install these apps on your phone:

### Required Apps

**1. Tailscale VPN**
- iOS: https://apps.apple.com/app/tailscale/id1470499037
- Android: https://play.google.com/store/apps/details?id=com.tailscale.ipn

**2. Happy-Coder**
- iOS: https://apps.apple.com/app/happy-coder
- Android: https://play.google.com/store/apps/details?id=com.happycoder
- Web: https://happy.engineering

**3. Wake-on-LAN App**
- iOS: "Mocha WOL" (free) https://apps.apple.com/app/mocha-wol/id422625778
- Android: "Wake On Lan" (free) https://play.google.com/store/apps/details?id=co.uk.mrwebb.wakeonlan

### Optional Apps

**4. Browser** (for vscode.dev)
- Safari (iOS) or Chrome (Android) - already installed

---

## Step 7: Configure Phone Apps (5 minutes)

### Tailscale Setup (on phone)

1. Open Tailscale app
2. Tap "Sign In"
3. Use the same account you used on your PC
4. Your PC should appear in the device list
5. Tap your PC name to see its IP (100.x.x.x)

### Happy-Coder Setup (on phone)

1. Open Happy-Coder app (or go to https://happy.engineering)
2. Tap "Connect to Session"
3. Enter the session URL from Step 4
4. You should see your Claude Code session

### Wake-on-LAN Setup (on phone)

**For Mocha WOL (iOS):**
1. Open Mocha WOL app
2. Tap "+" to add device
3. Enter:
   - **Device Name**: My PC
   - **MAC Address**: (from Step 5.3)
   - **IP Address**: 192.168.0.255 (your network + .255)
   - **Port**: 9
4. Save

**For Wake On Lan (Android):**
1. Open Wake On Lan app
2. Tap "+" to add device
3. Enter:
   - **Device Name**: My PC
   - **MAC Address**: (from Step 5.3)
   - **Broadcast IP**: 192.168.0.255
   - **Port**: 9
4. Save

---

## Step 8: Test Everything (5 minutes)

### Test 1: Wake-on-LAN

1. Shut down your PC completely
2. Open WOL app on phone
3. Tap "My PC" or "Wake" button
4. Wait 30-60 seconds
5. Your PC should turn on

**Troubleshooting**: If it doesn't work, see `docs/TROUBLESHOOTING.md`

### Test 2: Tailscale Connection

1. Ensure Tailscale is running on both PC and phone
2. On phone: Open Tailscale app
3. Your PC should show "Connected" with green dot
4. Tap the IP to copy it (100.x.x.x)

### Test 3: VS Code Remote Tunnel

1. On phone: Open browser and go to https://vscode.dev
2. Tap hamburger menu (≡) → "Remote Tunnels"
3. Sign in with GitHub/Microsoft
4. Select your PC name from the list
5. You should see your PC's file system
6. Try editing a file - it works!

### Test 4: Happy-Coder

1. On PC: Ensure `happy-coder start` is running
2. On phone: Open Happy-Coder app
3. You should see your Claude Code session
4. Try sending a prompt: "What files are in this directory?"
5. Claude should respond with your file list

### Test 5: Access Web App (if applicable)

1. On phone: Open browser
2. Go to: `http://100.x.x.x:3001` (use your Tailscale IP)
3. You should see your web app running on your PC

---

## Step 9: Configuration Backup

Your setup created a config file at:
- **Windows**: `C:\Users\YourName\.connection\config.json`
- **macOS/Linux**: `~/.connection/config.json`

**Save this information**:
```json
{
  "tailscaleIP": "100.x.x.x",
  "macAddress": "1A:2B:3C:4D:5E:6F",
  "vscodeDevURL": "https://vscode.dev",
  "happyCoderSession": "https://happy.engineering/session/xxxxx",
  "setupDate": "2025-11-24"
}
```

---

## What's Next?

You're all set! See:
- **docs/WORKFLOW.md** - Typical usage scenarios
- **docs/TROUBLESHOOTING.md** - Common issues and fixes
- **docs/SECURITY.md** - Best practices for secure remote access

---

## Quick Reference

| Service | Access Method |
|---------|---------------|
| **VS Code** | https://vscode.dev → Remote Tunnels → Your PC |
| **Claude Code** | Happy-Coder app → Connect |
| **Web App** | Browser → `http://100.x.x.x:3001` |
| **Turn On PC** | WOL app → Tap "Wake" |

---

## Need Help?

- Check `docs/TROUBLESHOOTING.md`
- GitHub Issues: https://github.com/Maximiseperformanc/Connection/issues
- Happy-Coder Docs: https://happy.engineering/docs
- VS Code Tunnels Docs: https://code.visualstudio.com/docs/remote/tunnels
