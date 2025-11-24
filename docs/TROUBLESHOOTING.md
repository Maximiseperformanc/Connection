# Troubleshooting Guide

Common issues and their solutions for Connection mobile development setup.

---

## Wake-on-LAN Issues

### Issue: PC doesn't wake up when I tap WOL button

**Possible Causes & Solutions:**

**1. Wake-on-LAN not enabled in BIOS**
- Solution: Restart PC, enter BIOS (F2/F12/Delete key)
- Look for "Wake on LAN" or "Power On by PCI-E"
- Set to **Enabled**
- Save and exit

**2. Network adapter settings**
- Windows: `devmgmt.msc` → Network Adapters → Your Adapter
- Power Management tab:
  - ☑ Allow this device to wake the computer
  - ☑ Only allow magic packets to wake computer
- Advanced tab:
  - Wake on Magic Packet: **Enabled**

**3. Wrong MAC address**
- Verify MAC address: `ipconfig /all` (Windows) or `ifconfig` (Mac/Linux)
- Must match exactly in WOL app (including colons/dashes)

**4. Router blocking WOL packets**
- Try WOL app when phone is on same WiFi network first
- If that works but cellular doesn't: Router needs configuration
- Enable "Allow WAN wake-up" in router settings

**5. Fast Startup enabled (Windows)**
- Fast Startup prevents true shutdown
- Disable: Control Panel → Power Options → Choose what power buttons do
- Uncheck "Turn on fast startup"
- Now use "Shut down" instead of "Sleep"

**6. PC is sleeping instead of shut down**
- WOL works from shutdown, not always from sleep
- Fully shut down PC before testing
- Or enable "Wake from S3 sleep" in BIOS

**Test WOL Locally First:**
```bash
# On another computer on same network:
wakeonlan 1A:2B:3C:4D:5E:6F
# If this works, problem is with remote WOL
```

---

## VS Code Remote Tunnel Issues

### Issue: "No tunnels found" when connecting

**Solutions:**

**1. Tunnel service not running**
```bash
# Check status:
code tunnel service status

# If not running:
code tunnel service start

# If that fails, reinstall:
code tunnel service uninstall
code tunnel service install
code tunnel service start
```

**2. Not logged in**
```bash
code tunnel user login
# Follow browser prompt to authenticate
```

**3. Tunnel name mismatch**
```bash
# Get exact tunnel name:
code tunnel service status

# Use this EXACT name when connecting from vscode.dev
```

**4. VS Code CLI not in PATH**
- Windows: Reinstall VS Code, check "Add to PATH" option
- Mac/Linux: `export PATH="$PATH:/Applications/Visual Studio Code.app/Contents/Resources/app/bin"`

### Issue: Tunnel disconnects frequently

**Solutions:**

**1. PC going to sleep**
- Windows: Power Settings → Never sleep when plugged in
- Mac: System Settings → Energy Saver → Prevent sleep when display is off
- Linux: `sudo systemctl mask sleep.target suspend.target`

**2. Network timeout**
- Check firewall isn't blocking VS Code
- Windows Firewall: Allow "Code.exe" and "code-tunnel.exe"

**3. VS Code version too old**
```bash
# Update VS Code:
winget upgrade Microsoft.VisualStudioCode
# Or download from: https://code.visualstudio.com
```

### Issue: "Tunnel authentication failed"

**Solution:**
```bash
# Logout and login again:
code tunnel user logout
code tunnel user login

# Use GitHub account (most reliable)
```

---

## Tailscale Issues

### Issue: Can't see PC in Tailscale device list

**Solutions:**

**1. Not logged in to same account**
- Ensure phone and PC use identical Tailscale account
- Logout and login on both devices with same email

**2. Tailscale not running on PC**
```bash
# Windows:
tailscale status
# If error, start it:
tailscale up

# Mac/Linux:
sudo tailscale status
sudo tailscale up
```

**3. Firewall blocking Tailscale**
- Windows: Allow "tailscale.exe" in Windows Defender
- Mac: System Settings → Privacy & Security → Allow Tailscale
- Linux: `sudo ufw allow in on tailscale0`

### Issue: Tailscale IP not working

**Solutions:**

**1. Verify both devices connected**
```bash
tailscale status
# Should show both PC and phone with green "active" status
```

**2. Try the other IP**
```bash
tailscale ip -4  # IPv4 (100.x.x.x)
tailscale ip -6  # IPv6 (fd7a:...)
```

**3. Ping test**
```bash
# On phone (using Termux or similar):
ping 100.x.x.x
# Should get responses
```

