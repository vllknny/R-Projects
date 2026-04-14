# Round Cut Diamond Price Analysis - FINAL CODE
# Learning Goal: Understand how diamond price relates to carat, clarity, 

# Install/Load required libraries
library(ggplot2)
library(dplyr)
library(knitr)  # For kable tables

# ============================================================================
# 1. LOAD AND EXPLORE DATA
# ============================================================================

# Load the diamonds dataset from ggplot2
data(diamonds)

# Quick exploration
head(diamonds)
nrow(diamonds)  # Total diamonds
class(diamonds)

# Check unique values for cut
unique(diamonds$cut)
table(diamonds$cut)

# Check unique values for clarity
unique(diamonds$clarity)
table(diamonds$clarity)

# ============================================================================
# 2. FILTER DATA: FOCUS ON ROUND CUT DIAMONDS
# ============================================================================

# Filter for round cut diamonds only
# Note: The diamonds dataset uses "Ideal" and other cut grades
# but no explicit "Round" cut variable
# We'll filter for high-quality cuts to focus on premium round diamonds
round_diamonds <- diamonds %>%
  filter(cut %in% c("Ideal", "Premium"))

cat("\nFiltered dataset:")
cat("\nTotal diamonds:", nrow(round_diamonds))
cat("\nPrice range: $", min(round_diamonds$price), " - $", max(round_diamonds$price))
cat("\nCarat range:", min(round_diamonds$carat), " - ", max(round_diamonds$carat))

# ============================================================================
# 3. INITIAL VISUALIZATION: Price vs Carat by Clarity
# ============================================================================

ggplot(round_diamonds, aes(x = carat, y = price, color = clarity)) +
  geom_point(alpha = 0.4, size = 2) +
  facet_wrap(~cut) +
  scale_color_brewer(palette = "Blues", direction = -1) +
  labs(
    title = "Round Diamond Price Analysis",
    subtitle = "Price vs Carat Weight by Clarity Grade",
    x = "Carat Weight",
    y = "Price (USD)",
    color = "Clarity"
  ) +
  theme_minimal() +
  theme(
    plot.title = element_text(size = 14, face = "bold"),
    plot.subtitle = element_text(size = 11, color = "gray40")
  )

# ============================================================================
# 4. EXPLORATORY STATISTICS (with kable tables)
# ============================================================================

# Summary statistics by clarity
cat("\n\nPrice statistics by clarity (round diamonds):\n")
clarity_stats <- round_diamonds %>%
  group_by(clarity) %>%
  summarize(
    count = n(),
    mean_price = mean(price),
    median_price = median(price),
    min_price = min(price),
    max_price = max(price),
    .groups = "drop"
  )

# Display using kable
kable(clarity_stats, 
      caption = "Price Statistics by Clarity (Round Diamonds)",
      digits = 0)

# Summary statistics by cut
cat("\n\nPrice statistics by cut:\n")
cut_stats <- round_diamonds %>%
  group_by(cut) %>%
  summarize(
    count = n(),
    mean_price = mean(price),
    median_price = median(price),
    std_dev = sd(price),
    .groups = "drop"
  )

kable(cut_stats, 
      caption = "Price Statistics by Cut",
      digits = 0)

# Correlation between carat and price
cat("\n\nCorrelation between carat and price:")
cat("\n", cor(round_diamonds$carat, round_diamonds$price))

# ============================================================================
# 5. ADDRESSING OVERPLOTTING - APPROACH 1: TRANSPARENCY (ALPHA)
# ============================================================================

cat("\n\n===== APPROACH 1: Using Transparency (Alpha) =====\n")
cat("Total diamonds plotted:", nrow(round_diamonds), "\n")
cat("This approach: Plot ALL data with varying transparency to see density\n\n")

plot_alpha <- ggplot(round_diamonds, aes(x = carat, y = price, color = clarity)) +
  geom_point(alpha = 0.3, size = 2) +
  facet_wrap(~cut) +
  scale_color_brewer(palette = "Blues", direction = -1) +
  labs(
    title = "Diamonds: Full Dataset with Transparency",
    subtitle = "Alpha = 0.3 reveals overlapping points through transparency",
    x = "Carat Weight",
    y = "Price (USD)",
    color = "Clarity"
  ) +
  theme_minimal() +
  theme(
    plot.title = element_text(size = 14, face = "bold"),
    plot.subtitle = element_text(size = 11, color = "gray40")
  )

print(plot_alpha)

# ============================================================================
# 6. ADDRESSING OVERPLOTTING - APPROACH 2A: SIMPLE RANDOM SAMPLE
# ============================================================================

cat("\n===== APPROACH 2A: Simple Random Sample (20%) =====\n")

