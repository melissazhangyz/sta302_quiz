library(tidyverse)
library(ggplot2)
library(rstanarm)
library(modelsummary)

set.seed(123)

hospitals <- c('Hospital A', 'Hospital B', 'Hospital C', 'Hospital D', 'Hospital E')
years <- 2000:2019

# Simulate the dataset
data <- expand_grid(
  Hospital = hospitals,
  Year = years) %>%
  mutate(Deaths = rpois(n(), lambda = 20)) 

head(data)

#model
model1 <-
  stan_glm(
    Deaths ~ Hospital,
    data = data,
    family = poisson(link = "log"),
    seed = 853
  )

#graph
pp_check(model1) +
  theme(legend.position = "bottom")
