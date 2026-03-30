#!/usr/bin/env python3
"""
Demo script showing conflict detection with club finder
"""

import sys
import os

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))

from simple_club_finder import SimplePSUClubFinder

def demo_conflicts():
    """Demonstrate conflict detection"""
    print("=== PSU Club Finder - Conflict Detection Demo ===\n")
    
    # Initialize finder
    finder = SimplePSUClubFinder()
    finder.clubs = finder.get_sample_club_data()
    
    # Create a schedule with conflicts
    conflicting_schedule = """
    Math Class: Wednesday 6:00 PM - 7:00 PM  # Conflicts with Coding Club
    Art Class: Tuesday 6:00 PM - 8:00 PM     # Conflicts with Dance Team
    History: Monday 5:00 PM - 6:30 PM         # Conflicts with Debate Society
    """
    
    print("Sample Class Schedule (with conflicts):")
    print(conflicting_schedule)
    
    finder.parse_manual_schedule(conflicting_schedule)
    available, conflicted = finder.find_available_clubs()
    
    print(f"\nRESULTS:")
    print(f"Total clubs: {len(finder.clubs)}")
    print(f"Available clubs: {len(available)}")
    print(f"Conflicted clubs: {len(conflicted)}")
    
    print(f"\nCLUBS YOU CAN JOIN (No Conflicts):")
    print("=" * 50)
    for i, club in enumerate(available, 1):
        print(f"{i}. {club['name']}")
        print(f"   Category: {club.get('category', 'N/A')}")
        print(f"   Meeting: {', '.join(club['meeting_times'])}")
        print()
    
    print(f"CLUBS WITH SCHEDULE CONFLICTS:")
    print("=" * 50)
    for i, club in enumerate(conflicted, 1):
        print(f"{i}. {club['name']} - CONFLICT!")
        print(f"   Category: {club.get('category', 'N/A')}")
        print(f"   Meeting: {', '.join(club['meeting_times'])}")
        print()
    
    # Save detailed results
    finder.save_results(available, conflicted, 'demo_results.csv')
    print("Detailed results saved to 'demo_results.csv'")

if __name__ == "__main__":
    demo_conflicts()