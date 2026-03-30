# The Diamonds Width-by-Color Summary Table ----
# Purpose: produce a professional summary table for the Width (y)
# variable grouped by diamond Color.

library(tidyverse)
library(knitr)
library(kableExtra)

data("diamonds", package = "ggplot2")

# --------------------------------
# 1. Clean dataset
# --------------------------------

newDiamonds <- diamonds |>
  filter(y > 0) |>
  select(color, y)

# --------------------------------
# 2. Compute statistics by Color
# --------------------------------

stat_table <- newDiamonds |>
  group_by(color) |>
  summarise(
    Count = n(),
    Min = min(y),
    Q1_20 = quantile(y, 0.20, names = FALSE),
    Q2_40 = quantile(y, 0.40, names = FALSE),
    Median = median(y),
    Q3_60 = quantile(y, 0.60, names = FALSE),
    Q4_80 = quantile(y, 0.80, names = FALSE),
    Max = max(y),
    Mean = mean(y),
    SD = sd(y),
    .groups = "drop"
  ) |>
  arrange(color)

# --------------------------------
# 3. Create Professional Table
# --------------------------------

stat_table |>
  kable(
    caption = "Summary Statistics for Diamond Width (y) by Color",
    digits = 2
  ) |>
  kable_styling(
    full_width = FALSE,
    bootstrap_options = c("striped", "hover", "condensed")
  )