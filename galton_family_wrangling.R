# Install and load required packages
# install.packages('googlesheets4')  # Run once if you don't have this package
library(googlesheets4)
library(tidyverse)

# GOAL: Tidy Galton family height data for analysis
# All height values are stored as deviations from 60 inches base measurement

# Step 1: Load raw dataset from Google Sheets
gs4_deauth()
galton_raw <- read_sheet(
  ss = 'https://docs.google.com/spreadsheets/d/1ZA83iqkojBVX0bvtXQ-wuCyR6oswZwJMORRb-VK2ktM/edit?usp=sharing'
)

# Step 2: Normalize parental heights by adding base measurement (60 inches)
family_data <- galton_raw |> 
  mutate(
    # Parse numeric value from Mother column (handles "about" prefix)
    Mother = parse_number(as.character(Mother)),
    # Normalize heights: stored values are deviations, add base measurement
    Father_height = Father + 60,
    Mother_height = Mother + 60
  )

# Step 3: Separate and convert sons into long format with normalized heights
sons_long <- family_data |> 
  select(family, Father_height, Mother_height, `Sons in order of height`) |>
  mutate(`Sons in order of height` = as.character(`Sons in order of height`)) |>
  separate_longer_delim(`Sons in order of height`, delim = ",") |>
  mutate(
    # Parse son height deviations to numeric and add base measurement
    child_height = parse_number(`Sons in order of height`) + 60,
    sex = "Son"
  ) |>
  filter(!is.na(child_height)) |>
  select(-`Sons in order of height`)

# Step 4: Separate and convert daughters into long format with normalized heights
daughters_long <- family_data |>
  select(family, Father_height, Mother_height, `Daughters in order of height`) |>
  mutate(`Daughters in order of height` = as.character(`Daughters in order of height`)) |>
  separate_longer_delim(`Daughters in order of height`, delim = ",") |>
  mutate(
    # Parse daughter height deviations to numeric and add base measurement
    child_height = parse_number(`Daughters in order of height`) + 60,
    sex = "Daughter"
  ) |>
  filter(!is.na(child_height)) |>
  select(-`Daughters in order of height`)

# Step 5 & 6: Combine sons and daughters into single tidy dataset
children_tidy <- bind_rows(sons_long, daughters_long) |>
  # Step 7: Assign sequential child number within each family-sex group
  group_by(family, sex) |>
  mutate(child_number = row_number()) |>
  ungroup() |>
  # Step 8: Select relevant columns for analysis
  select(family, sex, child_number, child_height, Father_height, Mother_height)

# View final tidy dataset
children_tidy


