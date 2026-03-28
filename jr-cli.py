#!/usr/bin/env python3
"""
JR Electronic Automation Kit CLI
The complete automation system for passive income - by John Readman
Barrie, Ontario, Canada
"""

import os
import sys
import json
import argparse
import subprocess
import platform
from pathlib import Path
from datetime import datetime

class JRAutomationKit:
    def __init__(self):
        self.version = "1.0.0"
        self.kit_path = Path(__file__).parent
        self.config_path = self.kit_path / "config"
        self.scripts_path = self.kit_path / "scripts"
        self.workflows_path = self.kit_path / "workflows"
        
        # Ensure directories exist
        self._ensure_directories()
    
    def _ensure_directories(self):
        """Create necessary directories if they don't exist"""
        dirs = [
            self.config_path,
            self.kit_path / "output" / "reports",
            self.kit_path / "output" / "images",
            self.kit_path / "data" / "leads",
            self.kit_path / "logs"
        ]
        
        for directory in dirs:
            directory.mkdir(parents=True, exist_ok=True)
    
    def print_banner(self):
        """Display JR Automation Kit banner"""
        banner = """
🚀 JR Electronic Automation Kit v1.0.0
========================================
Built by John Readman - Barrie, Ontario, Canada
Complete Passive Income Automation System
        """
        print(banner)
    
    def quickstart(self, level="beginner"):
        """Quick start automation for new users"""
        print("🎯 Starting quickstart automation...")
        
        if level == "beginner":
            self._beginner_setup()
        elif level == "agency":
            self._agency_setup()
        elif level == "authority":
            self._authority_setup()
        else:
            print(f"❌ Unknown level: {level}")
            return False
        
        print("✅ Quickstart complete!")
        return True
    
    def _beginner_setup(self):
        """Setup for complete beginners - generates $50-100/day"""
        print("📊 Setting up beginner automation...")
        
        # Run niche market research
        niche_workflows = [
            ("niche-hunter", ["research", "passive income", "beginner-friendly"]),
            ("outreach-engine", ["setup", "--template", "beginner"]),
            ("content-generator", ["batch", "--niche", "personal finance", "--count", "30"])
        ]
        
        for workflow, args in niche_workflows:
            print(f"🔄 Running {workflow}...")
            self._run_workflow(workflow, args)
        
        # Create starter campaigns
        self._create_campaign("beginner-automation", {
            "type": "affiliate",
            "niche": "personal finance",
            "target": 50,
            "scenarios": ["crypto-content", "passive-income", "money-tips"]
        })
    
    def _agency_setup(self):
        """Setup for agencies - handle multiple clients"""
        print("🏢 Setting up agency automation...")
        
        campaign = {
            "type": "flipped-agency",
            "clients": 5,
            "services": ["lead-gen", "content", "automation-setup"],
            "pricing": {"setup": 997, "monthly": 297}
        }
        self._create_campaign("agency-automation", campaign)
    
    def _authority_setup(self):
        """Setup for personal brand authority"""
        print("⭐ Setting up authority automation...")
        
        authority_campaign = {
            "platforms": ["twitter", "linkedin", "medium", "youtube"],
            "frequency": "daily",
            "expertise": "automation-and-systems",
            "goal": "thought-leadership"
        }
        self._create_campaign("authority-automation", authority_campaign)
    
    def _run_workflow(self, workflow, args):
        """Execute a specific workflow"""
        workflow_script = self.workflows_path / f"{workflow}.py"
        
        if workflow_script.exists():
            cmd = [sys.executable, str(workflow_script)] + args
            subprocess.run(cmd, cwd=str(self.kit_path))
        else:
            print(f"⚠️  Workflow {workflow} not found at {workflow_script}")
    
    def _create_campaign(self, name, config):
        """Create a new automation campaign"""
        campaign_path = self.kit_path / "config" / f"{name}.json"
        
        with open(campaign_path, 'w') as f:
            json.dump(config, f, indent=2)
        
        print(f"✅ Created campaign: {name}")
    
    def setup(self):
        """Interactive setup wizard"""
        print("⚙️  JR Automation Kit Setup Wizard")
        print("================================")
        
        # Check Python environment
        print("🔍 Checking Python environment...")
        if not self._check_python():
            return False
        
        # Install dependencies
        print("📦 Installing dependencies...")
        self._install_dependencies()
        
        # Create config files
        print("🔧 Creating configuration...")
        self._create_config()
        
        print("✅ Setup complete!")
        return True
    
    def _check_python(self):
        """Verify Python environment"""
        try:
            import openai
            import requests
            import bs4
            print("✅ Python dependencies ready")
            return True
        except ImportError as e:
            print(f"⚠️  Missing dependency: {e}")
            print("Run: pip install -r requirements.txt")
            return False
    
    def _install_dependencies(self):
        """Install required packages"""
        try:
            subprocess.run([sys.executable, "-m", "pip", "install", "-r", "requirements.txt"], 
                         cwd=str(self.kit_path), check=True)
        except subprocess.CalledProcessError:
            print("❌ Failed to install dependencies")
    
    def _create_config(self):
        """Create configuration files"""
        config_data = {
            "version": self.version,
            "kit_path": str(self.kit_path),
            "owner": "John Readman",
            "location": "Barrie, Ontario, Canada",
            "contact": "support@jr-systems.com"
        }
        
        config_file = self.config_path / "system.json"
        with open(config_file, 'w') as f:
            json.dump(config_data, f, indent=2)
    
    def status(self):
        """Display system status"""
        print("📊 JR Automation Kit Status")
        print("==========================")
        print(f"Version: {self.version}")
        print(f"Kit Path: {self.kit_path}")
        print(f"Python: {sys.version}")
        print(f"Platform: {platform.platform()}")
        
        # Check key components
        components = {
            "config": self.config_path.exists(),
            "workflows": self.workflows_path.exists(),
            "scripts": self.scripts_path.exists()
        }
        
        for component, exists in components.items():
            status = "✅" if exists else "❌"
            print(f"{status} {component.capitalize()}: {status}")
    
    def update(self):
        """Update the automation kit"""
        print("🔄 Updating JR Automation Kit...")
        
        if (self.kit_path / ".git").exists():
            subprocess.run(["git", "pull", "origin", "main"], cwd=str(self.kit_path))
            print("✅ Kit updated successfully!")
        else:
            print("⚠️  Could not update - not a git repository")
    
    def backup(self, action="create"):