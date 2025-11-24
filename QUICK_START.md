# 🚀 Quick Start - Get Coding on Your Phone in 15 Minutes

Follow these steps IN ORDER to start coding from your phone.

---

## PART 1: Setup Your PC (10 minutes)

### Step 1: Run the Setup Script

Open PowerShell on your PC and run:

```powershell
cd C:\Users\maxbu\Connection
.\setup-windows.ps1
```

This will:
- Install VS Code (if needed)
- Install Tailscale VPN
- Install Happy-Coder
- Configure everything

**Important:** Say "yes" when it asks for permissions.

---

### Step 2: Authenticate VS Code Tunnel

After the script finishes, run:

```powershell
code tunnel user login
```

1. A browser window will open
2. Click "Sign in with GitHub"
3. Login to your GitHub account
4. Authorize VS Code

Then start the tunnel:

```powershell
code tunnel service start
```

---

### Step 3: Connect to Tailscale

Run:

```powershell
tailscale up
```

1. A browser window will open
2. Sign in with Google, GitHub, or Microsoft
3. Authorize Tailscale

Get your Tailscale IP (write this down):

```powershell
tailscale ip -4
```

You'll see something like: `100.64.0.123`

**WRITE DOWN THIS IP - YOU'LL NEED IT ON YOUR PHONE**

---

### Step 4: Start Happy-Coder

Run:

```powershell
happy-coder start
```

You'll see:
```
Happy-Coder server started!
Session URL: https://happy.engineering/session/xxxxx-xxxxx-xxxxx
```

**COPY THIS URL - YOU'LL NEED IT ON YOUR PHONE**

