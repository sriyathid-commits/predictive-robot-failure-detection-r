library(e1071)
library(caret)

source("R/05_ml_preparation.R")

set.seed(123)

svm_model <- svm(
  `Machine failure` ~ .,
  data = train_ml,
  kernel = "radial",
  probability = TRUE
)

saveRDS(
  svm_model,
  "models/svm_model.rds"
)

svm_pred <- predict(
  svm_model,
  newdata = test_ml
)

svm_cm <- confusionMatrix(
  svm_pred,
  test_ml$`Machine failure`,
  positive = "1"
)

print(svm_cm)

source("R/08_svm.R")
