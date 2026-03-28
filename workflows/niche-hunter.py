#!/usr/bin/env python3
"""
JR Electronic Automation Kit - Niche Hunter Workflow
Automated niche research for passive income opportunities
Built by John Readman - Barrie, Ontario, Canada
"""

import openai
import json
import requests
from bs4 import BeautifulSoup
import re
from datetime import datetime
import schedule
import time

class NicheHunter:
    def __init__(self, api_key):
        openai.api_key = api_key
        self.niches_file = "data/niches.json"
        self.score_threshold = 75
        
    def read_cat(file_path):
        """Read niches data from JSON file"""
        try:
            with open(file_path, 'r') as f:
                return json.load(f)
        except FileNotFoundError:
            return []

    def save_data(self, data, file_path):
        """Save data to JSON file"""
        with open(file_path, 'w') as f:
            json.dump(data, f, indent=2)

    def research_niche(self, keyword, requirements=None):
        """Research a specific niche for automation opportunities"""
        requirements = requirements or ["beginner", "low-cost", "passive-income"]
        
        prompt = f"""
        Research the niche "{keyword}" for automation and passive income opportunities.
        Requirements: {', '.join(requirements)}
        Provide a detailed analysis including:
        1. Market size (1-100)
        2. Competition level (1-10)
        3. Profit potential (1-100)
        4. Automation difficulty (1-10)
        5. 3 specific passive income methods
        6. Required monthly investment for success
        7. Time to first $100 (in days)
        8. Long-term annual potential
        Format as JSON with exact keys.
        """
        
        try:
            response = openai.ChatCompletion.create(
                model="gpt-3.5-turbo",
                messages=[
                    {"role": "user", "content": prompt}
                ],
                max_tokens=500
            )
            
            result = response