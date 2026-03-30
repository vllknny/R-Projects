#!/usr/bin/env python3
"""
Test script to demonstrate the club finder functionality
"""

import sys
import os

# Add the current directory to the path so we can import our modules
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))

from simple_club_finder import SimplePSUClubFinder

def test_club_finder():
    """Test the club finder with sample schedule"""
    print("=== Testing PSU Club Finder ===")
    
    # Initialize the finder
    finder = SimplePSUClubFinder()
    
    # Load sample club data
    finder.clubs = finder.get_sample_club_data()
    print(f"Loaded {len(finder.clubs)} clubs")
    
    # Add a sample class schedule
    sample_schedule = """
    Calculus: Monday 10:00 AM - 11:15 AM
    Physics Lab: Wednesday 2:30 PM - 4:30 PM
    English: Friday 9:00 AM - 10:00 AM
    """
    
    print("Parsing sample class schedule...")
    finder.parse_manual_schedule(sample_schedule)
    print(f"Parsed {len(finder.class_schedule)} classes")
    
    # Find available clubs
    available, conflicted = finder.find_available_clubs()
    
    print(f"\nResults:")
    print(f"   Total clubs: {len(finder.clubs)}")
    print(f"   Available: {len(available)}")
    print(f"   Conflicted: {len(conflicted)}")
    
    # Show available clubs
    print(f"\nAvailable Clubs:")
    for i, club in enumerate(available, 1):
        print(f"   {i}. {club['name']} ({club.get('category', 'N/A')})")
    
    # Show conflicted clubs
    print(f"\nConflicted Clubs:")
    for i, club in enumerate(conflicted, 1):
        print(f"   {i}. {club['name']} ({club.get('category', 'N/A')})")
    
    # Save results
    finder.save_results(available, conflicted, 'test_results.csv')
    print(f"\nResults saved to 'test_results.csv'")
    
    print(f"\nTest completed successfully!")

if __name__ == "__main__":
    test_club_finder()