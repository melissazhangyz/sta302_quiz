###set up
library(tidyverse)
library(ggplot2)

###read data
height_data <- read_csv("quiz4/simulation_data.csv")

# Reshape the data to a long format for ggplot
height_data <- height_data %>%
  pivot_longer(cols = -real_hieght, names_to = "measurer", values_to = "measured_height")

# Create the scatter plot
ggplot(height_data, aes(x = real_hieght, y = measured_height, color = measurer)) +
  geom_point() +
  theme_minimal() +
  labs(title = "Comparison of Height Measurements",
       x = "Real Height (cm)",
       y = "Measured Height (cm)",
       color = "Measurer") +
  theme(legend.position = "bottom")

