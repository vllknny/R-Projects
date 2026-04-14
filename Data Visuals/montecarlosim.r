# ============================================================================
# MONTE CARLO NUMERICAL INTEGRATION - SMALL MULTIPLES ANALYSIS
# ============================================================================
# Project: Estimating area under curves using random sampling
# Method: Monte Carlo integration at multiple resolutions
# Function: Beta Distribution PDF
# ============================================================================

library(tidyverse)
library(patchwork)

# ============================================================================
# STEP 1-3: HELPER FUNCTIONS (retained for reference)
# ============================================================================
# NOTE: These functions are retained for reference but the main workflow
# now uses monte_carlo_simulate() which combines all three steps.

# Original: generate_coordinates()
generate_coordinates <- function(n_samples, x_min, x_max, y_min, y_max) {
  tibble(
    x = runif(n_samples, min = x_min, max = x_max),
    y = runif(n_samples, min = y_min, max = y_max)
  )
}

# Original: flag_points_relative_to_function()
flag_points_relative_to_function <- function(data, func) {
  data %>%
    mutate(
      function_value = func(x),
      is_above_function = y > function_value
    )
}

# Original: estimate_integration()
estimate_integration <- function(data, x_min, x_max, y_min, y_max) {
  rectangle_area <- (x_max - x_min) * (y_max - y_min)
  points_below <- sum(!data$is_above_function)
  total_points <- nrow(data)
  
  estimated_area <- rectangle_area * (points_below / total_points)
  return(estimated_area)
}

# ============================================================================
# STEP 3B: MONTE CARLO SIMULATION FUNCTION
# ============================================================================
# Function: monte_carlo_simulate()
# Purpose: Execute complete Monte Carlo integration at specified resolution
# Inputs:
#   - n_samples: number of random points to generate
#   - x_min, x_max, y_min, y_max: bounds for sampling rectangle
#   - func: the function to integrate
# Output: data frame with all points and summary statistics

monte_carlo_simulate <- function(n_samples, x_min, x_max, y_min, y_max, func) {
  
  # Generate random coordinates within bounds
  coordinates <- tibble(
    x = runif(n_samples, min = x_min, max = x_max),
    y = runif(n_samples, min = y_min, max = y_max)
  )
  
  # Evaluate function and flag points relative to curve
  simulation <- coordinates %>%
    mutate(
      function_value = func(x),
      is_above_function = y > function_value
    )
  
  # Calculate integration estimates
  rectangle_area <- (x_max - x_min) * (y_max - y_min)
  points_below <- sum(!simulation$is_above_function)
  total_points <- nrow(simulation)
  estimated_area <- rectangle_area * (points_below / total_points)
  percent_below <- (points_below / total_points) * 100
  
  # Add summary statistics as columns
  simulation <- simulation %>%
    mutate(
      n_samples = n_samples,
      x_min = x_min,
      x_max = x_max,
      y_min = y_min,
      y_max = y_max,
      rectangle_area = rectangle_area,
      estimated_area = estimated_area,
      points_below = points_below,
      percent_below = percent_below
    )
  
  return(simulation)
}

# ============================================================================
# STEP 4: CREATE REUSABLE PLOT FUNCTION
# ============================================================================
# Function: plot_monte_carlo_beta()
# Purpose: Visualize Beta distribution and Monte Carlo points
# Inputs:
#   - simulation_data: output from monte_carlo_simulate()
#   - shape1_param, shape2_param: Beta distribution parameters
#   - x_min, x_max, y_min, y_max: bounds of sampling region
# Output: ggplot object

plot_monte_carlo_beta <- function(simulation_data, shape1_param, shape2_param, 
                                   x_min, x_max, y_min, y_max) {
  
  # Extract summary statistics
  area_estimate <- simulation_data$estimated_area[1]
  n_samples <- simulation_data$n_samples[1]
  
  # Prepare plot data
  plot_data <- simulation_data %>%
    select(x, y, function_value, is_above_function)
  
  # Create smooth function curve
  x_curve <- seq(x_min, x_max, length.out = 1000)
  curve_data <- tibble(
    x = x_curve,
    y = dbeta(x_curve, shape1 = shape1_param, shape2 = shape2_param)
  )
  
  # Create the plot
  ggplot() +
    # Points above the curve (red)
    geom_point(
      data = plot_data %>% filter(is_above_function),
      aes(x = x, y = y),
      color = "#E74C3C",
      alpha = 0.6,
      size = 2,
      shape = 16
    ) +
    # Points below the curve (blue)
    geom_point(
      data = plot_data %>% filter(!is_above_function),
      aes(x = x, y = y),
      color = "#3498DB",
      alpha = 0.6,
      size = 2,
      shape = 16
    ) +
    # Function curve
    geom_line(
      data = curve_data,
      aes(x = x, y = y),
      color = "black",
      size = 1.2
    ) +
    # Labels and titles
    labs(
      title = "Beta Distribution: dbeta(x, 2, 2)",
      subtitle = paste(
        "n =", format(n_samples, big.mark = ","),
        "| Area Estimate:", round(area_estimate, 6)
      ),
      x = "x",
      y = "Probability Density"
    ) +
    # Styling
    theme_minimal() +
    theme(
      plot.title = element_text(face = "bold", size = 11, hjust = 0.5),
      plot.subtitle = element_text(size = 10, hjust = 0.5),
      axis.text = element_text(size = 9),
      axis.title = element_text(size = 10),
      panel.grid.minor = element_blank(),
      panel.border = element_rect(color = "gray80", fill = NA)
    ) +
    xlim(x_min, x_max) +
    ylim(y_min, y_max)
}

