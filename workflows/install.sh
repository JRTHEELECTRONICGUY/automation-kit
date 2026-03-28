#!/bin/bash
# JR The Electronic Guy - Automation Kit Install

echo "🎯 JR Electronics Automation Kit - Installing..."
echo "---------------------------------------------"

# Create directories
mkdir -p ~/.openclaw/agents/jr-workflows/
cp -r electronic-niche.yaml ~/.openclaw/agents/jr-workflows/
cp -r workflow-config.yaml ~/.openclaw/agents/jr-workflows/

echo "✅ JR automation system ready!"
echo "Run: openclaw run jr-electronics-setup"