Keep this terminal window open (minimize it, don't close it).

---

### Step 5: Get Your MAC Address (for Wake-on-LAN)

Run:

```powershell
ipconfig /all
```

Look for "Physical Address" under your network adapter.
Example: `1A-2B-3C-4D-5E-6F`

**WRITE DOWN THIS MAC ADDRESS**

---

## PART 2: Setup Your Phone (5 minutes)

### Step 6: Install Apps on Your Phone

Open the App Store (iOS) or Play Store (Android) and install:

**Required Apps:**
1. **Tailscale**
   - iOS: https://apps.apple.com/app/tailscale/id1470499037
   - Android: https://play.google.com/store/apps/details?id=com.tailscale.ipn

2. **Happy-Coder**
   - iOS: Search "Happy-Coder" in App Store
   - Android: Search "Happy-Coder" in Play Store
   - Or use web: https://happy.engineering

3. **Wake-on-LAN App**
   - iOS: "Mocha WOL" (free)
   - Android: "Wake On Lan" (free)

---

### Step 7: Configure Tailscale on Phone

1. Open **Tailscale** app on phone
2. Tap **"Sign In"**
3. **Use the SAME account** you used on PC (Google/GitHub/Microsoft)
4. Your PC should appear in the device list
5. You should see your PC with the IP (100.x.x.x)

**Test:** Tap the IP to copy it - you'll use this to access your apps.

---

### Step 8: Configure Happy-Coder on Phone

1. Open **Happy-Coder** app (or go to https://happy.engineering in browser)
2. Tap **"Connect to Session"**
3. **Paste the session URL** from Step 4 on your PC
4. You should see your Claude Code session

**Test:** Send a message: "What files are in this directory?"
Claude should respond with your file list!

---

### Step 9: Configure Wake-on-LAN

Open your **WOL app** on phone:

**For Mocha WOL (iOS):**
1. Tap **"+"** to add device
2. Enter:
   - **Device Name:** My PC
   - **MAC Address:** (paste the MAC from Step 5)
   - **IP Address:** 192.168.0.255 (change to your network)
   - **Port:** 9

**For Wake On Lan (Android):**
1. Tap **"+"**
2. Enter:
   - **Device Name:** My PC
   - **MAC Address:** (paste the MAC from Step 5)
   - **Broadcast IP:** 192.168.0.255
   - **Port:** 9

---

## PART 3: Start Coding! (Now!)

### Test Everything Works:

#### Test 1: Access VS Code from Phone

1. Open **Safari** or **Chrome** on your phone
2. Go to: **https://vscode.dev**
3. Tap the hamburger menu (≡) → **"Remote Tunnels"**
4. Sign in with GitHub
5. Select your PC from the list
6. **You're in!** You can now edit files from your phone!

---

#### Test 2: Control Claude Code from Phone

1. Open **Happy-Coder** app
2. Type: "Show me the video-gen-app README file"
3. Claude reads the file and shows you the content
4. Try: "What's in the .env.local file?"
5. **It works!** Claude Code controlled from your phone!

---

#### Test 3: Access Your Web App

1. Open **browser** on phone
2. Go to: **http://100.x.x.x:3001** (use YOUR Tailscale IP from Step 3)
3. You should see your video-gen-app web interface
4. **It works!** You can access localhost from your phone!

---

#### Test 4: Wake Your PC Remotely

1. **Shut down your PC** completely
2. Wait 30 seconds
3. Open **WOL app** on phone
4. Tap **"My PC"** or **"Wake"** button
5. Wait 30-60 seconds
6. Your PC should turn on!
7. Check Tailscale app - PC should appear online

---

## Common Issues & Quick Fixes

### Issue: Can't see PC in Tailscale on phone
**Fix:** Make sure you're using the SAME account on both devices

### Issue: Happy-Coder session not connecting
**Fix:** Make sure `happy-coder start` is still running on your PC

### Issue: vscode.dev can't find PC
**Fix:** Make sure `code tunnel service start` is running on PC

### Issue: Can't access localhost:3001
**Fix:** Make sure your web app is running: `npm run dev` in video-gen-app

### Issue: Wake-on-LAN doesn't work
**Fix:** Enable WOL in BIOS (restart PC, press F2/Del, enable "Wake on LAN")

---

## Your URLs Quick Reference

**Write these down or bookmark them:**

| Service | URL |
|---------|-----|
| VS Code on Phone | https://vscode.dev |
| Happy-Coder | https://happy.engineering |
| Your Web App | http://100.x.x.x:3001 (your Tailscale IP) |
| Your API | http://100.x.x.x:4000 (your Tailscale IP) |

---

## Daily Workflow

**Morning - Turn on PC and start coding:**

1. Open **WOL app** → Tap "Wake" → PC turns on (30 sec)
2. Open **Tailscale** → Verify PC is online
3. Open **vscode.dev** → Connect to tunnel → Edit code
4. Open **Happy-Coder** → Ask Claude to help

**Evening - Check on video generation:**

1. Open **browser** → Go to http://100.x.x.x:3001
2. Start a GPU pod
3. Generate a video
4. Check progress from phone
5. Download when done

**Lunch break - Quick bug fix:**

1. Open **Happy-Coder**
2. Tell Claude: "Fix the authentication bug in auth.ts"
3. Review changes
4. Approve and commit
5. Done in 5 minutes!

---

## Pro Tips

### Save These as Bookmarks on Phone:

1. vscode.dev - Your code editor
2. https://happy.engineering - Claude Code control
3. http://100.x.x.x:3001 - Your web app
4. http://100.x.x.x:4000/health - API health check

### Add to Home Screen (Makes it feel like a native app):

1. Open vscode.dev in Safari/Chrome
2. Tap **Share** → **"Add to Home Screen"**
3. Name it "VS Code"
4. Now tap the icon to open it like an app!

Do the same for Happy-Coder and your web app.

---

## What to Do If Something Breaks

**If you get stuck, try this order:**

1. Restart happy-coder on PC: `Ctrl+C` then `happy-coder start`
2. Restart VS Code tunnel: `code tunnel service restart`
3. Restart Tailscale: `tailscale down` then `tailscale up`
4. Restart your PC
5. Check docs/TROUBLESHOOTING.md for specific errors

---

## Need More Help?

- **Detailed setup:** See `docs/SETUP.md`
- **Workflows:** See `docs/WORKFLOW.md`
- **Troubleshooting:** See `docs/TROUBLESHOOTING.md`
- **Security:** See `docs/SECURITY.md`

---

## You're All Set! 🎉

You can now:
- ✅ Code from your phone anywhere
- ✅ Control Claude Code from mobile
- ✅ Access your PC's localhost apps
- ✅ Turn on your PC remotely
- ✅ Work on your video-gen-app from the couch

**Start coding from anywhere!** 📱💻✨
