#!/usr/bin/env python3
"""
Penn State Club Finder Tool
Scrapes discover.psu.edu for club meeting times and finds available clubs based on class schedule
"""

import requests
from bs4 import BeautifulSoup
import selenium
from selenium import webdriver
from selenium.webdriver.common.by import By
from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.support import expected_conditions as EC
from selenium.webdriver.chrome.options import Options
from selenium.webdriver.chrome.service import Service
import time
import json
import csv
import re
from datetime import datetime, timedelta
import icalendar
from urllib.parse import urlparse, parse_qs
import os

class PSUClubFinder:
    def __init__(self, headless=True):
        self.base_url = "https://discover.psu.edu"
        self.organizations_url = "https://discover.psu.edu/organizations"
        self.driver = None
        self.headless = headless
        self.clubs = []
        self.class_schedule = []
        
    def setup_driver(self):
        """Setup Chrome WebDriver"""
        chrome_options = Options()
        if self.headless:
            chrome_options.add_argument("--headless")
        chrome_options.add_argument("--no-sandbox")
        chrome_options.add_argument("--disable-dev-shm-usage")
        chrome_options.add_argument("--disable-gpu")
        chrome_options.add_argument("--window-size=1920,1080")
        chrome_options.add_argument("--user-agent=Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36")
        
        try:
            self.driver = webdriver.Chrome(options=chrome_options)
            return True
        except Exception as e:
            print(f"Error setting up driver: {e}")
            return False
    
    def scrape_organizations(self):
        """Scrape all organizations from discover.psu.edu"""
        if not self.setup_driver():
            return False
            
        try:
            print("Loading organizations page...")
            self.driver.get(self.organizations_url)
            time.sleep(3)
            
            # Wait for the organizations to load
            WebDriverWait(self.driver, 10).until(
                EC.presence_of_element_located((By.CSS_SELECTOR, "[data-testid*='org'], .org-card, .organization"))
            )
            
            # Scroll to load all organizations
            last_height = self.driver.execute_script("return document.body.scrollHeight")
            while True:
                self.driver.execute_script("window.scrollTo(0, document.body.scrollHeight);")
                time.sleep(2)
                new_height = self.driver.execute_script("return document.body.scrollHeight")
                if new_height == last_height:
                    break
                last_height = new_height
                
                # Try to click "Load More" button if it exists
                try:
                    load_more_btn = self.driver.find_element(By.XPATH, "//button[contains(text(), 'Load More') or contains(@class, 'load-more')]")
                    load_more_btn.click()
                    time.sleep(2)
                except:
                    pass
            
            # Parse organization links
            soup = BeautifulSoup(self.driver.page_source, 'html.parser')
            org_links = []
            
            # Find organization links using multiple selectors
            selectors = [
                'a[href*="/organization/"]',
                '[data-testid*="org-link"]',
                '.organization-link a',
                '.org-card a'
            ]
            
            for selector in selectors:
                links = soup.select(selector)
                for link in links:
                    href = link.get('href')
                    if href and '/organization/' in href:
                        if href.startswith('/'):
                            href = self.base_url + href
                        if href not in org_links:
                            org_links.append(href)
            
            print(f"Found {len(org_links)} organization links")
            
            # Scrape each organization's details
            for i, org_url in enumerate(org_links[:50]):  # Limit to first 50 for testing
                print(f"Scraping organization {i+1}/{len(org_links[:50])}: {org_url}")
                club_info = self.scrape_organization_details(org_url)
                if club_info:
                    self.clubs.append(club_info)
                time.sleep(1)  # Rate limiting
            
            return True
            
        except Exception as e:
            print(f"Error scraping organizations: {e}")
            return False
        finally:
            if self.driver:
                self.driver.quit()
    
    def scrape_organization_details(self, org_url):
        """Scrape details from a single organization page"""
        try:
            self.driver.get(org_url)
            time.sleep(2)
            
            soup = BeautifulSoup(self.driver.page_source, 'html.parser')
            
            club_info = {
                'name': '',
                'description': '',
                'meeting_times': [],
                'contact_email': '',
                'website': org_url,
                'category': ''
            }
            
            # Extract name
            name_selectors = ['h1', '.org-name', '[data-testid*="org-name"]']
            for selector in name_selectors:
                name_elem = soup.select_one(selector)
                if name_elem:
                    club_info['name'] = name_elem.get_text().strip()
                    break
            
            # Extract description
            desc_selectors = ['.description', '.org-description', '[data-testid*="description"]']
            for selector in desc_selectors:
                desc_elem = soup.select_one(selector)
                if desc_elem:
                    club_info['description'] = desc_elem.get_text().strip()
                    break
            
            # Extract meeting times from text
            text_content = soup.get_text().lower()
            
            # Common meeting time patterns
            meeting_patterns = [
                r'(monday|tuesday|wednesday|thursday|friday|saturday|sunday)\s*(\d{1,2}:\d{2}\s*(am|pm))',
                r'(meets?|meetings?)\s*(on)?\s*(monday|tuesday|wednesday|thursday|friday|saturday|sunday)',
                r'(\d{1,2}:\d{2}\s*(am|pm))\s*(-|to|until)\s*(\d{1,2}:\d{2}\s*(am|pm))',
                r'weekly\s*(meeting|meet)',
            ]
            
            for pattern in meeting_patterns:
                matches = re.findall(pattern, text_content)
                if matches:
                    club_info['meeting_times'].extend(matches)
            
            # Extract contact email
            email_pattern = r'\b[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Z|a-z]{2,}\b'
            emails = re.findall(email_pattern, soup.get_text())
            if emails:
                club_info['contact_email'] = emails[0]
            
            return club_info if club_info['name'] else None
            
        except Exception as e:
            print(f"Error scraping {org_url}: {e}")
            return None
    
    def parse_canvas_ical(self, ical_url):
        """Parse Canvas iCal subscription URL to extract class schedule"""
        try:
            # For Canvas calendar URLs, we might need to authenticate or use a public URL
            # This is a simplified approach - in reality, Canvas iCal requires authentication
            response = requests.get(ical_url)
            response.raise_for_status()
            
            cal = icalendar.Calendar.from_ical(response.text)
            
            self.class_schedule = []
            for component in cal.walk():
                if component.name == "VEVENT":
                    event = {
                        'summary': str(component.get('summary', '')),
                        'start_time': component.get('dtstart').dt,
                        'end_time': component.get('dtend').dt,
                        'location': str(component.get('location', ''))
                    }
                    
                    # Only include class events (filter out non-class activities)
                    if any(keyword in event['summary'].lower() for keyword in ['class', 'lecture', 'lab', 'recitation']):
                        self.class_schedule.append(event)
            
            print(f"Parsed {len(self.class_schedule)} class events from Canvas calendar")
            return True
            
        except Exception as e:
            print(f"Error parsing Canvas iCal: {e}")
            print("Note: Canvas iCal URLs typically require authentication. You may need to download the .ics file manually.")
            return False
    
    def parse_manual_schedule(self, schedule_text):
        """Parse manually entered class schedule text"""
        lines = schedule_text.strip().split('\n')
        self.class_schedule = []
        
        for line in lines:
            if line.strip():
                # Expected format: "Class Name: Monday 10:00 AM - 11:00 AM"
                parts = line.split(':')
                if len(parts) >= 2:
                    class_name = parts[0].strip()
                    time_info = ':'.join(parts[1:]).strip()
                    
                    # Extract day and time information
                    day_pattern = r'(monday|tuesday|wednesday|thursday|friday|saturday|sunday)'
                    time_pattern = r'(\d{1,2}:\d{2}\s*(am|pm))\s*-\s*(\d{1,2}:\d{2}\s*(am|pm))'
                    
                    day_match = re.search(day_pattern, time_info, re.IGNORECASE)
                    time_match = re.search(time_pattern, time_info, re.IGNORECASE)
                    
                    if day_match and time_match:
                        event = {
                            'summary': class_name,
                            'day': day_match.group(1).lower(),
                            'start_time': time_match.group(1),
                            'end_time': time_match.group(3),
                            'location': ''
                        }
                        self.class_schedule.append(event)
        
        print(f"Parsed {len(self.class_schedule)} classes from manual schedule")
    
    def find_available_clubs(self):
        """Find clubs that don't conflict with class schedule"""
        available_clubs = []
        
        for club in self.clubs:
            if not club['meeting_times']:
                # If no meeting times specified, assume club is available
                available_clubs.append(club)
                continue
            
            conflicts = False
            for meeting in club['meeting_times']:
                if self.has_conflict(meeting):
                    conflicts = True
                    break
            
            if not conflicts:
                available_clubs.append(club)
        
        return available_clubs
    
    def has_conflict(self, meeting_time):
        """Check if a meeting time conflicts with class schedule"""
        # Simplified conflict checking - in a real implementation, this would be more sophisticated
        meeting_str = str(meeting_time).lower()
        
        for class_event in self.class_schedule:
            class_str = f"{class_event.get('summary', '')} {class_event.get('day', '')} {class_event.get('start_time', '')} {class_event.get('end_time', '')}".lower()
            
            # Check for day conflicts
            if 'day' in class_event and any(day in meeting_str for day in ['monday', 'tuesday', 'wednesday', 'thursday', 'friday']):
                if class_event['day'] in meeting_str:
                    return True
            
            # Check for time overlap (simplified)
            if 'start_time' in class_event:
                if class_event['start_time'].lower() in meeting_str:
                    return True
        
        return False
    
    def save_results(self, output_file='club_recommendations.csv'):
        """Save results to CSV file"""
        available_clubs = self.find_available_clubs()
        
        with open(output_file, 'w', newline='', encoding='utf-8') as csvfile:
            fieldnames = ['Club Name', 'Description', 'Meeting Times', 'Contact Email', 'Website']
            writer = csv.DictWriter(csvfile, fieldnames=fieldnames)
            
            writer.writeheader()
            for club in available_clubs:
                writer.writerow({
                    'Club Name': club['name'],
                    'Description': club['description'],
                    'Meeting Times': ', '.join(str(mt) for mt in club['meeting_times']),
                    'Contact Email': club['contact_email'],
                    'Website': club['website']
                })
        
        print(f"Results saved to {output_file}")
        return available_clubs
    
    def run_interactive(self):
        """Run the tool in interactive mode"""
        print("=== Penn State Club Finder ===")
        print("This tool helps you find clubs that fit your class schedule.\n")
        
        # Get schedule information
        print("How would you like to provide your class schedule?")
        print("1. Canvas iCal URL")
        print("2. Manual entry")
        
        choice = input("Enter choice (1 or 2): ").strip()
        
        if choice == "1":
            ical_url = input("Enter your Canvas iCal subscription URL: ").strip()
            if not self.parse_canvas_ical(ical_url):
                print("Failed to parse Canvas calendar. Please try manual entry.")
                choice = "2"
        
        if choice == "2":
            print("\nEnter your class schedule (one per line):")
            print("Format: Class Name: Day Start Time - End Time")
            print("Example: Calculus: Monday 10:00 AM - 11:15 AM")
            print("Enter an empty line when done:\n")
            
            schedule_lines = []
            while True:
                line = input("> ").strip()
                if not line:
                    break
                schedule_lines.append(line)
            
            schedule_text = '\n'.join(schedule_lines)
            self.parse_manual_schedule(schedule_text)
        
        # Scrape clubs
        print("\nScraping club information from discover.psu.edu...")
        if self.scrape_organizations():
            print(f"Found {len(self.clubs)} clubs")
            
            # Find available clubs
            available = self.find_available_clubs()
            print(f"\nFound {len(available)} clubs that don't conflict with your schedule:")
            
            for club in available[:10]:  # Show first 10
                print(f"\n• {club['name']}")
                if club['meeting_times']:
                    print(f"  Meeting times: {', '.join(str(mt) for mt in club['meeting_times'])}")
                if club['contact_email']:
                    print(f"  Contact: {club['contact_email']}")
            
            # Save results
            self.save_results()
        else:
            print("Failed to scrape club information.")


def main():
    finder = PSUClubFinder(headless=False)
    finder.run_interactive()


if __name__ == "__main__":
    main()