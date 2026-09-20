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
  newdata = new_machine,
  type = "class"
)

probability <- predict(
  final_model,
  newdata = new_machine,
  type = "prob"
)

cat("Machine Failure Prediction:", as.character(prediction), "\n")
cat("Failure Probability:", probability[1, "1"], "\n")
cat("No Failure Probability:", probability[1, "0"], "\n")
source("R/17_prediction_demo.R")
