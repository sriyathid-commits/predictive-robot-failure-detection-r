library(randomForest)
library(ggplot2)
library(dplyr)

model <- readRDS("models/final_random_forest_model.rds")

importance_data <- as.data.frame(importance(model))
importance_data$Feature <- rownames(importance_data)

importance_data <- importance_data %>%
  arrange(desc(MeanDecreaseAccuracy))

write.csv(
  importance_data,
  "results/final_feature_importance.csv",
  row.names = FALSE
)

p <- ggplot(
  importance_data,
  aes(
    x = reorder(Feature, MeanDecreaseAccuracy),
    y = MeanDecreaseAccuracy
  )
) +
  geom_col() +
  coord_flip() +
  labs(
    title = "Random Forest Feature Importance",
    x = "Feature",
    y = "Mean Decrease in Accuracy"
  ) +
  theme_minimal()

ggsave(
  "plots/feature_importance.png",
  plot = p,
  width = 10,
  height = 7,
  dpi = 300
)

print(p)
file.remove("plots/feature_importance.png")
file.info("plots/feature_importance.png")$size
