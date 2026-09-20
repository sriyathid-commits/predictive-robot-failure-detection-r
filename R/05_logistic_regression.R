library(caret)

logistic_model <- glm(
  `Machine failure` ~ .,
  data = train_ml,
  family = binomial
)

saveRDS(
  logistic_model,
  "models/logistic_model.rds"
)

logistic_prob <- predict(
  logistic_model,
  newdata = test_ml,
  type = "response"
)

logistic_pred <- ifelse(
  logistic_prob >= 0.5,
  1,
  0
)

logistic_pred <- factor(
  logistic_pred,
  levels = c(0, 1)
)

confusionMatrix(
  logistic_pred,
  test_ml$`Machine failure`,
  positive = "1"
)
