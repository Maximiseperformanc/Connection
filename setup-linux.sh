#!/bin/bash
# Connection Setup Script for macOS/Linux
# Installs all tools needed for remote mobile development

set -e  # Exit on error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

echo -e "${CYAN}🔗 Connection - Mobile Development Setup${NC}"
echo -e "${CYAN}========================================${NC}\n"

# Detect OS
OS="unknown"
if [[ "$OSTYPE" == "linux-gnu"* ]]; then
    OS="linux"
elif [[ "$OSTYPE" == "darwin"* ]]; then
    OS="macos"
else
    echo -e "${RED}❌ Unsupported OS: $OSTYPE${NC}"
    exit 1
fi

echo -e "${CYAN}Detected OS: $OS${NC}\n"

# Check if running as root (we don't want that)
if [ "$EUID" -eq 0 ]; then
    echo -e "${YELLOW}⚠️  Please run this script as a normal user (not root)${NC}"
    echo -e "${YELLOW}Some commands will ask for your password when needed${NC}\n"
    read -p "Continue anyway? (y/n) " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        exit 1
    fi
fi

echo -e "\n${YELLOW}📦 Step 1/5: Checking Prerequisites...${NC}"

# Check Node.js
echo -n "  Checking Node.js... "
if command -v node &> /dev/null; then
    NODE_VERSION=$(node --version)
    echo -e "${GREEN}✅ Found $NODE_VERSION${NC}"
else
    echo -e "${RED}❌ Not Found${NC}"
    echo -e "\n  ${YELLOW}Installing Node.js...${NC}"

    if [ "$OS" == "macos" ]; then
        # Install Homebrew if needed
        if ! command -v brew &> /dev/null; then
            echo "  Installing Homebrew..."
            /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
        fi
        brew install node
    elif [ "$OS" == "linux" ]; then
        # Use NodeSource repository for latest Node.js
        curl -fsSL https://deb.nodesource.com/setup_lts.x | sudo -E bash -
        sudo apt-get install -y nodejs
    fi

    echo -e "  ${GREEN}✅ Node.js installed${NC}"
fi

# Check Git
echo -n "  Checking Git... "
if command -v git &> /dev/null; then
    GIT_VERSION=$(git --version)
    echo -e "${GREEN}✅ Found $GIT_VERSION${NC}"
else
    echo -e "${RED}❌ Not Found${NC}"
    echo -e "\n  ${YELLOW}Installing Git...${NC}"

    if [ "$OS" == "macos" ]; then
        brew install git
    elif [ "$OS" == "linux" ]; then
        sudo apt-get update
        sudo apt-get install -y git
    fi

    echo -e "  ${GREEN}✅ Git installed${NC}"
fi

echo -e "\n${YELLOW}🔧 Step 2/5: Installing Core Tools...${NC}"

# Install VS Code (if not present)
echo -n "  Installing VS Code... "
if command -v code &> /dev/null; then
    echo -e "${GREEN}✅ Already installed${NC}"
else
    if [ "$OS" == "macos" ]; then
        brew install --cask visual-studio-code
    elif [ "$OS" == "linux" ]; then
        # Download and install .deb package
        wget -q https://go.microsoft.com/fwlink/?LinkID=760868 -O /tmp/code.deb
        sudo apt install -y /tmp/code.deb
        rm /tmp/code.deb
    fi
    echo -e "${GREEN}✅ Installed${NC}"
fi

# Install Tailscale
echo -n "  Installing Tailscale VPN... "
if command -v tailscale &> /dev/null; then
    echo -e "${GREEN}✅ Already installed${NC}"
else
    if [ "$OS" == "macos" ]; then
        brew install tailscale
        echo -e "${GREEN}✅ Installed${NC}"
        echo -e "${YELLOW}  ⚠️  You may need to approve Tailscale in System Settings → Privacy & Security${NC}"
    elif [ "$OS" == "linux" ]; then
        curl -fsSL https://tailscale.com/install.sh | sh
        echo -e "${GREEN}✅ Installed${NC}"
    fi
fi

# Install Happy-Coder
echo -n "  Installing Happy-Coder... "
if npm list -g happy-coder &> /dev/null; then
    echo -e "${GREEN}✅ Already installed${NC}"
else
    npm install -g happy-coder
    echo -e "${GREEN}✅ Installed${NC}"
fi

echo -e "\n${YELLOW}⚙️  Step 3/5: Configuring Services...${NC}"

# Configure VS Code Tunnel
echo -n "  Setting up VS Code Remote Tunnel... "
if code --version &> /dev/null; then
    # Install tunnel service
    code tunnel service install &> /dev/null || true
    echo -e "${GREEN}✅ Service installed${NC}"

    echo -e "\n  ${YELLOW}📝 You need to authenticate VS Code Tunnel:${NC}"
    echo -e "     ${CYAN}Run: code tunnel user login${NC}"
    echo -e "     ${CYAN}Then: code tunnel service start${NC}\n"
else
    echo -e "${YELLOW}⚠️  Manual setup needed${NC}"