# ============================================================================
# STEP 5: CREATE FOUR PLOTS AT DIFFERENT RESOLUTIONS
# ============================================================================

# Define Beta distribution parameters
shape1_param <- 2
shape2_param <- 2

# Define bounds for sampling region
x_min <- 0
x_max <- 1
y_min <- 0
y_max <- 2

# Sample sizes for four resolutions
sample_sizes <- c(100, 250, 1000, 5000)

# ============================================================================
# RESOLUTION 1: 100 points
# ============================================================================

sim_100 <- monte_carlo_simulate(
  n_samples = 100,
  x_min = x_min,
  x_max = x_max,
  y_min = y_min,
  y_max = y_max,
  func = function(x) dbeta(x, shape1 = shape1_param, shape2 = shape2_param)
)

plot_100 <- plot_monte_carlo_beta(
  sim_100,
  shape1_param = shape1_param,
  shape2_param = shape2_param,
  x_min = x_min,
  x_max = x_max,
  y_min = y_min,
  y_max = y_max
)

# ============================================================================
# RESOLUTION 2: 250 points
# ============================================================================

sim_250 <- monte_carlo_simulate(
  n_samples = 250,
  x_min = x_min,
  x_max = x_max,
  y_min = y_min,
  y_max = y_max,
  func = function(x) dbeta(x, shape1 = shape1_param, shape2 = shape2_param)
)

plot_250 <- plot_monte_carlo_beta(
  sim_250,
  shape1_param = shape1_param,
  shape2_param = shape2_param,
  x_min = x_min,
  x_max = x_max,
  y_min = y_min,
  y_max = y_max
)

# ============================================================================
# RESOLUTION 3: 1000 points
# ============================================================================

sim_1000 <- monte_carlo_simulate(
  n_samples = 1000,
  x_min = x_min,
  x_max = x_max,
  y_min = y_min,
  y_max = y_max,
  func = function(x) dbeta(x, shape1 = shape1_param, shape2 = shape2_param)
)

plot_1000 <- plot_monte_carlo_beta(
  sim_1000,
  shape1_param = shape1_param,
  shape2_param = shape2_param,
  x_min = x_min,
  x_max = x_max,
  y_min = y_min,
  y_max = y_max
)

# ============================================================================
# RESOLUTION 4: 5000 points
# ============================================================================

sim_5000 <- monte_carlo_simulate(
  n_samples = 5000,
  x_min = x_min,
  x_max = x_max,
  y_min = y_min,
  y_max = y_max,
  func = function(x) dbeta(x, shape1 = shape1_param, shape2 = shape2_param)
)

plot_5000 <- plot_monte_carlo_beta(
  sim_5000,
  shape1_param = shape1_param,
  shape2_param = shape2_param,
  x_min = x_min,
  x_max = x_max,
  y_min = y_min,
  y_max = y_max
)

# ============================================================================
# STEP 6: CREATE SMALL MULTIPLE WITH PATCHWORK
# ============================================================================

# Combine all four plots into a small multiple
small_multiple <- plot_100 + plot_250 + plot_1000 + plot_5000 +
  plot_layout(nrow = 2, ncol = 2) +
  plot_annotation(
    title = "Monte Carlo Integration of Beta Distribution",
    subtitle = "dbeta(x, shape1 = 2, shape2 = 2) | Four Resolutions",
    theme = theme(
      plot.title = element_text(size = 14, face = "bold", hjust = 0.5),
      plot.subtitle = element_text(size = 12, hjust = 0.5)
    )
  )

# Display the small multiple
print(small_multiple)

