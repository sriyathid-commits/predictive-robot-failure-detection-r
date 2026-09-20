library(randomForest)
library(caret)

source("R/05_ml_preparation.R")

set.seed(123)

x_train <- train_ml[, names(train_ml) != "Machine failure"]
y_train <- train_ml$`Machine failure`

x_test <- test_ml[, names(test_ml) != "Machine failure"]
y_test <- test_ml$`Machine failure`

random_forest_model <- randomForest(
  x = x_train,
  y = y_train,
  ntree = 200,
  importance = TRUE
)

saveRDS(
  random_forest_model,
  "models/random_forest_model.rds"
)

random_forest_pred <- predict(
  random_forest_model,
  x_test,
  type = "class"
)

random_forest_cm <- confusionMatrix(
  random_forest_pred,
  y_test,
  positive = "1"
)

print(random_forest_cm)
source("R/07_random_forest.R")
