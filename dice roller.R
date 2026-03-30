# Improved D&D Dice Roller
rollDice <- function(diceType, nDice, resultType){
  
  diceSides <- c(
    d4 = 4,
    d6 = 6,
    d8 = 8,
    d10 = 10,
    d12 = 12,
    d20 = 20
  )
  
  if(!(diceType %in% names(diceSides))){
    stop("Invalid dice type")
  }
  
  numSides <- diceSides[diceType]
  
  dieFaces <- 1:numSides
  
  rollResults <- sample(dieFaces, nDice, replace = TRUE)
  
  if(resultType == "sum"){
    return(sum(rollResults))
  } else{
    return(rollResults)
  }
}

# Number of simulations
set.seed(123)
nSim <- 100000

# Store results
rollMatrix <- matrix(NA, nrow = nSim, ncol = 2)

# Simulate rolling two d12 dice
for(i in 1:nSim){
  rollMatrix[i, ] <- rollDice("d12", 2, "rolls")
}

# Create frequency table
pairTable <- table(rollMatrix[,1], rollMatrix[,2])

# Convert to relative frequencies
relFreqTable <- pairTable / nSim

# Convert to data frame for rendering
relFreqDF <- as.data.frame.matrix(relFreqTable)

# Render table (R Markdown / Viewer)
knitr::kable(
  relFreqDF,
  caption = "Relative Frequencies of Pairwise Outcomes for Two d12 Dice"
)