# Take a simple random sample of 20% of the data
set.seed(42)  # For reproducibility
sample_size <- ceiling(nrow(round_diamonds) * 0.20)
cat("Sampling", sample_size, "diamonds (20% of", nrow(round_diamonds), "total)\n\n")

diamonds_sample_simple <- round_diamonds %>%
  slice_sample(n = sample_size)

plot_simple_sample <- ggplot(diamonds_sample_simple, aes(x = carat, y = price, color = clarity)) +
  geom_point(alpha = 0.6, size = 2.5) +
  facet_wrap(~cut) +
  scale_color_brewer(palette = "Blues", direction = -1) +
  labs(
    title = "Diamonds: Simple Random Sample (20%)",
    subtitle = "Reduced dataset for clearer visualization of patterns",
    x = "Carat Weight",
    y = "Price (USD)",
    color = "Clarity"
  ) +
  theme_minimal() +
  theme(
    plot.title = element_text(size = 14, face = "bold"),
    plot.subtitle = element_text(size = 11, color = "gray40")
  )

print(plot_simple_sample)

# Summary of sample
cat("Sample distribution by clarity:\n")
sample_clarity <- diamonds_sample_simple %>%
  group_by(clarity) %>%
  summarize(count = n(), .groups = "drop")
kable(sample_clarity, caption = "Simple Sample Distribution by Clarity")

# ============================================================================
# 7. ADDRESSING OVERPLOTTING - APPROACH 2B: STRATIFIED RANDOM SAMPLE
# ============================================================================

cat("\n===== APPROACH 2B: Stratified Random Sample (20% per clarity) =====\n")
cat("This ensures each clarity grade is represented proportionally\n\n")

# Take a stratified random sample of 20% within each clarity group
diamonds_sample_stratified <- round_diamonds %>%
  group_by(clarity) %>%
  slice_sample(prop = 0.20) %>%
  ungroup()

cat("Total sampled:", nrow(diamonds_sample_stratified), "diamonds\n")
cat("Original total:", nrow(round_diamonds), "diamonds\n\n")

plot_stratified_sample <- ggplot(diamonds_sample_stratified, aes(x = carat, y = price, color = clarity)) +
  geom_point(alpha = 0.6, size = 2.5) +
  facet_wrap(~cut) +
  scale_color_brewer(palette = "Blues", direction = -1) +
  labs(
    title = "Diamonds: Stratified Random Sample (20% per Clarity)",
    subtitle = "Proportional sampling maintains clarity group representation",
    x = "Carat Weight",
    y = "Price (USD)",
    color = "Clarity"
  ) +
  theme_minimal() +
  theme(
    plot.title = element_text(size = 14, face = "bold"),
    plot.subtitle = element_text(size = 11, color = "gray40")
  )

print(plot_stratified_sample)

# Summary of stratified sample
cat("Stratified sample distribution by clarity:\n")
strat_clarity <- diamonds_sample_stratified %>%
  group_by(clarity) %>%
  summarize(count = n(), proportion = round(n()/nrow(diamonds_sample_stratified), 3), .groups = "drop")
kable(strat_clarity, caption = "Stratified Sample Distribution by Clarity")

# Compare proportions to original
cat("\nComparison to original data:\n")
orig_clarity <- round_diamonds %>%
  group_by(clarity) %>%
  summarize(count = n(), proportion = round(n()/nrow(round_diamonds), 3), .groups = "drop")
kable(orig_clarity, caption = "Original Data Distribution by Clarity")

# ============================================================================
# 8. COMPARISON SUMMARY
# ============================================================================

cat("\n\n===== SUMMARY: Overplotting Solutions =====\n")
cat("\nAPPROACH 1 - TRANSPARENCY (Alpha):\n")
cat("  ✓ Pros: Shows all data, reveals density/clustering\n")
cat("  ✓ Pros: No information loss\n")
cat("  ✗ Cons: Still difficult to see individual points at high density\n")
cat("  ✗ Cons: Many overlapped points look dark\n\n")

cat("APPROACH 2A - SIMPLE RANDOM SAMPLE:\n")
cat("  ✓ Pros: Cleaner visualization, easier to see patterns\n")
cat("  ✗ Cons: May undersample rare groups (low clarity grades)\n")
cat("  ✗ Cons: Some information loss\n\n")

cat("APPROACH 2B - STRATIFIED RANDOM SAMPLE:\n")
cat("  ✓ Pros: Cleaner visualization\n")
cat("  ✓ Pros: Preserves representation of all clarity groups\n")
cat("  ✓ Pros: Best for showing relationships across groups\n")
cat("  ✗ Cons: Still some information loss\n")

