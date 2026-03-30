library(tidyverse)
library(dcData)
data("OrdwayBirds")
data("OrdwaySpeciesNames")

# Examine the structure of both datasets
str(OrdwayBirds)
str(OrdwaySpeciesNames)

# Join OrdwayBirds with standardized species names using left_join and join_by
ordway_birds_with_names <- OrdwayBirds %>%
  left_join(OrdwaySpeciesNames, join_by(species == species_code))

