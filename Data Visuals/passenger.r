# ============================================================================
# Airport Passenger Traffic Analysis (2020-2025)
# ============================================================================
# Purpose: Compare passenger traffic across 6 major airports globally
# Data Source: Wikipedia - List of Busiest Airports by Passenger Traffic
# ============================================================================

# Load required libraries
library(tidyverse)
library(knitr)
library(kableExtra)  # For enhanced table formatting

# ============================================================================
# DATA ENTRY SECTION
# ============================================================================
# Instructions: Visit Wikipedia "List of Busiest Airports by Passenger Traffic"
# Enter passenger numbers (in millions) for each year below

# Create year vector
years <- c(2020, 2021, 2022, 2023, 2024, 2025)

# Create vectors with passenger traffic data for each airport
# Remove the NA placeholders and enter actual data from Wikipedia

# Required Airports
ATL <- c(42.9, 75.7, 93.7, 104.7, 108.1, 106.3)   # Hartsfield-Jackson Atlanta
FRA <- c(18.8, 24.8, 48.9, 59.4, 61.6, 63.2)      # Frankfurt Airport
PKX <- c(NA, 25.1, NA, NA, 49.4, 53.6)            # Beijing Daxing International

# Your three chosen airports - EDIT THESE SECTIONS
# Airport 1 (Code: DXB, Name: Dubai International)
DXB <- c(25.8, 29.1, 66.1, 87.0, 92.3, 95.2)

# Airport 2 (Code: HND, Name: Tokyo Haneda)
HND <- c(31.1, 25.9, 50.3, 78.7, 85.9, 91.4)

# Airport 3 (Code: LAX, Name: Los Angeles International)
LAX <- c(28.8, 48.0, 65.9, 75.1, 76.6, 73.7)

# ============================================================================
# DATA WRANGLING - Convert to tidy format
# ============================================================================

# Create a data frame with all airport data
airports_df <- data.frame(
  Year = years,
  ATL = ATL,
  FRA = FRA,
  PKX = PKX,
  DXB = DXB,
  HND = HND,
  LAX = LAX
)

# Convert from wide to long format for plotting
airports_long <- airports_df %>%
  pivot_longer(
    cols = -Year,
    names_to = "Airport",
    values_to = "Passengers"
  )

# Map airport codes to full names for better visualization
airport_names <- c(
  "ATL" = "Hartsfield-Jackson Atlanta",
  "FRA" = "Frankfurt",
  "PKX" = "Beijing Daxing",
  "DXB" = "Dubai International",
  "HND" = "Tokyo Haneda",
  "LAX" = "Los Angeles International"
)

airports_long <- airports_long %>%
  mutate(Airport_Full = airport_names[Airport])

# ============================================================================
# EXPLORATORY DATA ANALYSIS
# ============================================================================

# Examine the data structure
str(airports_df)
head(airports_long)
summary(airports_df)

# Check for missing values
missing_summary <- colSums(is.na(airports_df))
print(missing_summary)

# ============================================================================
# VISUALIZATION 1: COMPARISON TABLE
# ============================================================================

# Create summary table with all years plus summary statistics
table_data <- airports_df %>%
  mutate(
    Average = rowMeans(select(., -Year), na.rm = TRUE),
    Total = rowSums(select(., -Year), na.rm = TRUE)
  )

# Create a nicely formatted table
airport_table <- kable(table_data,
                       caption = "Annual Passenger Traffic (Millions) by Airport, 2020-2025",
                       col.names = c("Year", "ATL", "FRA", "PKX", 
                                    "DXB", "HND", "LAX",
                                    "Avg", "Total"),
                       digits = 1,
                       align = "c",
                       booktabs = TRUE) %>%
  kable_styling(bootstrap_options = c("striped", "hover"),
                full_width = TRUE,
                latex_options = "scale_down") %>%
  row_spec(0, bold = TRUE, background = "#3498db", color = "white") %>%
  column_spec(1, bold = TRUE)

print(airport_table)

# ============================================================================
# VISUALIZATION 2: MULTI-LINE PLOT
# ============================================================================

# Create line plot for passenger traffic trends
plot_data <- airports_long %>%
  filter(!is.na(Passengers))  # Remove missing values for plotting

# Define a professional color palette
colors <- c("ATL" = "#e74c3c",
            "FRA" = "#3498db", 
            "PKX" = "#f39c12",
            "DXB" = "#2ecc71",
            "HND" = "#9b59b6",
            "LAX" = "#1abc9c")

# Create the plot
ggplot(plot_data, aes(x = Year, y = Passengers, color = Airport, group = Airport)) +
  geom_line(size = 1) +
  geom_point(size = 3) +
  scale_color_manual(
    values = colors,
    labels = airport_names,
    name = "Airport"
  ) +
  scale_x_continuous(breaks = years) +
  labs(
    title = "Annual Passenger Traffic by Airport (2020-2025)",
    subtitle = "Comparison of six major global airports with post-pandemic recovery visible",
    x = "Year",
    y = "Passengers (Millions)",
    caption = "Source: Wikipedia - List of Busiest Airports by Passenger Traffic"
  ) +
  theme_minimal() +
  theme(
    plot.title = element_text(size = 14, face = "bold", margin = margin(b = 5)),
    plot.subtitle = element_text(size = 11, color = "gray40", margin = margin(b = 10)),
    legend.position = "right",
    panel.grid.major = element_line(color = "gray90"),
    panel.grid.minor = element_blank(),
    axis.text = element_text(size = 10),
    axis.title = element_text(size = 11, face = "bold")
  )

# Save the plot (optional)
# ggsave("passenger_traffic_plot.png", width = 12, height = 6, dpi = 300)

# ============================================================================
# SUMMARY STATISTICS AND INSIGHTS
# ============================================================================

# Calculate and display key metrics
summary_stats <- airports_long %>%
  filter(!is.na(Passengers)) %>%
  group_by(Airport) %>%
  summarize(
    Min_Year = years[which.min(Passengers)],
    Max_Year = years[which.max(Passengers)],
    Min_Passengers = min(Passengers, na.rm = TRUE),
    Max_Passengers = max(Passengers, na.rm = TRUE),
    Avg_Passengers = mean(Passengers, na.rm = TRUE),
    Growth_Rate = ((last(Passengers) - first(Passengers)) / first(Passengers) * 100)
  ) %>%
  arrange(desc(Avg_Passengers))

print("Summary Statistics by Airport:")
print(summary_stats)
