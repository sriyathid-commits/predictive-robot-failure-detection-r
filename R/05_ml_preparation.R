library(readr)
library(dplyr)

ai4i2020 <- read_csv(
  "data/processed/ai4i2020_feature_engineered.csv",
  show_col_types = FALSE
)

ai4i2020$Type <- as.factor(ai4i2020$Type)
ai4i2020$`Machine failure` <- as.factor(ai4i2020$`Machine failure`)

set.seed(123)

train_index <- sample(
  1:nrow(ai4i2020),
  size = 0.8 * nrow(ai4i2020)
)

train_data <- ai4i2020[train_index, ]
test_data <- ai4i2020[-train_index, ]

train_ml <- train_data %>%
  select(
    Type,
    `Air temperature [K]`,
    `Process temperature [K]`,
    `Rotational speed [rpm]`,
    `Torque [Nm]`,
    `Tool wear [min]`,
    Power,
    `Machine failure`
  )

test_ml <- test_data %>%
  select(
    Type,
    `Air temperature [K]`,
    `Process temperature [K]`,
    `Rotational speed [rpm]`,
    `Torque [Nm]`,
    `Tool wear [min]`,
    Power,
    `Machine failure`
  )

print(dim(train_ml))
print(dim(test_ml))

print(table(train_ml$`Machine failure`))
print(table(test_ml$`Machine failure`))
source("R/05_ml_preparation.R")
