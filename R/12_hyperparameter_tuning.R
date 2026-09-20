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

results <- data.frame(
  ntree = c(100, 200, 300, 500),
  Accuracy = NA,
  Precision = NA,
  Recall = NA
)

for (i in 1:nrow(results)) {
  
  model <- randomForest(
    x = x_train,
    y = y_train,
    ntree = results$ntree[i],
    importance = TRUE
  )
  
  prediction <- predict(
    model,
    x_test,
    type = "class"
  )
  
  cm <- confusionMatrix(
    prediction,
    y_test,
    positive = "1"
  )
  
  results$Accuracy[i] <- cm$overall["Accuracy"]
  results$Precision[i] <- cm$byClass["Pos Pred Value"]
  results$Recall[i] <- cm$byClass["Sensitivity"]
}

print(results)

write.csv(
  results,
  "results/hyperparameter_tuning.csv",
  row.names = FALSE
)

source("R/12_hyperparameter_tuning.R")
