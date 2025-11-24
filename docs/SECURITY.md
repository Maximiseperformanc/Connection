# Security Best Practices

How to keep your remote mobile development setup secure.

---

## Overview

Connection uses multiple security layers:
- **Tailscale**: WireGuard encryption for network traffic
- **VS Code Tunnels**: TLS encryption for remote editing
- **Happy-Coder**: Signal protocol (E2E encryption) for AI communication
- **Wake-on-LAN**: Magic packets (unencrypted but low-risk)

This guide helps you use these tools securely.

---

## Threat Model

### What Connection Protects Against ✅

1. **Network eavesdropping**: All traffic is encrypted
2. **Man-in-the-middle attacks**: Tailscale uses public key authentication
3. **Unauthorized access**: Authentication required for all services
4. **Exposed credentials**: Environment variables, not hardcoded

### What Connection Does NOT Protect Against ❌

1. **Compromised phone**: If phone is hacked, attacker gets your access
2. **Compromised PC**: If PC is infected, all bets are off
3. **Physical access**: Someone with physical access to PC can bypass everything
4. **Weak passwords**: If you use weak passwords, they can be cracked
5. **Supply chain attacks**: Malicious npm packages or system compromises

**Your Responsibility**: Keep both PC and phone secure (OS updates, antivirus, etc.)

---

## Critical Security Rules

### Rule 1: NEVER Expose Your PC Directly to Internet

**❌ BAD - Port forwarding on router:**
```
Router settings:
  Forward port 3001 → Your PC
  (Anyone on internet can access your PC!)
```

**✅ GOOD - Use Tailscale:**
```
Connection flow:
  Phone → Tailscale VPN → Your PC
  (Only your devices can connect)
```

**Why**: Exposed ports are constantly scanned by bots. Tailscale creates a private network.

---

### Rule 2: Protect Your API Keys

**❌ BAD:**
```typescript
// Hardcoded in code
const RUNPOD_API_KEY = 'rpa_abc123...';
```

**✅ GOOD:**
```typescript
// Environment variable
const RUNPOD_API_KEY = process.env.RUNPOD_API_KEY;
if (!RUNPOD_API_KEY) {
  throw new Error('RUNPOD_API_KEY not set');
}
```

**Where to store keys:**
- PC: `.env.local` (add to .gitignore)
- Never commit to git
- Never share in screenshots or logs

---

### Rule 3: Use Strong, Unique Passwords

**For these accounts:**
- Tailscale account
- GitHub account (for VS Code tunnels)
- Happy-Coder account (if applicable)
- RunPod account
- PC login

