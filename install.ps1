# JR Electronic Automation Kit - Windows PowerShell Install
# Built by John Readman - Barrie, Ontario, Canada
# Complete passive income automation system setup

param(
    [switch]$Quick = $false
)

# Colors
$Green = "`e[32m"
$Yellow = "`e[33m"
$Red = "`e[31m"
$Blue = "`e[34m"
$NC = "`e[0m"

function Print-Banner {
    Write-Host "$Green"
    @"
🚀 JR Electronic Automation Kit Setup (Windows)
==============================================
Built by John Readman - Barrie, Ontario, Canada  
Complete Passive Income Automation System
"@
    Write-Host "$NC"
}

function Check-Requirements {
    Write-Host "$Blue🔍 Checking system requirements...$NC"
    
    # Check Python
    $pythonVersion = python --version 2>$null
    if ($LASTEXITCODE -eq 0) {
        Write-Host "$Green✅ Python Found: $pythonVersion$NC"
    } else {
        Write-Host "$Red❌ Python not found. Please install Python 3.8+ from python.org$NC"
        exit 1
    }

    # Check pip
    $pipVersion = pip --version 2>$null
    if ($LASTEXITCODE -eq 0) {
        Write-Host "$Green✅ Pip Found: $pipVersion$NC"
    } else {
        Write-Host "$Red❌ Pip not found. Please install pip$NC"
        exit 1
    }

    # Check Git (optional)
    $gitVersion = git --version 2>$null
    if ($LASTEXITCODE -eq 0) {
        Write-Host "$Green✅ Git Found: $gitVersion$NC"
    } else {
        Write-Host "$Yellow⚠️ Git not found. Proceeding anyway...$NC"
    }
}

function Install-Dependencies {
    Write-Host "$Blue📦 Installing dependencies...$NC"
    
    try {
        python -m pip install --upgrade pip
        if (Test-Path "requirements.txt") {
            python -m pip install -r requirements.txt
            Write-Host "$Green✅ Dependencies installed!$NC"
        } else {
            Write-Host "$Yellow⚠️ requirements.txt not found, installing key packages...$NC"
            python -m pip install openai requests click flask discord.py
        }
    } catch {
        Write-Host "$Red❌ Failed to install dependencies: $($_.Exception.Message)$NC"
        exit 1
    }
}

function Setup-Directories {
    Write-Host "$Blue📁 Setting up directory structure...$NC"
    
    $dirs = @(
        "config",
        "output\reports", 
        "output\images",
        "data\leads",
        "data\campaigns",
        "data\content",
        "workflows",
        "scripts",
        "logs"
    )

    foreach ($dir in $dirs) {
        if (-not (Test-Path $dir)) {
            New-Item -ItemType Directory -Force -Path $dir | Out-Null
        }
    }
    
    Write-Host "$Green✅ Directory structure created!$NC"
}

function Setup-Config {
    Write-Host "$Blue⚙️  Setting up configuration...$NC"
    
    # Create system config
    $config = @{
        version = "1.0.0"
        owner = "John Readman"
        location = "Barrie, Ontario, Canada"
        contact = "support@jr-systems.com"
        kit_path = $PWD.Path
        installed = (Get-Date).ToString("yyyy-MM-ddTHH:mm:ss.fffZ")
        income_streams = @("affiliate_marketing", "digital_products", "consulting_leads", "saas_referrals", "course_sales")
    }

    $config | ConvertTo-Json | Out-File "config\system.json" -Encoding UTF8
    
    Write-Host "$Green✅ Configuration saved!$NC"
}

function Setup-Templates {
    Write-Host "$Blue📝 Setting up automation templates...$NC"

    # Niche hunter workflow
    @'
import openai
import requests
from bs4 import BeautifulSoup

def research_niche(keyword, api_key):
    """Research profitable niches for automation"""
    openai.api_key = api_key
    
    response = openai.ChatCompletion.create(
        model="gpt-3.5-turbo",
        messages=[
            {"role": "user", "content": f"Research the niche '{keyword}' for automation opportunities"}
        ]
    )
    
    return response.choices[0].message.content

if __name__ == "__main__":
    import sys
    if len(sys.argv) > 2:
        result = research_niche(sys.argv[1], sys.argv[2])
        print(result)
'@ | Out-File "workflows\niche-hunter.py" -Encoding UTF8

    # Outreach engine workflow
    @'
import json

def setup_outreach(campaign_type, service_type):
    Templates = {
        "beginner": [
            "Automated affiliate marketing setup",
            "Passive income system deployment",
            "Online business automation"
        ],
        "agency": [
            "Client lead generation services", 
            "Marketing automation packages",
            "High-ticket client acquisition"
        ]
    }
    return {"type": campaign_type, "templates": Templates.get(campaign_type, [])}

if __name__ == "__main__":
    import sys
    if len(sys.argv) > 1:
        result = setup_outreach(sys.argv[1], sys.argv[2] if len(sys.argv) > 2 else "basic")
        print(json.dumps(result, indent=2))
'@ | Out-File "workflows\outreach-engine.py" -Encoding UTF8

    Write-Host "$Green✅ Templates created!$NC"
}

function Create-Alias {
    Write-Host "$Blue🔍 Creating command alias...$NC"
    
    # Add to PowerShell profile
    $profilePath = $PROFILE
    $aliasCommand = "Set-Alias -Name jr-cli -Value '$PWD\jr-cli.py'"
    
    if (-not (Test-Path $profilePath)) {
        New-Item -ItemType File -Path $profilePath -Force
    }
    
    if (-not (Select-String -Path $profilePath -Pattern "jr-cli" -Quiet)) {
        Add-Content -Path $profilePath -Value $aliasCommand
    }
    
    Write-Host "$Green✅ 'jr-cli' alias created! Restart PowerShell to use.$NC"
}

function Print-Startup {
    Write-Host "$Green"
    @"

🎉 JR Electronic Automation Kit Ready!
==========================================

Quick Start Commands:
  python jr-cli.py quickstart beginner    - Beginner automation ($50-100/day)
  python jr-cli.py quickstart intermediate - Intermediate ($200-500/day)  
  python jr-cli.py quickstart advanced    - Advanced ($1000+/day)
  python jr-cli.py quickstart agency      - Agency setup (5+ clients)

Or use the Python script directly:
  python jr-cli.py setup                - Interactive setup wizard
  python jr-cli.py status               - System status check

Visit: https://jr-systems.com
Join: discord.gg/jr-systems
Email: support@jr-systems.com

"@
    Write-Host "$NC"
}

# Main setup
Print-Banner
Check-Requirements
Setup-Directories
Install-Dependencies
Setup-Config
Setup-Templates

if (-not $Quick) {
    Create-Alias
}

Print-Startup