**4. MagicDNS not working**
- Go to: https://login.tailscale.com/admin/dns
- Enable "MagicDNS"
- Now use: `http://your-pc-name` instead of IP

### Issue: "Connection timed out" when accessing localhost:3001

**Solutions:**

**1. Service not running on PC**
```bash
# Verify service is running:
netstat -ano | findstr :3001   # Windows
lsof -i :3001                  # Mac/Linux
```

**2. Firewall blocking port**
```bash
# Windows - Allow port:
netsh advfirewall firewall add rule name="Allow 3001" dir=in action=allow protocol=TCP localport=3001

# Linux:
sudo ufw allow 3001
```

**3. App only listening on localhost**
- App must bind to `0.0.0.0` not `127.0.0.1`
- Check app config: `HOST=0.0.0.0` or `--host 0.0.0.0`

---

## Happy-Coder Issues

### Issue: Happy-Coder won't start

**Solutions:**

**1. Port 3456 already in use**
```bash
# Check what's using it:
netstat -ano | findstr :3456   # Windows
lsof -i :3456                  # Mac/Linux

# Kill the process:
# Windows:
taskkill /PID <pid> /F
# Mac/Linux:
kill -9 <pid>

# Or specify different port:
happy-coder start --port 3457
```

**2. npm package outdated**
```bash
npm install -g happy-coder@latest
```

**3. Node.js version too old**
```bash
node --version  # Need 18+

# Update Node.js:
winget upgrade OpenJS.NodeJS.LTS
```

### Issue: Session URL not working on phone

**Solutions:**

**1. Copy the full URL**
- Must include the full session ID: `https://happy.engineering/session/xxxxx-xxxxx-xxxxx`
- Don't truncate it

**2. Session expired**
- Sessions last 24 hours by default
- Restart happy-coder: `happy-coder start`
- Get new session URL

**3. Firewall blocking connection**
- Happy-Coder uses end-to-end encryption through their servers
- Check PC firewall allows outbound HTTPS connections

### Issue: Can't see Claude Code session in Happy-Coder

**Solutions:**

**1. Claude Code not running**
- Verify Claude Code CLI is active on PC
- Should see Claude prompt in terminal

**2. Happy-Coder not connected to Claude**
```bash
# Restart both:
# 1. Close Claude Code (Ctrl+C)
# 2. Stop happy-coder (Ctrl+C)
# 3. Start happy-coder first: happy-coder start
# 4. Start Claude Code: claude-code
```

**3. Wrong session URL**
- Each happy-coder instance gets unique URL
- Always use the URL from most recent `happy-coder start`

---

## General Network Issues

### Issue: "Connection refused" errors

**Checklist:**
1. Service running? `netstat -ano | findstr :PORT`
2. Tailscale connected? `tailscale status`
3. Firewall allowing port? Check Windows Defender / ufw
4. App binding to 0.0.0.0? Check app config
5. Correct IP? Use `tailscale ip -4`

### Issue: Very slow performance

**Solutions:**

**1. Choose closest Tailscale relay**
- Go to: https://login.tailscale.com/admin/machines
- Check "DERP region" for your devices
- Should be geographically close

**2. Enable direct connection**
- Tailscale works best with direct peer-to-peer
- Ensure UDP port 41641 is open on both devices
- Or use "subnet routing" for better performance

**3. Phone on slow cellular**
- Switch to WiFi for large file transfers
- Use vscode.dev for light editing (works well on 4G)
- Avoid video generation on cellular (uses lots of data)

### Issue: Intermittent disconnections

**Solutions:**

**1. PC going to sleep** (most common)
- Disable sleep: Power settings → Never
- Or enable "Wake on LAN" and wake it when needed

**2. Cellular switching towers**
- Tailscale handles IP changes gracefully
- Wait 10-30 seconds for reconnection

**3. Network timeout settings**
- Increase timeout in Tailscale:
  ```bash
  tailscale set --timeout=10m
  ```

---

## Permission Issues

### Issue: "Permission denied" in VS Code terminal

**Solutions:**

**1. File permissions**
```bash
# Make file executable:
chmod +x filename.sh
```

**2. Running as wrong user**
- VS Code tunnel runs as the user who started it
- Ensure that user has permissions for the files/folders

**3. SELinux (Linux)**
```bash
# Temporarily disable:
sudo setenforce 0
```

### Issue: Can't install packages with npm/pip

**Solutions:**

**1. Need sudo (Linux/Mac)**
```bash
sudo npm install -g package-name
```

