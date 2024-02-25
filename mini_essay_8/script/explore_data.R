###Set up
library(arrow)
library(janitor)
library(knitr)
library(lubridate)
library(mice)
library(modelsummary)
library(naniar)
library(tidyverse)

###Read File
airbnb_data_selected <- 
  read_parquet("mini_essay_8/input/2023-12-12-paris-airbnblistings-select_variables.parquet")

###Explore Data
airbnb_data_selected$price |>
  head()

airbnb_data_selected$price |>
  str_split("") |>
  unlist() |>
  unique()

airbnb_data_selected |>
  select(price) |>
  filter(str_detect(price, ","))

airbnb_data_selected <-
  airbnb_data_selected |>
  mutate(
    price = str_remove_all(price, "[\\$,]"),
    price = as.integer(price)
  )

