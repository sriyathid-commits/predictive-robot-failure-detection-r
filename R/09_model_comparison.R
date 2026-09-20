library(readr)
library(dplyr)
library(caret)

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

logistic_model <- readRDS("models/logistic_model.rds")
decision_tree_model <- readRDS("models/decision_tree_model.rds")
random_forest_model <- readRDS("models/random_forest_model.rds")
svm_model <- readRDS("models/svm_model.rds")

logistic_prob <- predict(
  logistic_model,
  test_ml,
  type = "response"
)

logistic_pred <- factor(
  ifelse(logistic_prob >= 0.5, 1, 0),
  levels = c(0, 1)
)

decision_tree_pred <- predict(
  decision_tree_model,
  test_ml,
  type = "class"
)

x_test <- test_ml[, names(test_ml) != "Machine failure"]

random_forest_pred <- predict(
  random_forest_model,
  x_test,
  type = "class"
)

svm_pred <- predict(
  svm_model,
  test_ml
)

logistic_cm <- confusionMatrix(
  logistic_pred,
  test_ml$`Machine failure`,
  positive = "1"
)

decision_tree_cm <- confusionMatrix(
  decision_tree_pred,
  test_ml$`Machine failure`,
  positive = "1"
)

random_forest_cm <- confusionMatrix(
  random_forest_pred,
  test_ml$`Machine failure`,
  positive = "1"
)

svm_cm <- confusionMatrix(
  svm_pred,
  test_ml$`Machine failure`,
  positive = "1"
)

model_comparison <- data.frame(
  Model = c(
    "Logistic Regression",
    "Decision Tree",
    "Random Forest",
    "SVM"
  ),
  Accuracy = c(
    logistic_cm$overall["Accuracy"],
    decision_tree_cm$overall["Accuracy"],
    random_forest_cm$overall["Accuracy"],
    svm_cm$overall["Accuracy"]
  ),
  Precision = c(
    logistic_cm$byClass["Pos Pred Value"],
    decision_tree_cm$byClass["Pos Pred Value"],
    random_forest_cm$byClass["Pos Pred Value"],
    svm_cm$byClass["Pos Pred Value"]
  ),
  Recall = c(
    logistic_cm$byClass["Sensitivity"],
    decision_tree_cm$byClass["Sensitivity"],
    random_forest_cm$byClass["Sensitivity"],
    svm_cm$byClass["Sensitivity"]
  ),
  Specificity = c(
    logistic_cm$byClass["Specificity"],
    decision_tree_cm$byClass["Specificity"],
    random_forest_cm$byClass["Specificity"],
    svm_cm$byClass["Specificity"]
  ),
  F1 = c(
    logistic_cm$byClass["F1"],
    decision_tree_cm$byClass["F1"],
    random_forest_cm$byClass["F1"],
    svm_cm$byClass["F1"]
  ),
  Balanced_Accuracy = c(
    logistic_cm$byClass["Balanced Accuracy"],
    decision_tree_cm$byClass["Balanced Accuracy"],
    random_forest_cm$byClass["Balanced Accuracy"],
    svm_cm$byClass["Balanced Accuracy"]
  )
)

print(model_comparison)

write.csv(
  model_comparison,
  "results/model_comparison.csv",
  row.names = FALSE
)
source("R/09_model_comparison.R")