**Requirements:**
- Minimum 16 characters
- Mix of letters, numbers, symbols
- Unique (don't reuse across services)
- Use password manager (1Password, Bitwarden, etc.)

**Enable 2FA (Two-Factor Authentication):**
- ✅ GitHub: https://github.com/settings/security
- ✅ Tailscale: https://login.tailscale.com/admin/settings/security
- ✅ RunPod: https://www.runpod.io/console/user/settings

---

### Rule 4: Keep PC Physically Secure

**If someone has physical access to your PC, they can:**
- Read your files
- Steal API keys from .env.local
- Install malware
- Access your Tailscale network

**Protection measures:**
1. **Enable full disk encryption:**
   - Windows: BitLocker
   - Mac: FileVault
   - Linux: LUKS

2. **Lock screen when away:**
   - Windows: `Win + L`
   - Mac: `Cmd + Ctrl + Q`
   - Auto-lock after 5 minutes idle

3. **Strong login password:**
   - Not "password123" or your name
   - Minimum 12 characters

4. **Disable guest accounts:**
   - Remove any accounts others could use

---

### Rule 5: Secure Your Phone

**Your phone is now a key to your PC:**

1. **Enable screen lock:**
   - PIN: Minimum 6 digits (not birthday)
   - Biometrics: Face ID / Touch ID / Fingerprint

2. **Keep OS updated:**
   - iOS: Settings → General → Software Update
   - Android: Settings → System → System Update

3. **Don't jailbreak/root:**
   - Breaks security model
   - Makes all apps less secure

4. **Review app permissions:**
   - Tailscale: Needs VPN permission ✅
   - Happy-Coder: Needs network ✅
   - Other apps: Shouldn't need VPN access ❌

5. **Install apps from official stores only:**
   - Apple App Store
   - Google Play Store
   - Don't sideload APKs from random sites

---

## Service-Specific Security

### Tailscale Security

**Authentication:**
- Uses public key cryptography (like SSH)
- Each device gets unique keys
- Keys never leave the device

**Best Practices:**

1. **Use ACLs (Access Control Lists):**
   ```json
   // Tailscale Admin → Access Controls
   {
     "acls": [
       {
         "action": "accept",
         "src": ["your-phone"],
         "dst": ["your-pc:3001", "your-pc:4000"]
       }
     ]
   }
   ```
   This limits which ports phone can access.

2. **Enable MFA (Multi-Factor Auth):**
   - Tailscale Admin → Settings → Security
   - Require MFA for all users

3. **Review connected devices regularly:**
   - https://login.tailscale.com/admin/machines
   - Remove old/unused devices

4. **Set device expiry:**
   - Devices expire after 180 days by default
   - Forces re-authentication periodically

5. **Use tagged devices:**
   - Tag your PC as "dev-machine"
   - Tag your phone as "mobile"
   - Create ACL rules based on tags

**What Tailscale Logs:**
- Connection events (who connected when)
- Device metadata (OS, version)
- Does NOT log traffic content (encrypted)

**Revoking access:**
```bash
# Remove device immediately:
tailscale logout
# Device disappears from network
```

---

### VS Code Tunnel Security

**Authentication:**
- Uses GitHub OAuth or Microsoft account
- Access token stored locally
- Token expires after 90 days

**Best Practices:**

1. **Use GitHub account with 2FA enabled:**
   - https://github.com/settings/security
   - Use authenticator app (not SMS)

2. **Review authorized applications:**
   - https://github.com/settings/applications
   - Revoke "VS Code Tunnels" if compromised

3. **Monitor active tunnels:**
   ```bash
   code tunnel status
   # Shows current connections
   ```

4. **Close tunnel when not in use:**
   ```bash
   code tunnel service stop
   # Stops accepting connections
   ```

5. **Don't share tunnel name publicly:**
   - Anyone with your tunnel name + GitHub account access can connect
   - Treat tunnel name as semi-sensitive

**What VS Code Logs:**
- Connection timestamps
- File access (in .vscode-server/data/logs/)
- Does NOT send file contents to Microsoft

**Revoking access:**
```bash
# Uninstall tunnel service:
code tunnel service uninstall
# Logout:
code tunnel user logout
```

---

### Happy-Coder Security

**Encryption:**
- Uses Signal protocol (same as Signal Messenger)
- End-to-end encrypted
- Happy.engineering servers cannot read your code

**Best Practices:**

1. **Don't share session URLs:**
   - Session URL is like a password
   - Anyone with URL can see your session
   - Generate new session daily

2. **Verify session ID:**
   - First time connecting, verify session ID matches
   - Protects against impersonation

3. **Review code before approving:**
   - Always review Claude's changes
   - Don't blindly approve everything
   - Check for accidentally exposed secrets

4. **Use timeouts:**
   ```bash
   # Session expires after 24 hours by default
   happy-coder start --timeout 12h
   # Expire after 12 hours instead
   ```

5. **Clear session history:**
   ```bash
   # Remove old sessions:
   rm -rf ~/.happy-coder/sessions
   ```

**What Happy-Coder Logs:**
- Session metadata (start/end times)
- Does NOT log prompts or code (E2E encrypted)

**Revoking access:**
```bash
# Kill current session:
Ctrl+C (in terminal where happy-coder is running)
# Old session URL becomes invalid
```

---

### Wake-on-LAN Security

**Threat Level: Low**

Wake-on-LAN packets are:
- ❌ Unencrypted
- ❌ Unauthenticated
- ✅ But only turn PC on (can't access data)

**Potential Risks:**

1. **Someone wakes your PC unnecessarily:**
   - Wastes electricity
   - But can't access your files

2. **MAC address exposure:**
   - MAC address is semi-public anyway
   - Not a major risk

**Mitigation:**

1. **Use BIOS password:**
   - PC boots to password screen
   - Attacker can wake PC but can't login

2. **Full disk encryption:**
   - Even if someone bypasses login, disk is encrypted

3. **Limit WOL to local network:**
   - Disable WAN wake-up in router
   - Only works when phone is on same WiFi

**When WOL is a bigger risk:**
- Public WiFi: Others on network could wake your PC
- Solution: Disable WOL, or use VPN before WOL

---

## Scenario-Based Security

### Scenario 1: Phone is Lost/Stolen

**Immediate Actions:**

1. **Remote wipe phone** (if enabled):
   - iOS: https://www.icloud.com/find
   - Android: https://myaccount.google.com/find-your-phone

2. **Revoke Tailscale device:**
   - https://login.tailscale.com/admin/machines
   - Find your phone → Click "..." → "Disable"

3. **Logout from VS Code Tunnels:**
   - From PC: `code tunnel user logout`
   - Revoke GitHub access: https://github.com/settings/applications

4. **Change passwords:**
   - GitHub
   - Tailscale
   - Any passwords saved on phone

5. **Revoke API keys:**
   - RunPod: Generate new API key
   - Update .env.local on PC

**Prevention:**
- Enable "Find My" (iOS) or "Find My Device" (Android)
- Enable remote wipe capability
- Use strong screen lock (not 4-digit PIN)

---

### Scenario 2: PC is Compromised

**Immediate Actions:**

1. **Disconnect from internet:**
   - Unplug Ethernet or disable WiFi
   - Prevents further damage

2. **Stop all services:**
   ```bash
   code tunnel service stop
   tailscale down
   # Close happy-coder
   ```

3. **Change all passwords** (from different device):
   - GitHub, Tailscale, RunPod
   - Email accounts
   - Any accounts accessed from that PC

4. **Rotate API keys:**
   - RunPod: Generate new key
   - Any other APIs

5. **Scan for malware:**
   - Windows: Windows Defender full scan
   - Mac: Malwarebytes
   - Linux: ClamAV

6. **Reinstall OS** (if severely compromised):
   - Backup important files first
   - Clean install

**Prevention:**
- Keep OS and software updated
- Use antivirus
- Don't install random software
- Don't click suspicious links

---

### Scenario 3: Public WiFi Security

**Risk Level: Medium**

When using phone on public WiFi (coffee shop, airport):

**Threats:**
- Man-in-the-middle attacks
- Rogue WiFi access points
- Network sniffing

**Protection (Already Built In):**
- ✅ Tailscale encrypts all traffic
- ✅ VS Code Tunnels uses TLS
- ✅ Happy-Coder uses E2E encryption

**Additional precautions:**

1. **Verify network name:**
   - "Starbucks WiFi" vs "Starbukcs WiFi" (typo = fake)

2. **Use VPN before Tailscale:**
   - Optional extra layer
   - NordVPN, ExpressVPN, etc.

3. **Disable file sharing:**
   - iOS: Settings → General → AirDrop → Off
   - Android: Settings → Connections → Nearby Share → Off

4. **Forget network after use:**
   - Don't auto-reconnect to public WiFi

5. **Monitor active connections:**
   ```bash
   tailscale status
   # Look for unexpected peers
   ```

---

### Scenario 4: Sharing Code/Screenshots

**Accidental Exposure Risks:**

When sharing screenshots or code snippets, you might leak:
- API keys in .env files
- Tailscale IPs (100.x.x.x)
- Session URLs (happy.engineering/session/...)
- File paths revealing sensitive info

**Safe Sharing Practices:**

1. **Redact sensitive info:**
   - Replace API keys: `RUNPOD_API_KEY=rpa_***REDACTED***`
   - Replace IPs: `http://100.x.x.x` → `http://<tailscale-ip>`

2. **Use .env.example:**
   ```bash
   # Instead of sharing .env.local, create:
   cp .env.local .env.example
   # Then edit .env.example to remove real values
   ```

3. **Review before posting:**
   - Read entire screenshot
   - Check URL bar (might show session URLs)
   - Check terminal history

4. **Use private GitHub repos:**
   - Don't push sensitive files to public repos
   - Add to .gitignore:
     ```
     .env.local
     .connection/config.json
     *.key
     *.pem
     ```

---

## Compliance & Privacy

### Data Residency

**Where your data goes:**

| Service | Your Code Stored | Processing Location |
|---------|------------------|---------------------|
| **VS Code Tunnels** | On your PC only | Microsoft servers (relay) |
| **Tailscale** | Never leaves devices | Tailscale servers (relay) |
| **Happy-Coder** | On your PC only | Happy servers (E2E encrypted) |
| **RunPod** | On rented GPU | RunPod datacenters (EU/US) |

**For GDPR/HIPAA compliance:**
- Your code never leaves your PC (unless you use RunPod)
- RunPod GPU sessions: Choose EU datacenter for GDPR
- Tailscale: Offers EU-only relay servers

### Logging & Monitoring

**What gets logged where:**

**On Your PC:**
- VS Code Server logs: `~/.vscode-server/data/logs/`
- Tailscale logs: `%ProgramData%\Tailscale\` (Windows)
- Happy-Coder logs: `~/.happy-coder/logs/`
- Your app logs: Wherever you configured

**On Remote Servers:**
- Tailscale: Connection metadata (timestamps, IPs)
- VS Code: Connection events (no code content)
- Happy-Coder: Session metadata (no message content)

**Retention:**
- VS Code logs: 7 days
- Tailscale logs: 90 days
- Happy-Coder logs: 30 days

---

## Security Checklist

### Initial Setup ✓

- [ ] Enabled 2FA on GitHub
- [ ] Enabled 2FA on Tailscale
- [ ] Used strong, unique passwords
- [ ] Enabled full disk encryption (BitLocker/FileVault)
- [ ] API keys in .env.local (not hardcoded)
- [ ] Added .env.local to .gitignore
- [ ] Configured firewall to allow only necessary ports
- [ ] Enabled screen lock on PC and phone

### Weekly Maintenance ✓

- [ ] Review Tailscale connected devices
- [ ] Review VS Code tunnel status
- [ ] Check for OS updates (PC and phone)
- [ ] Rotate Happy-Coder session URLs
- [ ] Review recent git commits for exposed secrets

### Monthly Maintenance ✓

- [ ] Update all software (VS Code, Node.js, Tailscale)
- [ ] Review Tailscale ACLs
- [ ] Review GitHub authorized applications
- [ ] Backup important files
- [ ] Test disaster recovery (can you revoke access quickly?)

### Quarterly Maintenance ✓

- [ ] Rotate API keys (RunPod, etc.)
- [ ] Change passwords (use password manager)
- [ ] Review security logs
- [ ] Test wake-on-LAN still works
- [ ] Update this security checklist if threats changed

---

## Incident Response Plan

**If you suspect a security breach:**

### Phase 1: Contain (Immediate - 5 minutes)

1. Disconnect devices from network
2. Stop all services (Tailscale, VS Code tunnel, Happy-Coder)
3. Revoke all access tokens

### Phase 2: Assess (30 minutes)

1. Check Tailscale logs for unauthorized connections
2. Check VS Code tunnel logs
3. Check git history for unexpected commits
4. Check running processes for malware
5. Check file modification times

### Phase 3: Recover (1-2 hours)

1. Change all passwords
2. Rotate all API keys
3. Scan for malware
4. Restore from backup if necessary
5. Re-enable services one by one

### Phase 4: Learn (After incident)

1. Document what happened
2. Identify root cause
3. Update this security guide
4. Implement additional protections

---

## Security Tools

### Recommended Tools

**Password Manager:**
- 1Password (paid, best UX)
- Bitwarden (free, open source)
- KeePassXC (free, offline)

**2FA Authenticator:**
- Authy (multi-device sync)
- Google Authenticator (simple)
- 1Password (if using it for passwords)

**Antivirus:**
- Windows: Windows Defender (built-in, free, good enough)
- Mac: Malwarebytes (free)
- Linux: ClamAV (free)

**Network Monitor:**
- Wireshark (see all network traffic)
- Little Snitch (Mac firewall)
- GlassWire (Windows firewall)

**Secret Scanner:**
```bash
# Scan git history for exposed secrets:
npm install -g truffleHog
truffleHog --regex --entropy=False .
```

---

## Advanced Security (Optional)

### Use SSH Keys Instead of Passwords

For git operations:
```bash
# Generate key:
ssh-keygen -t ed25519 -C "your_email@example.com"

# Add to GitHub:
cat ~/.ssh/id_ed25519.pub
# Paste in: https://github.com/settings/keys

# Use SSH URLs:
git clone git@github.com:user/repo.git
```

### Use Yubikey for 2FA

Hardware security key (like Yubikey):
- More secure than SMS or authenticator app
- Works with GitHub, Tailscale, Google

### Set Up Fail2Ban

Automatically block repeated failed login attempts:
```bash
# Linux only:
sudo apt install fail2ban
sudo systemctl enable fail2ban
```

### Enable Audit Logging

**Windows:**
```powershell
# Enable PowerShell logging:
Set-ItemProperty -Path "HKLM:\Software\Policies\Microsoft\Windows\PowerShell\ScriptBlockLogging" -Name "EnableScriptBlockLogging" -Value 1
```

**Linux:**
```bash
# Install auditd:
sudo apt install auditd
sudo systemctl enable auditd
```

---

## Myths vs Reality

**Myth: "Tailscale can see my code"**
- Reality: Tailscale only relays encrypted packets. They can't decrypt.

**Myth: "VS Code tunnels sends my code to Microsoft"**
- Reality: Code stays on your PC. Only relay traffic is proxied.

**Myth: "WOL is dangerous, hackers can control my PC"**
- Reality: WOL only turns PC on. Still need to bypass login.

**Myth: "Open source = more secure"**
- Reality: Open source CAN be more secure (more eyes), but not automatically.

**Myth: "I don't need 2FA, I have a strong password"**
- Reality: Strong password helps, but 2FA protects against phishing and leaks.

---

## Resources

**Official Security Documentation:**
- Tailscale Security: https://tailscale.com/security
- VS Code Tunnels Security: https://code.visualstudio.com/docs/remote/tunnels#_security
- Happy-Coder Security: https://happy.engineering/security

**Security Audits:**
- Tailscale: https://tailscale.com/security/audits
- (Check Happy-Coder and VS Code sites for their audits)

**Reporting Vulnerabilities:**
- Tailscale: security@tailscale.com
- VS Code: https://github.com/microsoft/vscode/security/policy
- Happy-Coder: (check their GitHub security policy)
- This Project: https://github.com/Maximiseperformanc/Connection/security

---

## Final Thoughts

**Good security is layered:**
- No single tool makes you 100% secure
- Connection uses multiple layers (encryption, authentication, ACLs)
- Your behavior matters most (strong passwords, keeping software updated, reviewing changes)

**Convenience vs Security:**
- More security = more friction
- Find the right balance for your risk tolerance
- Coding personal projects: Connection's defaults are good
- Handling sensitive data: Add extra layers (hardware keys, stricter ACLs, etc.)

**Stay informed:**
- Follow Tailscale, VS Code, and Happy-Coder security advisories
- Update this guide as you learn new threats
- Share security tips with other users

**Secure by default:**
- Connection is designed to be secure out-of-the-box
- But you must maintain it (updates, password rotation, etc.)

---

Stay safe, and happy coding from anywhere! 🔒
