#!/bin/bash
# JR Electronic Automation Kit - Universal Installer
# Built by John Readman - Barrie, Ontario, Canada

set -e

echo "🚀 JR Electronic Automation Kit - Universal Installer"
echo "================================================="
echo "Setting up complete business automation system..."

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Check if running as root
if [[ $EUID -eq 0 ]]; then
   echo -e "${RED}Error: Do not run this script as root${NC}"
   exit 1
fi

# Get home directory
HOME_DIR="$HOME"
WORKSPACE_DIR="$HOME_DIR/jr-automation"

# Create workspace
echo -e "${YELLOW}Creating workspace...${NC}"
mkdir -p "$WORKSPACE_DIR"
cd "$WORKSPACE_DIR"

# Clone repository
echo -e "${YELLOW}Downloading automation kit...${NC}"
if command -v git &> /dev/null; then
    git clone https://github.com/johnreadman/jr-electronic-automation-kit.git
    cd jr-electronic-automation-kit
else
    echo -e "${RED}Error: Git not found. Please install Git first.${NC}"
    echo "  Ubuntu/Debian: sudo apt install git"
    echo "  macOS: brew install git"
    echo "  Windows: Use the PowerShell installer instead"
    exit 1
fi

# System detection
if [[ "$OSTYPE" == "linux-gnu"* ]]; then
    OS="linux"
    DISTRO=$(lsb_release -si 2>/dev/null || echo "unknown")
elif [[ "$OSTYPE" == "darwin"* ]]; then
    OS="macos"
elif [[ "$OSTYPE" == "cygwin" ]] || [[ "$OSTYPE" == "msys" ]]; then
    OS="windows"
    echo -e "${RED}Error: Use PowerShell installer on Windows${NC}"
    echo "Run: iwr -useb https://raw.githubusercontent.com/johnreadman/jr-electronic-automation-kit/main/install.ps1 | iex"
    exit 1
else
    echo -e "${RED}Error: Unsupported operating system${NC}"
    exit 1
fi

# Install dependencies based on OS
echo -e "${YELLOW}Installing system dependencies...${NC}"
if [[ "$OS" == "linux" ]]; then
    if command -v apt &> /dev/null; then
        sudo apt update && sudo apt install -y python3 python3-pip python3-venv curl wget
        sudo apt install -y nodejs npm
    elif command -v yum &> /dev/null; then
        sudo yum update -y && sudo yum install -y python3 python3-pip curl wget
        curl -sL https://rpm.nodesource.com/setup_14.x | sudo bash -
        sudo yum install -y nodejs
    fi
elif [[ "$OS" == "macos" ]]; then
    if ! command -v brew &> /dev/null; then
        echo -e "${YELLOW}Installing Homebrew...${NC}"
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    fi
    brew install python3 node
fi

# Create Python virtual environment
echo -e "${YELLOW}Setting up Python environment...${NC}"
python3 -m venv venv
source venv/bin/activate

# Install Python dependencies
pip install --upgrade pip
pip install -r requirements.txt

# Install Node.js dependencies
if [[ -f package.json ]]; then
    echo -e "${YELLOW}Installing Node.js dependencies...${NC}"
    npm install
fi

# Setup directories
echo -e "${YELLOW}Creating system directories...${NC}"
mkdir -p config/{api-keys,logs,temp}
mkdir -p output/{reports,images,exports}
mkdir -p data/{accounts,leads,campaigns}

# Set permissions
chmod +x scripts/*.sh 2>/dev/null || true
chmod +x workflows/*.sh 2>/dev/null || true

# Create configuration file
echo -e "${YELLOW}Creating configuration...${NC}"
cat > config/system.json << EOF
{
  "version": "1.0.0",
  "owner": "John Readman",
  "location": "Barrie, Ontario, Canada",
  "contact": "support@jr-systems.com",
  "system": "jr-automation-kit",
  "setup_date": "$(date -u +%Y-%m-%dT%H:%M:%SZ)",
  "paths": {
    "workspace": "$WORKSPACE_DIR",
    "kit_path": "$WORKSPACE_DIR/jr-electronic-automation-kit",
    "venv_path": "$WORKSPACE_DIR/jr-electronic-automation-kit/venv",
    "config_path": "$WORKSPACE_DIR/jr-electronic-automation-kit/config"
  }
}
EOF

# Create environment file
cat > .env << EOF
JR_HOME=$WORKSPACE_DIR
JR_WORKSPACE=$WORKSPACE_DIR/jr-electronic-automation-kit
PYTHON_PATH=$WORKSPACE_DIR/jr-electronic-automation-kit/venv/bin/python

# API Keys (Add your keys here)
OPENAI_API_KEY=
GOOGLE_API_KEY=
DISCORD_BOT_TOKEN=
EMAIL_PROVIDER_API_KEY=

# Settings
DEBUG=false
LOG_LEVEL=info
SAVE_OUTPUTS=true
MAX_WORKERS=4
EOF

# Create installation success file
cat > .installed << EOF
JR Automation Kit v1.0.0
Installed on: $(date)
User: $(whoami)
OS: $OS
Path: $WORKSPACE_DIR
EOF

# Print success message
echo ""
echo -e "${GREEN}✅ Installation Complete!${NC}"
echo "================================"
echo ""
echo "JR Automation Kit is now ready at:"
echo "$WORKSPACE_DIR/jr-electronic-automation-kit"
echo ""
echo "Next steps:"
echo "1. cd $WORKSPACE_DIR/jr-electronic-automation-kit"
echo "2. source venv/bin/activate"
echo "3. ./jr-cli setup"
echo "4. ./jr-cli quickstart"
echo ""
echo "🔗 Repository: https://github.com/johnreadman/jr-electronic-automation-kit"
echo "💬 Discord: https://discord.gg/jr-systems"
echo "📧 Support: support@jr-systems.com"
echo ""
echo -e "${GREEN}You're now ready to start automating your income!${NC}"