library(ggplot2)
library(readr)

ai4i2020 <- read_csv(
  "data/processed/ai4i2020_feature_engineered.csv",
  show_col_types = FALSE
)

p1 <- ggplot(
  ai4i2020,
  aes(
    x = factor(`Machine failure`),
    fill = factor(`Machine failure`)
  )
) +
  geom_bar() +
  labs(
    title = "Machine Failure Distribution",
    x = "Machine Failure",
    y = "Count"
  ) +
  theme_minimal()

ggsave(
  "plots/final_failure_distribution.png",
  p1,
  width = 8,
  height = 5
)

p2 <- ggplot(
  ai4i2020,
  aes(
    x = `Tool wear [min]`,
    y = `Torque [Nm]`,
    color = factor(`Machine failure`)
  )
) +
  geom_point(alpha = 0.6) +
  labs(
    title = "Tool Wear vs Torque",
    x = "Tool Wear (min)",
    y = "Torque (Nm)",
    color = "Machine Failure"
  ) +
  theme_minimal()

ggsave(
  "plots/tool_wear_vs_torque.png",
  p2,
  width = 8,
  height = 5
)

p3 <- ggplot(
  ai4i2020,
  aes(
    x = `Rotational speed [rpm]`,
    y = `Torque [Nm]`,
    color = factor(`Machine failure`)
  )
) +
  geom_point(alpha = 0.6) +
  labs(
    title = "Rotational Speed vs Torque",
    x = "Rotational Speed (rpm)",
    y = "Torque (Nm)"
  ) +
  theme_minimal()

ggsave(
  "plots/final_speed_torque.png",
  p3,
  width = 8,
  height = 5
)

print("All visualizations saved successfully.")