install.packages("ggplot2")
library(readr)
library(dplyr)
library(ggplot2)

ai4i2020 <- read_csv(
  "data/processed/ai4i2020_clean.csv",
  show_col_types = FALSE
)

print(table(ai4i2020$Type))

print(table(ai4i2020$`Machine failure`))

print(prop.table(table(ai4i2020$`Machine failure`)) * 100)

ggplot(ai4i2020, aes(x = factor(`Machine failure`), fill = factor(`Machine failure`))) +
  geom_bar() +
  labs(
    title = "Machine Failure Distribution",
    x = "Machine Failure",
    y = "Count",
    fill = "Failure"
  ) +
  scale_fill_manual(
    values = c("0" = "steelblue", "1" = "red"),
    labels = c("0" = "No Failure", "1" = "Failure")
  ) +
  theme_minimal()

ggplot(ai4i2020, aes(x = Type, fill = factor(`Machine failure`))) +
  geom_bar() +
  labs(
    title = "Machine Failure by Product Type",
    x = "Product Type",
    y = "Count",
    fill = "Failure"
  ) +
  scale_fill_manual(
    values = c("0" = "mediumseagreen", "1" = "tomato"),
    labels = c("0" = "No Failure", "1" = "Failure")
  ) +
  theme_minimal()

ggplot(ai4i2020, aes(
  x = `Rotational speed [rpm]`,
  y = `Torque [Nm]`,
  color = factor(`Machine failure`)
)) +
  geom_point(alpha = 0.6) +
  labs(
    title = "Rotational Speed vs Torque",
    x = "Rotational Speed (rpm)",
    y = "Torque (Nm)",
    color = "Failure"
  ) +
  scale_color_manual(
    values = c("0" = "royalblue", "1" = "red"),
    labels = c("0" = "No Failure", "1" = "Failure")
  ) +
  theme_minimal()