fi

# Start Tailscale
echo -n "  Starting Tailscale... "
if [ "$OS" == "macos" ]; then
    # On macOS, Tailscale runs as a menu bar app
    open -a Tailscale &> /dev/null || true
    echo -e "${GREEN}✅ Starting...${NC}"
    echo -e "     ${YELLOW}Complete setup in the Tailscale menu bar app${NC}"
else
    # On Linux, start via command line
    sudo tailscale up &> /dev/null || true
    TAILSCALE_IP=$(tailscale ip -4 2>/dev/null || echo "Not connected yet")
    echo -e "${GREEN}✅ Connected${NC}"
    echo -e "     ${CYAN}Your Tailscale IP: $TAILSCALE_IP${NC}"
fi

echo -e "\n${YELLOW}🔐 Step 4/5: Configuring Wake-on-LAN...${NC}"

# Get MAC address
if [ "$OS" == "macos" ]; then
    MAC_ADDRESS=$(ifconfig en0 | awk '/ether/{print $2}')
elif [ "$OS" == "linux" ]; then
    # Get MAC of first active interface
    INTERFACE=$(ip route | grep default | awk '{print $5}' | head -n1)
    MAC_ADDRESS=$(ip link show $INTERFACE | awk '/link\/ether/ {print $2}')
fi

echo -e "  ${CYAN}Your MAC Address: $MAC_ADDRESS${NC}"
echo -e "  ${NC}Use this in your phone's Wake-on-LAN app${NC}\n"

# Enable Wake-on-LAN
echo -n "  Enabling Wake-on-LAN... "
if [ "$OS" == "macos" ]; then
    # Enable Wake for network access
    sudo systemsetup -setwakeonnetworkaccess on &> /dev/null || true
    echo -e "${GREEN}✅ Enabled${NC}"
elif [ "$OS" == "linux" ]; then
    # Try to enable WOL on main interface
    INTERFACE=$(ip route | grep default | awk '{print $5}' | head -n1)
    if command -v ethtool &> /dev/null; then
        sudo ethtool -s $INTERFACE wol g &> /dev/null || true
        echo -e "${GREEN}✅ Enabled${NC}"
    else
        echo -e "${YELLOW}⚠️  Manual setup needed${NC}"
        echo -e "     ${NC}Install ethtool: sudo apt install ethtool${NC}"
        echo -e "     ${NC}Then run: sudo ethtool -s $INTERFACE wol g${NC}"
    fi
fi

echo -e "\n${YELLOW}✅ Step 5/5: Creating Configuration Files...${NC}"

# Create config directory
CONFIG_DIR="$HOME/.connection"
mkdir -p "$CONFIG_DIR"

# Get Tailscale IP
if [ "$OS" == "macos" ]; then
    TAILSCALE_IP=$(tailscale ip -4 2>/dev/null || echo "")
else
    TAILSCALE_IP=$(tailscale ip -4 2>/dev/null || echo "")
fi

# Save configuration
cat > "$CONFIG_DIR/config.json" <<EOF
{
  "tailscaleIP": "$TAILSCALE_IP",
  "macAddress": "$MAC_ADDRESS",
  "setupDate": "$(date +%Y-%m-%d\ %H:%M:%S)",
  "os": "$OS"
}
EOF

echo -e "  ${GREEN}✅ Configuration saved to: $CONFIG_DIR/config.json${NC}"

echo -e "\n${CYAN}${'='*50}${NC}"
echo -e "${GREEN}🎉 Setup Complete!${NC}"
echo -e "${CYAN}${'='*50}${NC}\n"

echo -e "${YELLOW}📱 Next Steps:${NC}\n"

echo -e "${NC}1. Install phone apps:${NC}"
echo -e "   ${CYAN}• Tailscale VPN${NC}"
echo -e "   ${CYAN}• Happy-Coder${NC}"
echo -e "   ${CYAN}• Wake-on-LAN app (Mocha WOL for iOS, Wake On Lan for Android)${NC}\n"

echo -e "${NC}2. Configure VS Code Tunnel:${NC}"
echo -e "   ${CYAN}code tunnel user login${NC}"
echo -e "   ${CYAN}code tunnel service start${NC}\n"

echo -e "${NC}3. Start Happy-Coder server:${NC}"
echo -e "   ${CYAN}happy-coder start${NC}\n"

echo -e "${NC}4. Test from phone:${NC}"
echo -e "   ${CYAN}• Open vscode.dev → Connect to Tunnel${NC}"
echo -e "   ${CYAN}• Open Happy-Coder app → Connect${NC}"
if [ -n "$TAILSCALE_IP" ]; then
    echo -e "   ${CYAN}• Browser → http://$TAILSCALE_IP:3001${NC}\n"
else
    echo -e "   ${CYAN}• Browser → http://[tailscale-ip]:3001${NC}\n"
fi

echo -e "${YELLOW}📖 Full documentation: ./docs/SETUP.md${NC}\n"

echo -e "${GREEN}✨ Happy coding from anywhere! ✨${NC}\n"
