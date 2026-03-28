#!/usr/bin/env python3
"""
JR-Electronic Niche Hunter 🎯
AI-powered market research automation for passive income generation
Built by John Readman - Barrie, Ontario Canada
"""

import os
import json
import time
import requests
import pandas as pd
from datetime import datetime, timedelta
import openai
import googleapiclient.discovery
from serpapi import GoogleSearch
import sqlite3
import logging

class NicheHunter:
    """Advanced market research and analysis system"""
    
    def __init__(self, config_path="../config/config.json"):
        self.config = self.load_config(config_path)
        self.setup_logging()
        self.api_keys = self.config.get('api_keys', {})
        self.results_db = "../data/niche_data.db"
        self.init_database()
        
    def load_config(self, config_path):
        """Load API configuration"""
        try:
            with open(config_path, 'r') as f:
                return json.load(f)
        except FileNotFoundError:
            return self.get_default_config()
    
    def get_default_config(self):
        """Return minimal config for new users"""
        return {
            "api_keys": {
                "openai": os.getenv("OPENAI_API_KEY", ""),
                "serpapi": os.getenv("SERP_API_KEY", ""),
                "google": os.getenv("GOOGLE_API_KEY", "")
            },
            "niche_criteria": {
                "min_monthly_searches": 1000,
                "max_competition": "medium",
                "minimum_profit_potential": 500
            }
        }
    
    def setup_logging(self):
        """Configure logging for the system"""
        logging.basicConfig(
            level=logging.INFO,
            format='%(asctime)s - %(name)s - %(levelname)s - %(message)s',
            handlers=[
                logging.FileHandler('niche_hunter.log'),
                logging.StreamHandler()
            ]
        )
        self.logger = logging.getLogger('NicheHunter')
    
    def init_database(self):
        """Initialize SQLite database for storing niche data"""
        os.makedirs(os.path.dirname(self.results_db), exist_ok=True)
        conn = sqlite3.connect(self.results_db)
        cursor = conn.cursor()
        
        cursor.execute('''
            CREATE TABLE IF NOT EXISTS niches (
                id INTEGER PRIMARY KEY AUTOINCREMENT,
                keyword TEXT UNIQUE,
                monthly_searches INTEGER,
                competition_level TEXT,
                profit_potential INTEGER,
                market_size REAL,
                created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
            )
        ''')
        
        cursor.execute('''
            CREATE TABLE IF NOT EXISTS competitors (
                id INTEGER PRIMARY KEY AUTOINCREMENT,
                niche_id INTEGER,
                competitor_name TEXT,
                website TEXT,
                traffic_estimate INTEGER,
                revenue_estimate INTEGER,
                strengths TEXT,
                weaknesses TEXT,
                FOREIGN KEY (niche_id) REFERENCES niches(id)
            )
        ''')
        
        conn.commit()
        conn.close()
    
    def analyze_niche(self, keyword):
        """Complete niche analysis pipeline"""
        self.logger.info(f"Starting niche analysis for: {keyword}")
        
        # Get keyword data
        keyword_data = self.get_keyword_data(keyword)
        
        # Analyze competition
        competition_data = self.analyze_competition(keyword)
        
        # Calculate profit potential
        profit_estimate = self.calculate_profit_potential(keyword_data, competition_data)
        
        # Market size analysis
        market_size = self.estimate_market_size(keyword)
        
        # Generate recommendations
        recommendations = self.generate_recommendations(keyword_data, competition_data)
        
        result = {
            "keyword": keyword,
            "monthly_searches": keyword_data.get("search_volume", 0),
            "competition_level": competition_data.get("competition_level", "unknown"),
            "profit_potential": profit_estimate,
            "market_size": market_size,
            "score": self.calculate_score(keyword_data, competition_data),
            "recommendations": recommendations,
            "created_at": datetime.now().isoformat()
        }
        
        # Save to database
        self.save_niche_result(result)
        
        return result
    
    def get_keyword_data(self, keyword):
        """Get search volume and keyword data using multiple APIs"""
        try:
            # Using SerpAPI for Google Trends data
            params = {
                "engine": "google_trends",
                "q": keyword,
                "api_key": self.api_keys.get('serpapi')
            }
            
            search = GoogleSearch(params)
            results = search.get_dict()
            
            # Extract search volume (estimate)
            search_volume = self.estimate_search_volume(keyword)
            
            return {
                "search_volume": search_volume,
                "trend_data": results.get("interest_over_time", {}),
                "related_keywords": results.get("related_topics", [])
            }
            
        except Exception as e:
            self.logger.error(f"Error getting keyword data: {e}")
            return {"search_volume": 0, "trend_data": {}, "related_keywords": []}
    
    def estimate_search_volume(self, keyword):
        """Estimate monthly search volume"""
        # This is a simplified estimator - replace with actual API integration
        base_multiplier = {
            "affiliate marketing": 50000,
            "passive income": 25000,
            "dropshipping": 40000,
            "print on demand": 15000,
            "smm": 10000,
            "email marketing": 75000,
            "seo": 120000,
            "cryptocurrency": 200000
        }
        
        keyword_lower = keyword.lower()
        for base_term, volume in base_multiplier.items():
            if base_term in keyword_lower:
                return volume
        
        return 2000  # Default for new niches
    
    def analyze_competition(self, keyword):
        """Analyze competitive landscape"""
        # Get top competitors via Google Search
        competitors = self.get_competitors(keyword)
        
        # Analyze their strength
        competition_level = self.calculate_competition_level(competitors)
        
        return {
            "competitors": competitors,
            "competition_level": competition_level,
            "opportunity_score": self.calculate_opportunity_score(competitors)
        }
    
    def get_competitors(self, keyword):
        """Get top competing websites"""
        try:
            params = {
                "engine": "google",
                "q": keyword,
                "num": 10,
                "api_key": self.api_keys.get('serpapi')
            }
            
            search = GoogleSearch(params)
            results = search.get_dict()
            
            competitors = []
            for result in results.get("organic_results", [])[:5]:
                competitors.append({
                    "url": result.get("link", ""),
                    "title": result.get("title", ""),
                    "snippet": result.get("snippet", ""),
                    "position": result.get("position", 0)
                })
            
            return competitors
            
        except Exception as e:
            self.logger.error(f"Error getting competitors: {e}