**2. Permission error on Windows**
- Run VS Code as Administrator:
  - Right-click Code → "Run as administrator"

**3. npm prefix not writable**
```bash
# Fix npm permissions:
mkdir ~/.npm-global
npm config set prefix '~/.npm-global'
echo 'export PATH=~/.npm-global/bin:$PATH' >> ~/.profile
source ~/.profile
```

---

## GPU / RunPod Issues

### Issue: "Failed to start GPU pod"

**Solutions:**

**1. Not enough credits**
- Check credit balance in web app
- Minimum 30 credits required (default setting)

**2. GPU type unavailable**
- Try different GPU: Change `RUNPOD_GPU_TYPE_ID` in `.env.local`
- Or remove datacenter restriction: Comment out `RUNPOD_DATACENTER_ID`

**3. Invalid API key**
- Verify API key: Check `.env.local` → `RUNPOD_API_KEY`
- Regenerate at: https://www.runpod.io/console/user/settings

**4. Network volume not found**
- Ensure volume exists: Check RunPod Console → Storage
- Verify `RUNPOD_NETWORK_VOLUME_ID` matches volume name

### Issue: GPU pod stuck in "Starting" state

**Solutions:**

**1. Template error**
- Check template configuration in RunPod Console
- Ensure Docker image is valid
- Check template logs for errors

**2. Volume mount issue**
- Verify volume is in same datacenter as pod
- Check volume isn't attached to another pod

**3. Wait longer**
- First start can take 5-10 minutes (downloading image)
- Subsequent starts: 1-2 minutes

### Issue: Video generation fails

**Solutions:**

**1. Check pod logs**
```bash
# In Happy-Coder:
Ask Claude: "Show me the RunPod logs"

# Or via API:
curl http://100.x.x.x:4000/api/gpu/logs
```

**2. ComfyUI not responding**
- Pod might not have ComfyUI installed
- Check template includes ComfyUI setup

**3. Insufficient GPU memory**
- Try smaller resolution
- Use lower quality settings
- Or upgrade to GPU with more VRAM

---

## Browser Issues

### Issue: vscode.dev not loading on phone

**Solutions:**

**1. Browser too old**
- iOS: Update to iOS 14+
- Android: Use Chrome 90+

**2. Clear browser cache**
- Safari: Settings → Safari → Clear History and Website Data
- Chrome: Settings → Privacy → Clear Browsing Data

**3. Try different browser**
- iOS: Try both Safari and Chrome
- Android: Try Chrome, Firefox, or Edge

### Issue: Can't type in vscode.dev on phone

**Solutions:**

**1. Keyboard focus issue**
- Tap the editor area firmly
- Wait for keyboard to appear
- Try rotating phone to landscape

**2. Use external keyboard**
- Bluetooth keyboard works much better
- Or use "Desktop Site" mode in browser

### Issue: vscode.dev UI too small on phone

**Solutions:**

**1. Zoom in**
- Pinch to zoom on the editor area
- Or: Browser settings → Text size → Large

**2. Use tablet or landscape mode**
- Tablet gives better experience
- Landscape mode on phone shows more

**3. Hide panels**
- Hide sidebar: Hamburger menu → View → Appearance → Sidebar
- Hide activity bar: View → Appearance → Activity Bar
- More room for code

---

## Performance Optimization

### Issue: High battery drain on phone

**Solutions:**

**1. Close unused tabs/apps**
- Keep only essential tabs open
- Close Happy-Coder when not actively coding

**2. Lower screen brightness**
- Use dark theme in vscode.dev
- Reduce brightness in phone settings

**3. Use WiFi instead of cellular**
- Cellular uses more battery
- Switch to WiFi when possible

### Issue: Lag when typing in vscode.dev

**Solutions:**

**1. Latency issue**
- Check Tailscale ping: `tailscale ping your-pc`
- Should be < 100ms for good experience
- If > 200ms, consider cloud solution (GitHub Codespaces)

**2. PC under heavy load**
- Close unnecessary apps on PC
- Check CPU usage: `top` (Linux/Mac) or Task Manager (Windows)

**3. Disable extensions in VS Code**
- Some extensions cause lag
- Disable heavy extensions (linters, formatters) for remote sessions

### Issue: File search slow in vscode.dev

**Solutions:**

**1. Too many files indexed**
- Add to `.gitignore`: `node_modules`, `.next`, `dist`, etc.
- VS Code won't index ignored files

**2. Use Claude instead**
- Ask Happy-Coder: "Find all files that contain X"
- Faster for large codebases

---

## Error Messages

### "EADDRINUSE: address already in use"

