# Airport Passenger Traffic Analysis (2020-2025)

## Project Goal
Compare passenger traffic trends across six of the world's busiest airports over a 6-year period (2020-2025), identifying growth patterns and relative performance.

## Airports Selected
1. **Hartsfield-Jackson Atlanta International (ATL)** - USA
2. **Frankfurt Airport (FRA)** - Germany  
3. **Beijing Daxing International (PKX)** - China
4. **[Airport 4 - Your Choice]**
5. **[Airport 5 - Your Choice]**
6. **[Airport 6 - Your Choice]**

*Note: Choose from the Wikipedia List of Busiest Airports by Passenger Traffic*

## Data Requirements
- **Source**: Wikipedia - List of Busiest Airports by Passenger Traffic
- **Time Period**: 2020-2025 (6 years)
- **Key Variable**: Annual passenger traffic (in millions)
- **Format**: Tidy data with columns: Year, Airport Code, Airport Name, Passengers

## Research Questions
1. Which airport has the highest passenger volume in 2025?
2. How have passenger volumes recovered post-pandemic (2020-2021 effects)?
3. Which airports show the strongest growth trajectory?
4. How do the three required airports compare to our chosen peers?

## Visualization Strategy

### Visualization 1: Comparison Table
- **Type**: Formatted data table
- **Purpose**: Show precise passenger numbers for easy reference
- **Layout**: 
  - Rows: Airports
  - Columns: Years (2020-2025) + Total/Average
  - Highlight: Maximum values per year, growth rates

### Visualization 2: Multi-Line Plot
- **Type**: Line plot with multiple series
- **Purpose**: Show trends over time and compare growth patterns
- **Variables**:
  - X-axis: Year (2020-2025)
  - Y-axis: Passenger volume (millions)
  - Color/Lines: Airport (6 different colors)
- **Features**:
  - Clear legend identifying each airport
  - Grid lines for readability
  - Annotations for notable events (COVID-19 recovery)

## Data Preparation Steps
1. Create vectors for Years (2020-2025)
2. Enter passenger data for each airport from Wikipedia
3. Organize into a data frame (tidy format)
4. Calculate summary statistics (total, average, growth rate)
5. Check data types and missing values

## Expected Insights
- Visible dip in 2020-2021 due to pandemic travel restrictions
- Recovery trend from 2021-2025
- ATL likely maintains high volume across all years
- Regional and economic factors influencing growth rates
- Emerging airports (like PKX) may show different patterns

## Success Criteria
✓ Accurate data from Wikipedia
✓ Clean, well-structured data frame
✓ Table clearly shows passenger volumes with proper formatting
✓ Plot effectively shows trends and comparisons
✓ Both visualizations are publication-ready with proper labels
✓ Code is well-commented and organized
