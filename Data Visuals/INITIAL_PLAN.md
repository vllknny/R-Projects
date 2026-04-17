# Round Diamond Price Analysis - INITIAL PLAN

## Learning Objective
Understand how round cut diamond prices relate to carat weight, clarity, color, and cut quality through data visualization.

## Key Research Questions
1. How does price scale with carat weight for round diamonds?
2. Does clarity significantly impact the price-carat relationship?
3. Are there clear price premiums for different clarity grades?
4. What is the range of prices at each carat weight?

## Visualization Design Choices

### Chart Type: Scatter Plot with Color Encoding
**Why this approach?**
- Scatter plots excel at showing relationships between two continuous variables (carat vs price)
- Color encoding allows us to add a third dimension (clarity) without cluttering the plot
- Helps identify patterns, clusters, and outliers effectively

### Variables
- **X-axis (Carat)**: 0 to ~3.5 carats - shows the main predictor of price
- **Y-axis (Price)**: $300 to $20,000+ - the outcome we're explaining
- **Color (Clarity)**: I1, SI2, SI1, VS2, VS1, VVS2, VVS1, IF - visual grouping
- **Filter**: Only "Ideal" and "Premium" round cut diamonds to focus on quality cuts

### Expected Insights
- Exponential/non-linear relationship between carat and price
- Clarity grades should show visible separation in the scatter
- Higher clarity = generally higher price at same carat weight
- Increased variance in pricing at higher carat weights

## Aesthetic Considerations
- Clean theme with distinct color palette for clarity grades
- Legend positioned for easy reference
- Axis labels clearly identify units and scale
- Title conveys the main message

## Success Criteria for v1
✓ Successfully filters to round diamonds
✓ Shows clear price-carat relationship
✓ Clarity differences are visually apparent
✓ Free of overlapping/overplotting issues (or addressed with alpha/jitter)
✓ Includes proper labels, title, and legend
