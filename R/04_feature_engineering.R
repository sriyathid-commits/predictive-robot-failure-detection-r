library(readr)
library(dplyr)

ai4i2020 <- read_csv(
  "data/processed/ai4i2020_clean.csv",
  show_col_types = FALSE
)

ai4i2020 <- ai4i2020 %>%
  mutate(
    Temperature_Difference =
      `Process temperature [K]` - `Air temperature [K]`,
    Power =
      `Rotational speed [rpm]` * `Torque [Nm]`
  )

write_csv(
  ai4i2020,
  "data/processed/ai4i2020_feature_engineered.csv"
)

print(dim(ai4i2020))
print(names(ai4i2020))
source("R/04_feature_engineering.R")
