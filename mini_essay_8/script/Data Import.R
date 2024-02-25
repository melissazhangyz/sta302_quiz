###Set up
library(arrow)
library(janitor)
library(knitr)
library(lubridate)
library(mice)
library(modelsummary)
library(naniar)
library(tidyverse)

###Import data
url <-
  paste0(
    "http://data.insideairbnb.com/france/ile-de-france/paris/2023-12-12/data/listings.csv.gz"
  )

airbnb_data <-
  read_csv(
    file = url,
    guess_max = 20000
  )

write_csv(airbnb_data, "mini_essay_8/input/airbnb_data.csv")

airbnb_data

###Rough Cleaning 
airbnb_data_selected <-
  airbnb_data |>
  select(
    host_id,
    host_response_time,
    host_is_superhost,
    host_total_listings_count,
    neighbourhood_cleansed,
    bathrooms,
    bedrooms,
    price,
    number_of_reviews,
    review_scores_rating,
    review_scores_accuracy,
    review_scores_value
  )

write_parquet(
  x = airbnb_data_selected, 
  sink = 
    "mini_essay_8/input/2023-12-12-paris-airbnblistings-select_variables.parquet"
)

rm(airbnb_data)