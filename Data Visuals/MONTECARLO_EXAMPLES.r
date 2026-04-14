# MONTE CARLO INTEGRATION - USAGE EXAMPLES
# Examples showing how to modify the main script for different curves

# ============================================================================
# EXAMPLE 1: Square Root Function (Original)
# ============================================================================
# Integrating: f(x) = √x from x=0 to x=4
# True analytical solution: ∫√x dx = (2/3)x^(3/2) |_0^4 = 5.3333

set_example_1 <- function() {
  function_to_integrate <- function(x) sqrt(x)
  x_bounds <- c(0, 4)
  y_bounds <- c(0, 2)
  true_area <- (2/3) * (4^(3/2) - 0^(3/2))  # ≈ 5.3333
  
  return(list(
    func = function_to_integrate,
    x_bounds = x_bounds,
    y_bounds = y_bounds,
    true_area = true_area,
    description = "f(x) = √x from 0 to 4"
  ))
}

# ============================================================================
# EXAMPLE 2: Semicircle (Area of Half Circle)
# ============================================================================
# Integrating: f(x) = √(1 - x²) from x=-1 to x=1
# True analytical solution: π/2 ≈ 1.5708
# This is the area of a half-circle with radius 1

set_example_2 <- function() {
  function_to_integrate <- function(x) sqrt(1 - x^2)
  x_bounds <- c(-1, 1)
  y_bounds <- c(0, 1)
  true_area <- pi / 2  # ≈ 1.5708
  
  return(list(
    func = function_to_integrate,
    x_bounds = x_bounds,
    y_bounds = y_bounds,
    true_area = true_area,
    description = "f(x) = √(1 - x²) semicircle, radius 1"
  ))
}

# ============================================================================
# EXAMPLE 3: Quadratic Function
# ============================================================================
# Integrating: f(x) = x² from x=0 to x=2
# True analytical solution: ∫x² dx = (1/3)x³ |_0^2 = 8/3 ≈ 2.6667

set_example_3 <- function() {
  function_to_integrate <- function(x) x^2
  x_bounds <- c(0, 2)
  y_bounds <- c(0, 4)
  true_area <- (1/3) * (2^3 - 0^3)  # ≈ 2.6667
  
  return(list(
    func = function_to_integrate,
    x_bounds = x_bounds,
    y_bounds = y_bounds,
    true_area = true_area,
    description = "f(x) = x² from 0 to 2"
  ))
}

# ============================================================================
# EXAMPLE 4: Exponential Function
# ============================================================================
# Integrating: f(x) = e^x from x=0 to x=2
# True analytical solution: ∫e^x dx = e^x |_0^2 = e² - 1 ≈ 6.3891

set_example_4 <- function() {
  function_to_integrate <- function(x) exp(x)
  x_bounds <- c(0, 2)
  y_bounds <- c(0, 8)
  true_area <- exp(2) - exp(0)  # ≈ 6.3891
  
  return(list(
    func = function_to_integrate,
    x_bounds = x_bounds,
    y_bounds = y_bounds,
    true_area = true_area,
    description = "f(x) = e^x from 0 to 2"
  ))
}

# ============================================================================
# EXAMPLE 5: Sine Function (Quarter Period)
# ============================================================================
# Integrating: f(x) = sin(x) from x=0 to x=π/2
# True analytical solution: ∫sin(x) dx = -cos(x) |_0^π/2 = 1

set_example_5 <- function() {
  function_to_integrate <- function(x) sin(x)
  x_bounds <- c(0, pi/2)
  y_bounds <- c(0, 1)
  true_area <- -cos(pi/2) - (-cos(0))  # = 0 - (-1) = 1
  
  return(list(
    func = function_to_integrate,
    x_bounds = x_bounds,
    y_bounds = y_bounds,
    true_area = true_area,
    description = "f(x) = sin(x) from 0 to π/2"
  ))
}

# ============================================================================
# EXAMPLE 6: Cubic Function
# ============================================================================
# Integrating: f(x) = x³ from x=0 to x=3
# True analytical solution: ∫x³ dx = (1/4)x⁴ |_0^3 = 81/4 = 20.25

set_example_6 <- function() {
  function_to_integrate <- function(x) x^3
  x_bounds <- c(0, 3)
  y_bounds <- c(0, 27)
  true_area <- (1/4) * (3^4 - 0^4)  # = 20.25
  
  return(list(
    func = function_to_integrate,
    x_bounds = x_bounds,
    y_bounds = y_bounds,
    true_area = true_area,
    description = "f(x) = x³ from 0 to 3"
  ))
}

# ============================================================================
# HOW TO USE: Template for Adapting Main Script
# ============================================================================

# 1. Choose an example (or define your own):
my_example <- set_example_3()  # Using quadratic function

# 2. Extract parameters:
function_to_integrate <- my_example$func
x_bounds <- my_example$x_bounds
y_bounds <- my_example$y_bounds
true_area <- my_example$true_area

# 3. Run the main analysis pipeline (from montecarlosim.r)
# The rest of the script uses these variables automatically

# 4. At the end, replace the analytical solution display with:
cat("\nTrue Area (Analytical Solution):\n")
cat(my_example$description, "\n")
cat("Calculated: ", round(true_area, 6), "\n")

# ============================================================================
# COMPARISON TABLE: What Each Example Tests
# ============================================================================
# 
# Example | Function    | Domain      | Why Useful
# --------|-------------|-------------|--------------------------------
#   1     | √x          | [0, 4]      | Non-polynomial, square root
#   2     | √(1-x²)     | [-1, 1]     | Circular arc, π estimation
#   3     | x²          | [0, 2]      | Simple polynomial
#   4     | eˣ          | [0, 2]      | Exponential growth
#   5     | sin(x)      | [0, π/2]    | Trigonometric
#   6     | x³          | [0, 3]      | Cubic polynomial
#
# These examples demonstrate that Monte Carlo integration works across
# many function types, domains, and mathematical structures.

