library(tidyverse)
library(ggplot2)
library(rstanarm)
library(modelsummary)

set.seed(123)

n <- 1000

data <- tibble( Support = rbinom(n, 1, 0.5),
                
                AgeGroup = sample(c('18-24', '25-34', '35-44', '45-54', '55-64', '65+'), n, replace = TRUE),
                
                Gender = sample(c('Male', 'Female', 'Other'), n, replace = TRUE),
                
                IncomeGroup = sample(c('Low', 'Middle', 'High'), n, replace = TRUE),
                
                HighestEducation = sample(c('Less than High School', 'High School Graduate', 
                                            'Some College', 'Bachelor Degree', 'Graduate Degree'), 
                                          n, replace = TRUE) )


#tests
data %>%
  group_by(AgeGroup) %>%
  summarize(SupportYes = mean(Support == 1))

data %>%
  group_by(Gender) %>%
  summarize(SupportYes = mean(Support == 1))

data %>%
  group_by(IncomeGroup) %>%
  summarize(SupportYes = mean(Support == 1))

data %>%
  group_by(HighestEducation) %>%
  summarize(SupportYes = mean(Support == 1))

data %>%
  group_by(AgeGroup, Gender) %>%
  summarize(SupportYes = mean(Support == 1))

data %>%
  group_by(IncomeGroup, HighestEducation) %>%
  summarize(SupportYes = mean(Support == 1))

data %>%
  group_by(Gender, HighestEducation) %>%
  summarize(SupportYes = mean(Support == 1))

data %>%
  group_by(AgeGroup, IncomeGroup) %>%
  summarize(SupportYes = mean(Support == 1))

chisq.test(table(data$Gender, data$Support))

#model
model1 <- glm(Support ~ AgeGroup + Gender + IncomeGroup + HighestEducation, data = data, family = binomial)

#plot the graph
modelplot(model1, conf_level = 0.9) +
  labs(x = "90 per cent credibility interval")