**Cause:** Port already occupied by another process

**Solution:**
```bash
# Find what's using the port:
netstat -ano | findstr :4000   # Windows
lsof -i :4000                  # Mac/Linux

# Kill the process:
taskkill /PID <pid> /F         # Windows
kill -9 <pid>                  # Mac/Linux

# Or change port in .env.local:
PORT=4001
```

### "MODULE_NOT_FOUND"

**Cause:** Dependencies not installed

**Solution:**
```bash
# In VS Code terminal:
npm install
# Or for specific package:
npm install package-name
```

### "Cannot connect to Docker daemon"

**Cause:** Docker not running (if using Docker for local development)

**Solution:**
```bash
# Start Docker:
# Windows: Open Docker Desktop
# Linux:
sudo systemctl start docker
```

### "ECONNREFUSED"

**Cause:** Service not running or wrong URL

**Solution:**
1. Check service is running: `netstat -ano | findstr :PORT`
2. Verify Tailscale IP: `tailscale ip -4`
3. Check URL format: `http://100.x.x.x:PORT` (not `https://`)

---

## Advanced Troubleshooting

### Enable Debug Logging

**VS Code Tunnel:**
```bash
code tunnel --verbose
# Shows detailed connection logs
```

**Tailscale:**
```bash
tailscale status --json
# Shows full network status
```

**Happy-Coder:**
```bash
happy-coder start --debug
# Shows WebSocket connection logs
```

### Network Diagnostics

**Test Tailscale connection:**
```bash
# From phone (using Termux or PC):
tailscale ping your-pc-name
tailscale status --peers
```

**Test port accessibility:**
```bash
# From phone (using Termux):
nc -zv 100.x.x.x 3001
# Should say "succeeded" if port is open
```

**Check firewall rules:**
```bash
# Windows:
netsh advfirewall firewall show rule name=all

# Linux:
sudo ufw status verbose
```

### Reset Everything

**If nothing works, reset all services:**

```bash
# 1. Stop all services
code tunnel service stop
tailscale down
# Close happy-coder (Ctrl+C)

# 2. Clear configs
rm -rf ~/.config/code-tunnel
rm ~/.connection/config.json

# 3. Restart in order
tailscale up
code tunnel service start
happy-coder start

# 4. Verify each one works before proceeding
```

---

## Getting Help

### Before Asking for Help

Collect this information:

1. **System info:**
   ```bash
   # OS version:
   winver               # Windows
   sw_vers             # Mac
   lsb_release -a      # Linux

   # Node version:
   node --version

   # VS Code version:
   code --version
   ```

2. **Service status:**
   ```bash
   code tunnel service status
   tailscale status
   # Copy output
   ```

3. **Error messages:**
   - Full error text (don't summarize)
   - Screenshots help

4. **What you've tried:**
   - List solutions from this guide you've already attempted

### Where to Get Help

1. **GitHub Issues**: https://github.com/Maximiseperformanc/Connection/issues
2. **VS Code Tunnels**: https://github.com/microsoft/vscode-remote-release/issues
3. **Tailscale Forum**: https://forum.tailscale.com
4. **Happy-Coder**: https://github.com/happy-coding/happy-coder/issues

---

## Preventative Maintenance

### Weekly Checks

- [ ] Update VS Code: `winget upgrade Microsoft.VisualStudioCode`
- [ ] Update Happy-Coder: `npm update -g happy-coder`
- [ ] Update Tailscale: Check app for updates
- [ ] Verify WOL still works
- [ ] Check PC storage space (logs can accumulate)

### Monthly Tasks

- [ ] Rotate Tailscale auth keys (for security)
- [ ] Review firewall rules
- [ ] Clean up old Git branches
- [ ] Update Node.js: `winget upgrade OpenJS.NodeJS.LTS`

---

## Known Limitations

**What WON'T work on phone:**
- Complex IDE features (refactoring tools, debugging with breakpoints)
- Video/image editing (too resource-intensive)
- Large file uploads (> 100MB)
- Multiple monitors / complex layouts

**What works BUT is slow:**
- Very large Git operations (cloning huge repos)
- Full project rebuilds (use watch mode instead)
- Heavy compilation (C++, Rust, etc.)

**Recommendations:**
- Use phone for: reviews, small edits, monitoring, bug fixes
- Use PC for: major refactoring, large features, setup tasks

---

## Still Having Issues?

If you've tried everything in this guide and still facing problems:

1. Check if there's a newer version of this guide
2. Search GitHub issues for similar problems
3. Create a new issue with all the diagnostic info above

The community is here to help!
