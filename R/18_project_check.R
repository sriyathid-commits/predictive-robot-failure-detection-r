required_files <- c(
  "data/raw/ai4i2020.csv",
  "data/processed/ai4i2020_clean.csv",
  "data/processed/ai4i2020_feature_engineered.csv",
  "models/logistic_model.rds",
  "models/decision_tree_model.rds",
  "models/random_forest_model.rds",
  "models/svm_model.rds",
  "models/final_random_forest_model.rds",
  "results/model_comparison.csv",
  "results/auc_results.csv",
  "results/feature_importance.csv",
  "results/hyperparameter_tuning.csv",
  "results/final_model_evaluation.csv",
  "results/final_feature_importance.csv",
  "plots/roc_curve_comparison.png",
  "plots/final_failure_distribution.png",
  "plots/tool_wear_vs_torque.png",
  "plots/final_speed_torque.png"
)

file_status <- file.exists(required_files)

project_check <- data.frame(
  File = required_files,
  Exists = file_status
)

print(project_check)

cat(
  "\nFiles found:",
  sum(file_status),
  "out of",
  length(required_files),
  "\n"
)

if (all(file_status)) {
  print("PROJECT CHECK PASSED")
} else {
  print("SOME FILES ARE MISSING")
}
source("R/18_project_check.R")
