library(tidyverse)
library(knitr)
library (kableExtra)
data(diamonds)

# Select 4C's and price
diamonds %>% select(cut, color, clarity, carat, price) %>%
  kable( %>%
  caption = "4C's of Diamonds and Price" %>%
  col.names = c(
    "Cut Quality",
    "Color",
    "Clarity",
    "Weight (ct)",
    "Price (US$)",
  ),
  align = "lllcc"
) %>%
kable_classic(
    lightable_options = "striped"
)

diamondFreq <- diamonds %>%
  group_by(cut, color, clarity) %>%
  summarise(count = n()) %>%
  ungroup() %>%
  arrange(desc(count))
