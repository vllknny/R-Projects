# ===============================
# US Active Duty Armed Forces
# Frequency Tables by Gender
# Commissioned Officers Only
# ===============================

library(tidyverse)
library(janitor)
library(knitr)
library(kableExtra)
library(googlesheets4)

# -------------------------------
# 1. Import Google Sheet
# -------------------------------

url <- "https://docs.google.com/spreadsheets/d/19xQnI1cBh6Jkw7eP8YQuuicMlVDF7Gr-nXCb5qbwb_E/edit#gid=597536282"

military_raw <- read_sheet(url, col_names = TRUE)

# -------------------------------
# 2. Clean column names
# -------------------------------

military <- military_raw %>%
  clean_names() %>%
  rename(pay_grade = active_duty_personnel)

# -------------------------------
# 3. Remove header rows
# -------------------------------

military <- military %>%
  slice(-(1:2))

# -------------------------------
# 4. Convert wide data to long
# -------------------------------

military_long <- military %>%
  pivot_longer(
    cols = -pay_grade,
    names_to = "category",
    values_to = "count"
  )

# -------------------------------
# 5. Identify branch + gender
# -------------------------------

military_long <- military_long %>%
  mutate(
    branch = case_when(
      str_detect(category, "x2|x3|x4") ~ "Army",
      str_detect(category, "x5|x6|x7") ~ "Navy",
      str_detect(category, "x8|x9|x10") ~ "Marine Corps",
      str_detect(category, "x11|x12|x13") ~ "Air Force",
      str_detect(category, "x14|x15|x16") ~ "Space Force"
    ),
    gender = case_when(
      str_detect(category, "x2|x5|x8|x11|x14") ~ "Male",
      str_detect(category, "x3|x6|x9|x12|x15") ~ "Female",
      str_detect(category, "x4|x7|x10|x13|x16") ~ "Total"
    )
  )

# -------------------------------
# 6. Keep Commissioned Officers
# -------------------------------

officers <- military_long %>%
  filter(str_detect(pay_grade, "^O"))

# -------------------------------
# 7. Create Male Frequency Table
# -------------------------------

male_table <- officers %>%
  filter(gender == "Male") %>%
  select(pay_grade, branch, count) %>%
  pivot_wider(names_from = branch, values_from = count)

# -------------------------------
# 8. Create Female Frequency Table
# -------------------------------

female_table <- officers %>%
  filter(gender == "Female") %>%
  select(pay_grade, branch, count) %>%
  pivot_wider(names_from = branch, values_from = count)

# -------------------------------
# 9. Display Tables
# -------------------------------

male_table %>%
  kable(caption = "Male Commissioned Officers by Rank and Branch") %>%
  kable_styling(full_width = FALSE)

female_table %>%
  kable(caption = "Female Commissioned Officers by Rank and Branch") %>%
  kable_styling(full_width = FALSE)