library(googlesheets4)
library(tidyverse)
library(janitor)
library(rvest)

# ----------------------------------------------
# 1. Deauthorize Google Sheets
# ----------------------------------------------
gs4_deauth()

# ----------------------------------------------
# 2. Read the Armed Forces Google Sheet
# Use similar arguments as Galton family example
# ----------------------------------------------
url <- "https://docs.google.com/spreadsheets/d/19xQnI1cBh6Jkw7eP8YQuuicMlVDF7Gr-nXCb5qbwb_E/edit#gid=597536282"

raw <- read_sheet(
  ss = url,
  skip = 1,             # skip title row
  col_names = FALSE,    # we will construct column names manually
  col_types = "c"       # read all columns as character
)

# ----------------------------------------------
# 3. Build Column Names from Header Rows
# ----------------------------------------------
branch_row <- raw[1, ]
sex_row <- raw[2, ]

new_names <- map2_chr(branch_row, sex_row, ~{
  branch <- ifelse(is.na(.x) | .x == "", "remove", .x)
  sex <- ifelse(is.na(.y) | .y == "", "remove", .y)
  paste(branch, sex, sep = "_")
})

new_names <- make.names(new_names, unique = TRUE)
colnames(raw) <- new_names

# Remove temporary "remove" columns
data <- raw[, !str_detect(colnames(raw), "remove")]

# Remove header rows and clean names
data <- data[-c(1,2), ] |> clean_names()
colnames(data)[1] <- "pay_grade"

# ----------------------------------------------
# 4. Pivot to long format (grouped by branch/pay_grade/sex)
# ----------------------------------------------
long_data <- data |>
  pivot_longer(
    cols = -pay_grade,
    names_to = "branch_sex",
    values_to = "count"
  ) |>
  separate(branch_sex, into = c("branch", "sex"), sep = "_(?=[^_]+$)")

# ----------------------------------------------
# 5. Clean data: remove totals, convert count to numeric
# ----------------------------------------------
grouped_data <- long_data |>
  mutate(count = as.numeric(str_remove_all(count, "[,\\s]"))) |>
  filter(!is.na(count), count > 0) |>
  filter(sex != "total") |>
  filter(!pay_grade %in% c("Total Enlisted", "Total Warrant Officers", "Total Officers")) |>
  filter(!branch %in% c("pay_grade", "total")) |>
  mutate(branch = str_to_lower(str_replace_all(branch, " ", "_")))

# ----------------------------------------------
# 6. Expand to individual cases
# ----------------------------------------------
individuals <- grouped_data |> uncount(count)

# ----------------------------------------------
# 7. Scrape Ranks Lookup (example using rvest)
# ----------------------------------------------
rank_url <- "https://neilhatfield.github.io/Stat184_PayGradeRanks.html"
rank_tables <- read_html(rank_url) |> html_table(fill = TRUE)

# Example: take first table and clean it
rank_lookup <- rank_tables[[1]]
colnames(rank_lookup) <- c("pay_grade", "army", "navy", "marine_corps", "air_force", "space_force", "coast_guard")

rank_lookup_long <- rank_lookup |>
  pivot_longer(cols = -pay_grade, names_to = "branch", values_to = "rank") |>
  mutate(branch = str_to_lower(str_replace_all(branch, " ", "_"))) |>
  filter(!pay_grade %in% c("Pay Grade", "Note: -- indicates that a pay grade is not currently used by a service branch"))

# ----------------------------------------------
# 8. Join ranks to individuals
# ----------------------------------------------
final_tidy <- individuals |>
  left_join(rank_lookup_long, by = c("pay_grade", "branch")) |>
  select(branch, pay_grade, sex, rank) |>
  arrange(branch, pay_grade, sex)

# Check result
glimpse(final_tidy)