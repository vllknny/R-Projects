install.packages("lintr")

lintr::use_lintr(type = "tidyverse")

# in a project:
lintr::lint_dir()
