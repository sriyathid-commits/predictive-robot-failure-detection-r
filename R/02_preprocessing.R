library(readr)
library(dplyr)

ai4i2020 <- read_csv(
  "data/raw/ai4i2020.csv",
  show_col_types = FALSE
)

print(sum(is.na(ai4i2020)))

print(sum(duplicated(ai4i2020)))

ai4i2020 <- ai4i2020 %>%
  select(
    -UDI,
    -`Product ID`
  )

print(names(ai4i2020))
print(dim(ai4i2020))

write_csv(
  ai4i2020,
  "data/processed/ai4i2020_clean.csv"
)

print(file.exists("data/processed/ai4i2020_clean.csv"))

