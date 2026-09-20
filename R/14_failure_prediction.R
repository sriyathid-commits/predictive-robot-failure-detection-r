library(randomForest)

final_model <- readRDS(
  "models/final_random_forest_model.rds"
)

new_machine <- data.frame(
  Type = factor("M", levels = c("H", "L", "M")),
  Air.temperature..K. = 300,
  Process.temperature..K. = 310,
  Rotational.speed..rpm. = 1500,
  Torque..Nm. = 45,
  Tool.wear..min. = 180,
  Power = 1500 * 45
)

prediction <- predict(
  final_model,
  new_machine,
  type = "class"
)

probability <- predict(
  final_model,
  new_machine,
  type = "prob"
)

print(prediction)
print(probability)
source("R/14_failure_prediction.R")
