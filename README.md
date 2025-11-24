# 🔗 Connection - Remote Mobile Development Setup

Complete solution for coding on your phone with access to your PC, RunPod GPU, and Claude Code.

## 🎯 What This Is

A comprehensive setup to enable:
- 📱 Full VS Code access from your phone
- 🤖 Claude Code control via mobile app
- 💻 Remote access to your PC
- 🎮 RunPod GPU management
- 🔐 Secure encrypted connections

## 🚀 Quick Start

### One-Line Install (Windows)
```powershell
irm https://raw.githubusercontent.com/Maximiseperformanc/Connection/main/install.ps1 | iex
```

### Manual Install
```powershell
git clone https://github.com/Maximiseperformanc/Connection.git
cd Connection
.\setup-windows.ps1
```

## 📦 What Gets Installed

1. **VS Code Remote Tunnels** - Edit files from phone
2. **Happy-Coder** - Claude Code mobile control
3. **Tailscale VPN** - Secure remote access
4. **Wake-on-LAN** - Turn on PC from phone

## 📱 Phone Apps Required

- **Tailscale** ([iOS](https://apps.apple.com/app/tailscale) / [Android](https://play.google.com/store/apps/details?id=com.tailscale.ipn))
- **Happy-Coder** ([iOS](https://apps.apple.com/app/happy-coder) / [Android](https://play.google.com/store/apps/details?id=com.happycoder))
- **Mocha WOL** ([iOS](https://apps.apple.com/app/mocha-wol)) or **Wake On Lan** ([Android](https://play.google.com/store/apps/details?id=co.uk.mrwebb.wakeonlan))

## 🎬 Typical Workflow

1. **Turn on PC** - Tap Wake-on-LAN button
2. **Edit Code** - Open vscode.dev → Connect to tunnel
3. **Use Claude** - Happy-Coder app → Send AI prompts
4. **View App** - Browser → `your-pc:3001`

## 📖 Full Documentation

- [Complete Setup Guide](./docs/SETUP.md)
- [Mobile Workflow Tutorial](./docs/WORKFLOW.md)
- [Troubleshooting](./docs/TROUBLESHOOTING.md)
- [Security Best Practices](./docs/SECURITY.md)

## 🛠️ Architecture

```
Phone
  ├── Happy-Coder App → Claude Code on PC
  ├── vscode.dev → VS Code Remote Tunnel
  ├── Browser → Tailscale VPN → localhost:3001
  └── Wake-on-LAN App → Power on PC
```

## 💰 Cost

**FREE** for personal use:
- VS Code Remote Tunnels: FREE
- Happy-Coder: FREE (open source)
- Tailscale: FREE (up to 100 devices)
- Wake-on-LAN apps: FREE

## 📋 Requirements

**PC:**
- Windows 10/11 (or macOS/Linux)
- Node.js 18+
- Git

**Phone:**
- iOS 14+ or Android 8+
- Internet connection (WiFi or cellular)

## 🔒 Security

All connections are encrypted:
- Tailscale: WireGuard protocol
- Happy-Coder: Signal protocol (E2E encrypted)
- VS Code Tunnels: TLS encryption

## 🤝 Contributing

This is a personal setup repository. Feel free to fork for your own use!

## 📄 License

MIT License - Use freely for personal or commercial projects.

---

**Created with [Claude Code](https://claude.ai/claude-code)**
