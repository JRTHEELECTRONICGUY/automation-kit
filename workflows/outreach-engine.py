#!/usr/bin/env python3
"""
JR Electronic Automation Kit - Outreach Engine
Automated client acquisition and email outreach system
Built by John Readman - Barrie, Ontario, Canada
"""

import smtplib
import json
import csv
import sqlite3
import schedule
import time
from datetime import datetime, timedelta
from email.mime.text import MIMEText
from email.mime.multipart import MIMEMultipart
from typing import List, Dict
import openai
import os

class OutreachEngine:
    def __init__(self, api_key=None):
        openai.api_key = api_key or os.getenv("OPENAI_API_KEY")
        self.setup_database()
        self.templates = {}
        self.load_templates()

    def setup_database(self):
        """Create database for managing outreach campaigns"""
        self.conn = sqlite3.connect('data/leads.db')
        self.cursor = self.conn.cursor()
        
        self.cursor.execute('''
            CREATE TABLE IF NOT EXISTS leads (
                id INTEGER PRIMARY KEY AUTOINCREMENT,
                email TEXT UNIQUE,
                name TEXT,
                company TEXT,
