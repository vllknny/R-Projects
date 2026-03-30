# Penn State Club Finder Tool

A tool to help Penn State students find clubs that fit their class schedule by scraping discover.psu.edu and matching club meeting times with your Canvas calendar.

## Features

- 🎯 **Schedule Matching**: Automatically finds clubs that don't conflict with your class schedule
- 📅 **Canvas Integration**: Support for Canvas iCal subscription URLs (requires authentication setup)
- ✍️ **Manual Entry**: Easy manual schedule entry option
- 📊 **CSV Export**: Save results to CSV for easy reference
- 🏫 **PSU Specific**: Designed specifically for Penn State Discover platform

## Quick Start

### Option 1: Simple Version (Recommended)

The simple version uses sample data and doesn't require web scraping setup:

```bash
python simple_club_finder.py
```

### Option 2: Full Web Scraping Version

The full version requires additional setup:

1. **Install dependencies**:
   ```bash
   pip install -r requirements.txt
   ```

2. **Install ChromeDriver**:
   - Download ChromeDriver from https://chromedriver.chromium.org/
   - Place chromedriver.exe in the same folder as the script (Windows)
   - Or add it to your system PATH

3. **Run the tool**:
   ```bash
   python psu_club_finder.py
   ```

## Usage Instructions

### Running the Simple Version

1. Run the script: `python simple_club_finder.py`
2. Enter your class schedule when prompted, one class per line:
   ```
   Format: Class Name: Day Start Time - End Time
   Example: Calculus: Monday 10:00 AM - 11:15 AM
   ```
3. View the results showing available clubs
4. Check the `club_recommendations.csv` file for detailed results

### Example Schedule Input

```
Calculus: Monday 10:00 AM - 11:15 AM
Physics Lab: Wednesday 2:30 PM - 4:30 PM
English: Friday 9:00 AM - 10:00 AM
```

### Canvas iCal Setup (Advanced)

To use Canvas iCal URLs:

1. Go to your Canvas calendar
2. Click the "Calendar Feed" link
3. Copy the iCal URL (it will look something like: `https://psu.instructure.com/feeds/calendars/user...`)
4. Paste it when prompted by the tool

**Note**: Canvas iCal URLs require authentication and may not work directly without additional setup.

## Sample Output

```
=== Penn State Club Finder ===
This tool helps you find clubs that fit your class schedule.

Loading club database...
Loaded 8 clubs

Enter your class schedule...

=== Results ===
Total clubs: 8
Available clubs (no conflicts): 5
Conflicted clubs: 3

🎉 CLUBS AVAILABLE TO JOIN:
==================================================

1. Penn State Coding Club
   A club for students interested in programming and software development
   📅 Meeting: Wednesday 6:00 PM - 7:00 PM
   📧 Contact: codingclub@psu.edu
   🏷️  Category: Academic

2. Photography Club
   For students who love photography and want to improve their skills
   📅 Meeting: Tuesday 7:00 PM - 8:30 PM
   📧 Contact: photo@psu.edu
   🏷️  Category: Arts

💾 Detailed results saved to 'club_recommendations.csv'
```

## Features Explained

### Time Conflict Detection
- Matches days of the week
- Compares meeting times
- Handles multiple meeting times per club
- Flags potential conflicts

### Data Sources
- **Sample Data**: Pre-loaded with realistic PSU club examples
- **Web Scraping**: Attempts to scrape discover.psu.edu (full version)
- **Manual Input**: Easy schedule entry

### Output Formats
- **Console Display**: Immediate visual feedback
- **CSV Export**: Detailed spreadsheet with all information
- **Conflict Analysis**: Clear indication of what works and what doesn't

## Troubleshooting

### ChromeDriver Issues
- Make sure ChromeDriver version matches your Chrome browser version
- Try using `headless=False` in the script to see what's happening
- Check that ChromeDriver is in your PATH or in the same folder

### Access Issues
- Discover PSU may require authentication for full access
- Some data might be restricted to logged-in users
- The simple version bypasses these restrictions using sample data

### Time Parsing
- Use 12-hour format (AM/PM)
- Include the day of the week
- Separate class name from time with a colon

## Development Notes

### Architecture
- `simple_club_finder.py`: Easy-to-use version with sample data
- `psu_club_finder.py`: Full web scraping version (requires setup)
- `requirements.txt`: Python dependencies

### Web Scraping Challenges
- Discover PSU uses JavaScript and requires authentication
- Rate limiting may be applied
- Site structure may change requiring updates

### Future Improvements
- Direct Canvas API integration
- Mobile app interface
- Real-time schedule updates
- Club recommendation algorithm based on interests

## Requirements

### Simple Version
- Python 3.6+
- requests
- beautifulsoup4

### Full Version
- All simple version requirements
- selenium
- ChromeDriver
- Chrome browser

## License

This tool is for educational purposes. Please respect Penn State's terms of service and use responsibly.

## Support

If you encounter issues:
1. Try the simple version first
2. Check that all dependencies are installed
3. Verify your schedule format is correct
4. Make sure ChromeDriver is properly installed (for full version)