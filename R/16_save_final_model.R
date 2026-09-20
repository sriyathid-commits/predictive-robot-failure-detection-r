library(randomForest)

final_model <- readRDS(
  "models/final_random_forest_model.rds"
)

saveRDS(
  final_model,
  "models/final_random_forest_model.rds"
)

importance_data <- importance(final_model)

importance_data <- data.frame(
  Feature = rownames(importance_data),
  importance_data,
  row.names = NULL
)

write.csv(
  importance_data,
  "results/final_feature_importance.csv",
  row.names = FALSE
)

print("Final model saved successfully.")
print("Final feature importance saved successfully.")
print(importance_data)
source("R/16_save_final_model.R")
