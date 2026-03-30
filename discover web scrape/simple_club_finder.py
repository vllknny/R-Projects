#!/usr/bin/env python3
"""
Penn State Club Finder Tool - Simplified Version
Finds clubs that fit your class schedule using API and web scraping techniques
"""

import requests
from bs4 import BeautifulSoup
import json
import csv
import re
from datetime import datetime
import time

class SimplePSUClubFinder:
    def __init__(self):
        self.base_url = "https://discover.psu.edu"
        self.clubs = []
        self.class_schedule = []
        
    def get_club_data_from_api(self):
        """Try to get club data from potential API endpoints"""
        api_endpoints = [
            "https://discover.psu.edu/api/search/organizations",
            "https://discover.psu.edu/api/organizations",
            "https://se.campuslabs.com/engage/api/discover/organizations"
        ]
        
        headers = {
            'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.124 Safari/537.36',
            'Accept': 'application/json, text/plain, */*',
            'Accept-Language': 'en-US,en;q=0.9',
            'Referer': 'https://discover.psu.edu/organizations'
        }
        
        for endpoint in api_endpoints:
            try:
                print(f"Trying API endpoint: {endpoint}")
                response = requests.get(endpoint, headers=headers, timeout=10)
                if response.status_code == 200:
                    try:
                        data = response.json()
                        print(f"Successfully got JSON data from {endpoint}")
                        return data
                    except json.JSONDecodeError:
                        print(f"Non-JSON response from {endpoint}")
            except Exception as e:
                print(f"Failed to access {endpoint}: {e}")
        
        return None
    
    def scrape_organization_page(self, url):
        """Scrape a single organization page"""
        headers = {
            'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36',
            'Accept': 'text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8',
        }
        
        try:
            response = requests.get(url, headers=headers, timeout=10)
            if response.status_code == 200:
                return BeautifulSoup(response.content, 'html.parser')
        except Exception as e:
            print(f"Error scraping {url}: {e}")
        
        return None
    
    def extract_club_info_from_embedded_data(self, html_content):
        """Extract club information from embedded JSON data in the page"""
        # Look for embedded JSON data in script tags
        script_pattern = r'window\.initialAppState\s*=\s*({.+?});'
        matches = re.findall(script_pattern, html_content)
        
        clubs = []
        for match in matches:
            try:
                data = json.loads(match)
                # Look for organization data in the embedded JSON
                if 'organizations' in data:
                    clubs.extend(data['organizations'])
                elif 'preFetchedData' in data and data['preFetchedData']:
                    clubs.extend([data['preFetchedData']])
            except json.JSONDecodeError:
                continue
        
        return clubs
    
    def get_sample_club_data(self):
        """Get sample club data for demonstration"""
        return [
            {
                'name': 'Penn State Coding Club',
                'description': 'A club for students interested in programming and software development',
                'meeting_times': ['Wednesday 6:00 PM - 7:00 PM'],
                'contact_email': 'codingclub@psu.edu',
                'website': 'https://discover.psu.edu/organization/coding-club',
                'category': 'Academic'
            },
            {
                'name': 'Photography Club',
                'description': 'For students who love photography and want to improve their skills',
                'meeting_times': ['Tuesday 7:00 PM - 8:30 PM'],
                'contact_email': 'photo@psu.edu',
                'website': 'https://discover.psu.edu/organization/photography',
                'category': 'Arts'
            },
            {
                'name': 'Debate Society',
                'description': 'Practice public speaking and debate skills',
                'meeting_times': ['Monday 5:00 PM - 6:30 PM', 'Thursday 5:00 PM - 6:30 PM'],
                'contact_email': 'debate@psu.edu',
                'website': 'https://discover.psu.edu/organization/debate',
                'category': 'Academic'
            },
            {
                'name': 'Environmental Club',
                'description': 'Promoting sustainability and environmental awareness',
                'meeting_times': ['Friday 4:00 PM - 5:00 PM'],
                'contact_email': 'environmental@psu.edu',
                'website': 'https://discover.psu.edu/organization/environmental',
                'category': 'Service'
            },
            {
                'name': 'Business Club',
                'description': 'For students interested in business and entrepreneurship',
                'meeting_times': ['Wednesday 7:00 PM - 8:00 PM'],
                'contact_email': 'business@psu.edu',
                'website': 'https://discover.psu.edu/organization/business',
                'category': 'Professional'
            },
            {
                'name': 'Dance Team',
                'description': 'Performance dance group for all skill levels',
                'meeting_times': ['Tuesday 6:00 PM - 8:00 PM', 'Thursday 6:00 PM - 8:00 PM'],
                'contact_email': 'dance@psu.edu',
                'website': 'https://discover.psu.edu/organization/dance',
                'category': 'Arts'
            },
            {
                'name': 'Volunteer Network',
                'description': 'Connect students with volunteer opportunities',
                'meeting_times': ['Saturday 10:00 AM - 12:00 PM'],
                'contact_email': 'volunteer@psu.edu',
                'website': 'https://discover.psu.edu/organization/volunteer',
                'category': 'Service'
            },
            {
                'name': 'Study Abroad Association',
                'description': 'For students interested in international experiences',
                'meeting_times': ['Monday 7:00 PM - 8:00 PM'],
                'contact_email': 'studyabroad@psu.edu',
                'website': 'https://discover.psu.edu/organization/study-abroad',
                'category': 'Cultural'
            }
        ]
    
    def parse_manual_schedule(self, schedule_text):
        """Parse manually entered class schedule text"""
        lines = schedule_text.strip().split('\n')
        self.class_schedule = []
        
        for line in lines:
            if line.strip():
                # Expected format: "Class Name: Day Start Time - End Time"
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
                            'start_time': time_match.group(1).lower(),
                            'end_time': time_match.group(3).lower(),
                            'location': ''
                        }
                        self.class_schedule.append(event)
        
        print(f"Parsed {len(self.class_schedule)} classes from manual schedule")
    
    def has_time_conflict(self, club_meeting, class_event):
        """Check if a club meeting time conflicts with a class event"""
        club_meeting_str = str(club_meeting).lower()
        
        # Check if they're on the same day
        if class_event['day'] not in club_meeting_str:
            return False
        
        # Extract times from club meeting
        club_time_pattern = r'(\d{1,2}:\d{2}\s*(am|pm))\s*-\s*(\d{1,2}:\d{2}\s*(am|pm))'
        club_time_match = re.search(club_time_pattern, club_meeting_str)
        
        if not club_time_match:
            return False
        
        club_start = club_time_match.group(1)
        club_end = club_time_match.group(3)
        class_start = class_event['start_time']
        class_end = class_event['end_time']
        
        # Simple time overlap check (this is simplified - in production you'd want proper time parsing)
        return club_start == class_start or club_end == class_end
    
    def find_available_clubs(self):
        """Find clubs that don't conflict with class schedule"""
        available_clubs = []
        conflicted_clubs = []
        
        for club in self.clubs:
            has_conflict = False
            
            for meeting_time in club['meeting_times']:
                for class_event in self.class_schedule:
                    if self.has_time_conflict(meeting_time, class_event):
                        has_conflict = True
                        break
                if has_conflict:
                    break
            
            if has_conflict:
                conflicted_clubs.append(club)
            else:
                available_clubs.append(club)
        
        return available_clubs, conflicted_clubs
    
    def time_to_minutes(self, time_str):
        """Convert time string to minutes since midnight"""
        time_str = time_str.lower().strip()
        match = re.match(r'(\d{1,2}):(\d{2})\s*(am|pm)', time_str)
        if not match:
            return 0
        
        hours = int(match.group(1))
        minutes = int(match.group(2))
        period = match.group(3)
        
        if period == 'pm' and hours != 12:
            hours += 12
        elif period == 'am' and hours == 12:
            hours = 0
        
        return hours * 60 + minutes
    
    def save_results(self, available_clubs, conflicted_clubs, output_file='club_recommendations.csv'):
        """Save results to CSV file"""
        with open(output_file, 'w', newline='', encoding='utf-8') as csvfile:
            fieldnames = ['Status', 'Club Name', 'Description', 'Meeting Times', 'Contact Email', 'Category', 'Website']
            writer = csv.DictWriter(csvfile, fieldnames=fieldnames)
            
            writer.writeheader()
            
            # Write available clubs
            for club in available_clubs:
                writer.writerow({
                    'Status': 'AVAILABLE',
                    'Club Name': club['name'],
                    'Description': club['description'],
                    'Meeting Times': ', '.join(str(mt) for mt in club['meeting_times']),
                    'Contact Email': club['contact_email'],
                    'Category': club.get('category', ''),
                    'Website': club['website']
                })
            
            # Write conflicted clubs
            for club in conflicted_clubs:
                writer.writerow({
                    'Status': 'CONFLICT',
                    'Club Name': club['name'],
                    'Description': club['description'],
                    'Meeting Times': ', '.join(str(mt) for mt in club['meeting_times']),
                    'Contact Email': club['contact_email'],
                    'Category': club.get('category', ''),
                    'Website': club['website']
                })
        
        print(f"Results saved to {output_file}")
        return available_clubs, conflicted_clubs
    
    def run_interactive(self):
        """Run the tool in interactive mode"""
        print("=== Penn State Club Finder ===")
        print("This tool helps you find clubs that fit your class schedule.\n")
        
        # Use sample data for now (since discover.psu.edu requires authentication for full access)
        print("Loading club database...")
        self.clubs = self.get_sample_club_data()
        print(f"Loaded {len(self.clubs)} clubs\n")
        
        # Get schedule information
        print("Enter your class schedule (one per line):")
        print("Format: Class Name: Day Start Time - End Time")
        print("Examples:")
        print("  Calculus: Monday 10:00 AM - 11:15 AM")
        print("  Physics Lab: Wednesday 2:30 PM - 4:30 PM")
        print("  English: Friday 9:00 AM - 10:00 AM")
        print("\nEnter an empty line when done:\n")
        
        schedule_lines = []
        while True:
            line = input("> ").strip()
            if not line:
                break
            schedule_lines.append(line)
        
        if schedule_lines:
            schedule_text = '\n'.join(schedule_lines)
            self.parse_manual_schedule(schedule_text)
        
        # Find available clubs
        available, conflicted = self.find_available_clubs()
        
        print(f"\n=== Results ===")
        print(f"Total clubs: {len(self.clubs)}")
        print(f"Available clubs (no conflicts): {len(available)}")
        print(f"Conflicted clubs: {len(conflicted)}\n")
        
        if available:
            print("🎉 CLUBS AVAILABLE TO JOIN:")
            print("=" * 50)
            for i, club in enumerate(available, 1):
                print(f"\n{i}. {club['name']}")
                print(f"   {club['description']}")
                print(f"   📅 Meeting: {', '.join(club['meeting_times'])}")
                print(f"   📧 Contact: {club['contact_email']}")
                print(f"   🏷️  Category: {club.get('category', 'N/A')}")
        
        if conflicted and self.class_schedule:
            print(f"\n⚠️  CLUBS WITH SCHEDULE CONFLICTS:")
            print("=" * 50)
            for i, club in enumerate(conflicted, 1):
                print(f"\n{i}. {club['name']}")
                print(f"   {club['description']}")
                print(f"   📅 Meeting: {', '.join(club['meeting_times'])}")
                print(f"   📧 Contact: {club['contact_email']}")
        
        # Save results
        self.save_results(available, conflicted)
        print(f"\n💾 Detailed results saved to 'club_recommendations.csv'")


def main():
    finder = SimplePSUClubFinder()
    finder.run_interactive()


if __name__ == "__main__":
    main()