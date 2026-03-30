#' Title
#'
#' @description
#' A function that simulates flipping a coin.
#'
#' @param pHeads numeric Probability of getting heads, default 0.5
#'
#' @returns The result of flipping a coin.
#'
#' @details
#' A longer description of the function that incorporates notes about any and
#' all inputs; use as many lines as necessary
#'
is_integer_even <- function(input) {
  if (!is.integer(input)) {
    print("Invalid")
    return("Input is not an integer")
  }
  # Get pTails
  if (input %% 2 == 0) {
    print("The integer is even")
  } else {
    print("The integer is odd.")
  }
}

is_integer_even(1)
