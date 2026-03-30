# ==============================================================================
# Pirate Data Visualization - 2015 Conference Analysis
# ==============================================================================

library(yarrr)
library(ggplot2)
library(gridExtra)
library(dplyr)

data(pirates)

# Custom theme for all plots
theme_pirate <- function() {
  theme_minimal() +
  theme(
    plot.title = element_text(face = "bold", size = 11),
    plot.subtitle = element_text(size = 9, color = "gray40"),
    axis.title = element_text(size = 10),
    legend.position = "none"
  )
}

# PLOT 1: Demographics - Density plots with mean lines
p1 <- ggplot(pirates, aes(x = age)) +
  geom_density(fill = "#8B4513", alpha = 0.6) +
  geom_vline(aes(xintercept = mean(age, na.rm = TRUE)), 
             color = "red", linetype = "dashed", linewidth = 1) +
  labs(
    title = "Age Distribution",
    x = "Age (years)", y = "Density",
    subtitle = sprintf("Mean: %.1f years", mean(pirates$age, na.rm = TRUE))
  ) +
  theme_pirate()

p2 <- ggplot(pirates, aes(x = height)) +
  geom_density(fill = "#DAA520", alpha = 0.6) +
  geom_vline(aes(xintercept = mean(height, na.rm = TRUE)), 
             color = "red", linetype = "dashed", linewidth = 1) +
  labs(title = "Height Distribution", x = "Height (cm)", y = "Density",
       subtitle = sprintf("Mean: %.1f cm", mean(pirates$height, na.rm = TRUE))) +
  theme_pirate()

p3 <- ggplot(pirates, aes(x = weight)) +
  geom_density(fill = "#CD853F", alpha = 0.6) +
  geom_vline(aes(xintercept = mean(weight, na.rm = TRUE)), 
             color = "red", linetype = "dashed", linewidth = 1) +
  labs(title = "Weight Distribution", x = "Weight (kg)", y = "Density",
       subtitle = sprintf("Mean: %.1f kg", mean(pirates$weight, na.rm = TRUE))) +
  theme_pirate()

# Display demographics distributions
grid.arrange(p1, p2, p3, ncol = 3)

# PLOT 2: Tattoos accumulation with age
p4 <- ggplot(pirates, aes(x = age, y = tattoos)) +
  geom_point(alpha = 0.4, size = 2, color = "#8B4513") +
  geom_smooth(method = "lm", color = "darkred", se = TRUE, alpha = 0.2, linewidth = 1) +
  labs(title = "Tattoos by Age",
       x = "Age (years)", y = "Number of Tattoos",
       subtitle = "Do career pirates accumulate more tattoos?") +
  theme_pirate()

print(p4)

# PLOT 3: Age distribution by pirate college (with sample sizes)
p5 <- ggplot(pirates, aes(x = reorder(college, age, FUN = median), y = age, fill = college)) +
  geom_violin(alpha = 0.7) +
  geom_boxplot(width = 0.15, alpha = 0.8, fill = "white") +
  labs(title = "Age by Pirate College",
       x = "College", y = "Age (years)",
       subtitle = "Violin plots show full distribution; box plots show quartiles") +
  theme_pirate() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1)) +
  stat_summary(fun = "mean", geom = "point", shape = 21, size = 3, 
               fill = "red", color = "darkred", alpha = 0.7)

print(p5)

# PLOT 4: Piracy involvement by college
piracy_by_college <- pirates %>%
  group_by(college) %>%
  summarise(
    piracy_rate = mean(piracy, na.rm = TRUE) * 100,
    n = n(),
    .groups = 'drop'
  )

p6 <- ggplot(piracy_by_college, aes(x = reorder(college, piracy_rate), y = piracy_rate, fill = college)) +
  geom_col(alpha = 0.7) +
  geom_text(aes(label = sprintf("n=%d", n)), vjust = -0.5, size = 3) +
  labs(title = "Active Piracy Rate by College",
       x = "College", y = "% Engaged in Piracy",
       subtitle = "Which pirate training colleges produce active pirates?") +
  theme_pirate() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1)) +
  ylim(0, max(piracy_by_college$piracy_rate) * 1.1)

print(p6)

# Summary statistics
cat("\n=== KEY FINDINGS ===\n")
cat("Dataset: 1,000 pirates attending 2015 international conference\n")
cat("Mean age:", round(mean(pirates$age, na.rm = TRUE), 1), "years\n")
cat("Active piracy rate:", 
    round(mean(pirates$piracy, na.rm = TRUE) * 100, 1), "%\n")
cat("Average tattoos:", round(mean(pirates$tattoos, na.rm = TRUE), 1), "\n")
