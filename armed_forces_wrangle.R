library(tidyverse)
library(googlesheets4)
library(rvest)

# Read the Google Sheet data
url <- "https://docs.google.com/spreadsheets/d/19xQnI1cBh6Jkw7eP8YQuuicMlVDF7Gr-nXCb5qbwb_E/edit"

raw_data <- read_sheet(url, sheet = "Sheet1", skip = 2)

# Clean the data - keep only relevant rows (pay grade data, not totals)
data <- raw_data %>%
  filter(!is.na(`Pay Grade`), 
         !`Pay Grade` %in% c("Total Enlisted", "Total Warrant Officers", "Total Officers", "Total")) %>%
  rename(Pay_Grade = `Pay Grade`)

# Pivot to long format - create Branch and Sex from column names
# Column names are like: Army_Male, Army_Female, Army_Total, Navy_Male, etc.
tidy_data <- data %>%
  pivot_longer(
    cols = -Pay_Grade,
    names_to = c("Branch", "Sex"),
    names_pattern = "^(.+)_(Male|Female|Total)$",
    values_to = "Count",
    values_drop_na = TRUE
  ) %>%
  filter(Sex != "Total", Count > 0) %>%
  select(Pay_Grade, Branch, Sex, Count)

# Build rank lookup table based on scraped webpage data
# Data from: https://neilhatfield.github.io/Stat184_PayGradeRanks.html
rank_lookup <- tribble(
  ~Pay_Grade, ~Branch, ~Rank,
  # Enlisted - Army
  "E1", "Army", "Private",
  "E2", "Army", "Private",
  "E3", "Army", "Private First Class",
  "E4", "Army", "Corporal OR Specialist",
  "E5", "Army", "Sergeant",
  "E6", "Army", "Staff Sergeant",
  "E7", "Army", "Sergeant First Class",
  "E8", "Army", "First Sergeant OR Master Sergeant",
  "E9", "Army", "Sergeant Major OR Command Sergeant Major",
  # Enlisted - Navy
  "E1", "Navy", "Seaman Recruit",
  "E2", "Navy", "Seaman Apprentice",
  "E3", "Navy", "Seaman",
  "E4", "Navy", "Petty Officer Third Class",
  "E5", "Navy", "Petty Officer Second Class",
  "E6", "Navy", "Petty Officer First Class",
  "E7", "Navy", "Chief Petty Officer",
  "E8", "Navy", "Senior Chief Petty Officer",
  "E9", "Navy", "Master Chief Petty Officer",
  # Enlisted - Marine Corps
  "E1", "Marine Corps", "Private",
  "E2", "Marine Corps", "Private First Class",
  "E3", "Marine Corps", "Lance Corporal",
  "E4", "Marine Corps", "Corporal",
  "E5", "Marine Corps", "Sergeant",
  "E6", "Marine Corps", "Staff Sergeant",
  "E7", "Marine Corps", "Gunnery Sergeant",
  "E8", "Marine Corps", "First Sergeant OR Master Sergeant",
  "E9", "Marine Corps", "Sergeant Major OR Master Gunnery Sergeant",
  # Enlisted - Air Force
  "E1", "Air Force", "Airman Basic",
  "E2", "Air Force", "Airman",
  "E3", "Air Force", "Airman First Class",
  "E4", "Air Force", "Senior Airman",
  "E5", "Air Force", "Staff Sergeant",
  "E6", "Air Force", "Technical Sergeant",
  "E7", "Air Force", "Master Sergeant",
  "E8", "Air Force", "Senior Master Sergeant OR First Sergeant",
  "E9", "Air Force", "Chief Master Sergeant",
  # Enlisted - Space Force (uses unique ranks per webpage)
  "E1", "Space Force", "Specialist 1",
  "E2", "Space Force", "Specialist 2",
  "E3", "Space Force", "Specialist 3",
  "E4", "Space Force", "Specialist 4",
  "E5", "Space Force", "Sergeant",
  "E6", "Space Force", "Technical Sergeant",
  "E7", "Space Force", "Master Sergeant",
  "E8", "Space Force", "Senior Master Sergeant",
  "E9", "Space Force", "Chief Master Sergeant",
  # Warrant Officers - Army
  "W1", "Army", "Warrant Officer",
  "W2", "Army", "Chief Warrant Officer",
  "W3", "Army", "Chief Warrant Officer",
  "W4", "Army", "Chief Warrant Officer",
  "W5", "Army", "Chief Warrant Officer",
  # Warrant Officers - Navy
  "W1", "Navy", "Warrant Officer",
  "W2", "Navy", "Chief Warrant Officer",
  "W3", "Navy", "Chief Warrant Officer",
  "W4", "Navy", "Chief Warrant Officer",
  "W5", "Navy", "Chief Warrant Officer",
  # Warrant Officers - Marine Corps
  "W1", "Marine Corps", "Warrant Officer",
  "W2", "Marine Corps", "Chief Warrant Officer",
  "W3", "Marine Corps", "Chief Warrant Officer",
  "W4", "Marine Corps", "Chief Warrant Officer",
  "W5", "Marine Corps", "Chief Warrant Officer",
  # Warrant Officers - Air Force
  "W1", "Air Force", "Warrant Officer",
  "W2", "Air Force", "Chief Warrant Officer",
  "W3", "Air Force", "Chief Warrant Officer",
  "W4", "Air Force", "Chief Warrant Officer",
  "W5", "Air Force", "Chief Warrant Officer",
  # Commissioned Officers - Army
  "O1", "Army", "Second Lieutenant",
  "O2", "Army", "First Lieutenant",
  "O3", "Army", "Captain",
  "O4", "Army", "Major",
  "O5", "Army", "Lieutenant Colonel",
  "O6", "Army", "Colonel",
  "O7", "Army", "Brigadier General",
  "O8", "Army", "Major General",
  "O9", "Army", "Lieutenant General",
  "O10", "Army", "General",
  # Commissioned Officers - Navy
  "O1", "Navy", "Ensign",
  "O2", "Navy", "Lieutenant Junior Grade",
  "O3", "Navy", "Lieutenant",
  "O4", "Navy", "Lieutenant Commander",
  "O5", "Navy", "Commander",
  "O6", "Navy", "Captain",
  "O7", "Navy", "Rear Admiral (Lower)",
  "O8", "Navy", "Rear Admiral (Upper)",
  "O9", "Navy", "Vice Admiral",
  "O10", "Navy", "Admiral",
  # Commissioned Officers - Marine Corps
  "O1", "Marine Corps", "Second Lieutenant",
  "O2", "Marine Corps", "First Lieutenant",
  "O3", "Marine Corps", "Captain",
  "O4", "Marine Corps", "Major",
  "O5", "Marine Corps", "Lieutenant Colonel",
  "O6", "Marine Corps", "Colonel",
  "O7", "Marine Corps", "Brigadier General",
  "O8", "Marine Corps", "Major General",
  "O9", "Marine Corps", "Lieutenant General",
  "O10", "Marine Corps", "General",
  # Commissioned Officers - Air Force
  "O1", "Air Force", "Second Lieutenant",
  "O2", "Air Force", "First Lieutenant",
  "O3", "Air Force", "Captain",
  "O4", "Air Force", "Major",
  "O5", "Air Force", "Lieutenant Colonel",
  "O6", "Air Force", "Colonel",
  "O7", "Air Force", "Brigadier General",
  "O8", "Air Force", "Major General",
  "O9", "Air Force", "Lieutenant General",
  "O10", "Air Force", "General",
  # Commissioned Officers - Space Force
  "O1", "Space Force", "Second Lieutenant",
  "O2", "Space Force", "First Lieutenant",
  "O3", "Space Force", "Captain",
  "O4", "Space Force", "Major",
  "O5", "Space Force", "Lieutenant Colonel",
  "O6", "Space Force", "Colonel",
  "O7", "Space Force", "Brigadier General",
  "O8", "Space Force", "Major General",
  "O9", "Space Force", "Lieutenant General",
  "O10", "Space Force", "General"
)

# Join rank information to tidy data
final_data <- tidy_data %>%
  left_join(rank_lookup, by = c("Pay_Grade", "Branch")) %>%
  select(Branch, Pay_Grade, Rank, Sex, Count) %>%
  arrange(Branch, Pay_Grade, Sex)

# View the final tidy dataset
print(final_data)

# Save the tidy data to a CSV file
write_csv(final_data, "armed_forces_tidy.csv")
