#!/bin/bash

# JR Electronic Automation Kit Setup Script
# Built by John Readman - Barrie, Ontario, Canada
# Complete passive income automation system setup

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

print_banner() {
    echo -e "${GREEN}"
    cat << "EOF"
🚀 JR Electronic Automation Kit Setup
=====================================
Built by John Readman - Barrie, Ontario, Canada
Complete Passive Income Automation System
EOF
    echo -e "${NC}"
}

check_requirements() {
    echo -e "${BLUE}🔍 Checking system requirements...${NC}"
    
    # Check Python version
    if command -v python3 &> /dev/null; then
        PYTHON_VERSION=$(python3 -c 'import sys; print("{}.{}.{}".format(sys.version_info[0], sys.version_info[1], sys.version_info[2]))')
        echo -e "${GREEN}✅ Python: $PYTHON_VERSION${NC}"
    else
        echo -e "${RED}❌ Python 3 not found. Please install Python 3.8+${NC}"
        exit 1
    fi
    
    # Check pip
    if ! command -v pip3 &> /dev/null; then
        echo -e "${RED}❌ pip3 not found. Please install pip3${NC}"
        exit 1
    fi
    
    # Check git
    if ! command -v git &> /dev/null; then
        echo -e "${YELLOW}⚠️  Git not found. Proceeding without git...${NC}"
    else
        echo -e "${GREEN}✅ Git found${NC}"
    fi
    
    echo -e "${GREEN}✅ System requirements met!${NC}"
}

install_dependencies() {
    echo -e "${BLUE}📦 Installing Python dependencies...${NC}"
    
    # Upgrade pip
    python3 -m pip install --upgrade pip
    
    # Install requirements
    if [[ -f "requirements.txt" ]]; then
        pip3 install -r requirements.txt
        echo -e "${GREEN}✅ Dependencies installed successfully!${NC}"
    else
        echo -e "${YELLOW}⚠️  requirements.txt not found, using pip install...${NC}"
        pip3 install openai asyncio-mqtt beautifulsoup4 click discord.py flask fastapi
    fi
}

setup_directories() {
    echo -e "${BLUE}📁 Setting up directory structure...${NC}"
    
    mkdir -p {config,output/{reports,images},data/{leads,campaigns,content},workflows,scripts,logs}
    
    echo -e "${GREEN}✅ Directory structure created!${NC}"
}

setup_config() {
    echo -e "${BLUE}⚙️  Setting up configuration...${NC}"
    
    # Create system config
    cat > config/system.json << EOF
{
  "version": "1.0.0",
  "owner": "John Readman",
  "location": "Barrie, Ontario, Canada",
  "contact": "support@jr-systems.com",
  "kit_path": "$(pwd)",
  "installed": "$(date -Iseconds)",
  "income_streams": [
    "affiliate_marketing",
    "digital_products",
    "consulting_leads",
    "saas_referrals",
    "course_sales"
  ]
}
EOF
    
    # Make CLI executable
    chmod +x jr-cli.py
    chmod +x jr-cli.js
    
    echo -e "${GREEN}✅ Configuration complete!${NC}"
}

setup_templates() {
    echo -e "${BLUE}📝 Setting up automation templates...${NC}"
    
    # Create workflow templates
    mkdir -p workflows
    
    # Niche hunter workflow
    cat > workflows/niche-hunter.py << 'EOF'
#!/usr/bin/env python3
"""Automated niche research workflow"""

import openai
import requests
from bs4 import BeautifulSoup
import json
import re

def research_niche(query, requirements):
    """Research profitable niches for automation"""
    # This would contain actual niche research logic
    return {"niche": query, "score": 85, "opportunities": 3}

if __name__ == "__main__":
    result = research_niche("passive income automation", ["beginner", "low-cost"])
    print(json.dumps(result, indent=2))
EOF
    
    # Outreach engine workflow
    cat > workflows/outreach-engine.py << 'EOF'
#!/usr/bin/env python3
"""Automated client outreach system"""

import smtplib
import json

def setup_outreach(campaign_type):
    """Setup client outreach campaign"""
    campaigns = {
        "beginner": {"templates": 3, "sequence_length": 7},
        "advanced": {"templates": 10, "sequence_length": 14},
        "agency": {"templates": 25, "sequence_length": 30}
    }
    return campaigns.get(campaign_type, campaigns["beginner"])

if __name__ == "__main__":
    import sys
    if len(sys.argv) > 1:
        result = setup_outreach(sys.argv[1])
        print(json.dumps(result, indent=2))
EOF
    
    chmod +x workflows/*.py
    
    echo -e "${GREEN}✅ Templates created!${NC}"
}

create_symlink() {
    echo -e "${BLUE}🔗 Creating command shortcut...${NC}"
    
    # Create global command
    if [[ "$OSTYPE" == "linux-gnu"* ]]; then
        sudo ln -sf "$(pwd)/jr-cli.py" /usr/local/bin/jr-cli
    elif [[ "$OSTYPE" == "darwin"* ]]; then
        sudo ln -sf "$(pwd)/jr-cli.py" /usr/local/bin/jr-cli
    fi
    
    echo -e "${GREEN}✅ Global command "jr-cli" created!${NC}"
}

print_startup_message() {
    echo -e "${GREEN}"
    cat << "EOF"
🎉 JR Electronic Automation Kit Ready!
==========================================

Quick Start Commands:
  jr-cli quickstart beginner    - Beginner automation ($50-100/day)
  jr-cli quickstart intermediate - Intermediate ($200-500/day)  
  jr-cli quickstart advanced    - Advanced ($1000+/day)
  jr-cli quickstart agency      - Agency setup (5+ clients)

Help & Documentation:
  jr-cli help              - Display help
  jr-cli setup            - Interactive setup wizard
  jr-cli status           - System status check

Visit: https://jr-systems.com
Join: discord.gg/jr-systems
Email: support@jr-systems.com

EOF
    echo -e "${NC}"
}

main() {
    print_banner
    check_requirements
    setup_directories
    install_dependencies
    setup_config
    setup_templates
    create_symlink
    print_startup_message
}

# Handle command line arguments
if [[ "$1" == "--quick" ]]; then
    echo -e "${BLUE}⚡ Fast setup mode...${NC}"
    check_requirements
    setup_directories
    setup_config
    print_startup_message
else
    main "$@"
fi