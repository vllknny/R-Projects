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
flipCoin <- function(pHeads=0.5){
  if (pHeads < 0){
    print("Invalid")
    return(-1)
  }
  # Get pTails
  pTails <- 1 - pHeads
  # Simulate Coin
  result <- sample(x = c("Heads", "Tails"), size = 1, prob = c(pHeads))
  return(result)
}

flipCoin(1)

install.packages("roxygen2")
install.packages("document")

document::document(
  file_name = "C:/Users/kunal/Documents/VSC/R Projects/simCoin.R",
  check_package = FALSE,
  output_directory = "C:/Users/kunal/Documents/VSC/R Projects"
)