goodCutVals <- sapply(
vGoodCutVals <- sapply(
premiumCutVals <- sapply(
# The Diamonds Challenge ----
# Purpose: compute tidy summary statistics (x, y, z) grouped by `cut`.
# Improvements: remove installation from script, use robust filtering,
# produce a clean tidy table with consistent numeric columns.

library(tidyverse)
data("diamonds", package = "ggplot2")

# Keep only rows with positive x, y, z and the variables we need.
newDiamonds <- diamonds %>%
  filter(x > 0, y > 0, z > 0) %>%
  select(cut, x, y, z)

# Pivot longer then summarise — DRY and clear.
stat_table <- newDiamonds %>%
  pivot_longer(cols = c(x, y, z), names_to = "variable", values_to = "value") %>%
  group_by(cut, variable) %>%
  summarise(
    count = n(),
    Min = min(value),
    Q1 = quantile(value, 0.25, names = FALSE),
    Med = median(value),
    Mean = mean(value),
    Q3 = quantile(value, 0.75, names = FALSE),
    Max = max(value),
    MAD = mad(value),
    SD = sd(value),
    .groups = "drop"
  ) %>%
  arrange(cut, variable)

print(stat_table)

# Subset: only variable 'z'
stat_table_z <- stat_table %>%
  filter(variable == "z") %>%
  arrange(cut)

print("Z-only summary:")
print(stat_table_z)