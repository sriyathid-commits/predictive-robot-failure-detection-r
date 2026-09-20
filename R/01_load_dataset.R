library(readr)

ai4i2020 <- read_csv(
  "data/raw/ai4i2020.csv",
  show_col_types = FALSE
)

print(dim(ai4i2020))
print(names(ai4i2020))