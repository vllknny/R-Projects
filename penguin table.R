# Palmer Penguins Regression Coefficient Table
# Purpose: Fit a linear regression model predicting body mass
# for Adelie penguins and create a clean coefficient summary table.

library(tidyverse)
library(palmerpenguins)
library(knitr)
library(kableExtra)

# -----------------------------
# 1. Load data
# -----------------------------

data("penguins")

# -----------------------------
# 2. Prepare Adelie dataset
# -----------------------------

adelie_penguins <- penguins |>
  filter(species == "Adelie") |>
  select(
    body_mass = body_mass_g,
    bill_len = bill_length_mm,
    bill_dep = bill_depth_mm,
    flipper_len = flipper_length_mm,
    sex,
    island
  ) |>
  drop_na()

# -----------------------------
# 3. Fit regression model
# -----------------------------

penguinModel <- lm(
  formula = body_mass ~ bill_len + bill_dep + flipper_len + sex + island,
  data = adelie_penguins
)

# -----------------------------
# 4. Extract coefficient table
# -----------------------------

coef_table <- summary(penguinModel)$coefficients |>
  as.data.frame() |>
  rownames_to_column("Term") |>
  rename(
    Estimate = Estimate,
    Std_Error = `Std. Error`,
    t_value = `t value`,
    p_value = `Pr(>|t|)`
  )

# -----------------------------
# 5. Display professional table
# -----------------------------

coef_table |>
  kable(
    caption = "Linear Regression Coefficients for Predicting Adelie Penguin Body Mass",
    digits = 3
  ) |>
  kable_styling(
    full_width = FALSE,
    bootstrap_options = c("striped", "hover", "condensed")
  )