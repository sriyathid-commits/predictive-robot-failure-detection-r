library(readr)
library(dplyr)
library(pROC)

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

decision_tree_prob <- predict(
  decision_tree_model,
  test_ml,
  type = "prob"
)[, "1"]

x_test <- test_ml[, names(test_ml) != "Machine failure"]

random_forest_prob <- predict(
  random_forest_model,
  x_test,
  type = "prob"
)[, "1"]

svm_prob <- attr(
  predict(
    svm_model,
    test_ml,
    probability = TRUE
  ),
  "probabilities"
)[, "1"]

actual <- as.numeric(
  as.character(test_ml$`Machine failure`)
)

roc_logistic <- roc(actual, logistic_prob)
roc_tree <- roc(actual, decision_tree_prob)
roc_rf <- roc(actual, random_forest_prob)
roc_svm <- roc(actual, svm_prob)

auc_results <- data.frame(
  Model = c(
    "Logistic Regression",
    "Decision Tree",
    "Random Forest",
    "SVM"
  ),
  AUC = c(
    as.numeric(auc(roc_logistic)),
    as.numeric(auc(roc_tree)),
    as.numeric(auc(roc_rf)),
    as.numeric(auc(roc_svm))
  )
)

print(auc_results)

dir.create("plots", showWarnings = FALSE)

png(
  "plots/roc_curve_comparison.png",
  width = 900,
  height = 700
)

plot(
  roc_logistic,
  main = "ROC Curve Comparison",
  lwd = 2
)

lines(
  roc_tree,
  lwd = 2
)

lines(
  roc_rf,
  lwd = 2
)

lines(
  roc_svm,
  lwd = 2
)

abline(
  a = 0,
  b = 1,
  lty = 2
)

legend(
  "bottomright",
  legend = c(
    paste0("Logistic Regression AUC = ", round(auc(roc_logistic), 3)),
    paste0("Decision Tree AUC = ", round(auc(roc_tree), 3)),
    paste0("Random Forest AUC = ", round(auc(roc_rf), 3)),
    paste0("SVM AUC = ", round(auc(roc_svm), 3))
  ),
  lwd = 2
)

dev.off()

write.csv(
  auc_results,
  "results/auc_results.csv",
  row.names = FALSE
)