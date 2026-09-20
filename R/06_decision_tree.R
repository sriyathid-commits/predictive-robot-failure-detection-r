library(rpart)
library(caret)

decision_tree_model <- rpart(
  `Machine failure` ~ .,
  data = train_ml,
  method = "class"
)

saveRDS(
  decision_tree_model,
  "models/decision_tree_model.rds"
)

decision_tree_pred <- predict(
  decision_tree_model,
  newdata = test_ml,
  type = "class"
)

decision_tree_cm <- confusionMatrix(
  decision_tree_pred,
  test_ml$`Machine failure`,
  positive = "1"
)

source("R/06_decision_tree.R")

print(decision_tree_cm)
