library(randomForest)
library(ggplot2)

random_forest_model <- readRDS(
  "models/random_forest_model.rds"
)

importance_data <- as.data.frame(
  importance(random_forest_model)
)

importance_data$Feature <- rownames(importance_data)

importance_data <- importance_data[
  order(importance_data$MeanDecreaseGini, decreasing = TRUE),
]

print(importance_data)

write.csv(
  importance_data,
  "results/feature_importance.csv",
  row.names = FALSE
)

dir.create("plots", showWarnings = FALSE)

png(
  "plots/feature_importance.png",
  width = 900,
  height = 700
)

ggplot(
  importance_data,
  aes(
    x = reorder(Feature, MeanDecreaseGini),
    y = MeanDecreaseGini
  )
) +
  geom_col() +
  coord_flip() +
  labs(
    title = "Random Forest Feature Importance",
    x = "Features",
    y = "Mean Decrease Gini"
  ) +
  theme_minimal()

dev.off()
source("R/11_feature_importance.R")

getwd()
list.files("R")
