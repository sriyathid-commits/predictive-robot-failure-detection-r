library(randomForest)
library(caret)

ai4i2020 <- read.csv(
  "data/processed/ai4i2020_feature_engineered.csv"
)

ai4i2020$Type <- as.factor(ai4i2020$Type)
ai4i2020$Machine.failure <- as.factor(ai4i2020$Machine.failure)

set.seed(123)

train_index <- sample(
  1:nrow(ai4i2020),
  size = 0.8 * nrow(ai4i2020)
)

train_data <- ai4i2020[train_index, ]
test_data <- ai4i2020[-train_index, ]

train_ml <- train_data[, c(
  "Type",
  "Air.temperature..K.",
  "Process.temperature..K.",
  "Rotational.speed..rpm.",
  "Torque..Nm.",
  "Tool.wear..min.",
  "Power",
  "Machine.failure"
)]

test_ml <- test_data[, c(
  "Type",
  "Air.temperature..K.",
  "Process.temperature..K.",
  "Rotational.speed..rpm.",
  "Torque..Nm.",
  "Tool.wear..min.",
  "Power",
  "Machine.failure"
)]

x_train <- train_ml[, names(train_ml) != "Machine.failure"]
y_train <- train_ml$Machine.failure

x_test <- test_ml[, names(test_ml) != "Machine.failure"]
y_test <- test_ml$Machine.failure

set.seed(123)

final_model <- randomForest(
  x = x_train,
  y = y_train,
  ntree = 500,
  importance = TRUE
)

final_prediction <- predict(
  final_model,
  x_test,
  type = "class"
)

final_cm <- confusionMatrix(
  final_prediction,
  y_test,
  positive = "1"
)

print(final_cm)

final_results <- data.frame(
  Metric = c(
    "Accuracy",
    "Precision",
    "Recall",
    "Specificity",
    "F1",
    "Balanced Accuracy"
  ),
  Value = c(
    final_cm$overall["Accuracy"],
    final_cm$byClass["Pos Pred Value"],
    final_cm$byClass["Sensitivity"],
    final_cm$byClass["Specificity"],
    final_cm$byClass["F1"],
    final_cm$byClass["Balanced Accuracy"]
  )
)

print(final_results)

write.csv(
  final_results,
  "results/final_model_evaluation.csv",
  row.names = FALSE
)

saveRDS(
  final_model,
  "models/final_random_forest_model.rds"
)
source("R/13_model_evaluation.R")
