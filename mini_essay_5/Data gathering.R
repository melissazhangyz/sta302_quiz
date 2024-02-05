library(babynames)
library(gh)
library(here)
library(httr)
library(janitor)
library(jsonlite)
library(knitr)
library(lubridate)
library(pdftools)
library(purrr)
library(rvest)
library(spotifyr)
library(tesseract)
library(tidyverse)
library(usethis)
library(xml2)

###Gathering raw data from web
raw_data <-
  read_html(
    "https://en.wikipedia.org/wiki/List_of_prime_ministers_of_Australia"
  )
write_html(raw_data, "mini_essay_5/pms.html")


###Obtain the relative part of the website
raw_data <- read_html("mini_essay_5/pms.html")

###Use selector to select data on web
parse_data_selector_gadget <-
  raw_data %>% 
  html_element(".plainrowheaders") %>% 
  html_table()

head(parse_data_selector_gadget)



###Extract needed data
parsed_data <-
  parse_data_selector_gadget %>% 
  clean_names() %>% 
  rename(raw_text = name_birth_death_constituency) %>% 
  select(raw_text) %>% 
  filter(raw_text != "name_birth_death_constituency") %>%  
  distinct() %>% 
  slice(-1)

head(parsed_data)



###Cleaning the data
initial_clean <-
  parsed_data %>% 
  separate(
    raw_text, 
    into = c("name", "not_name"), 
    sep = "\\(", remove = TRUE, extra = "merge"
    ) %>% 
  mutate(date = str_extract(not_name, "[[:digit:]]{4}–[[:digit:]]{4}"),
         born = str_extract(not_name, "born[[:space:]][[:digit:]]{4}")
  ) %>% 
  select(name, date, born)

head(initial_clean)

cleaned_data <-
  initial_clean %>% 
  separate(date, into = c("birth", "died"), 
           sep = "–") %>%  
  mutate(
    born = str_remove_all(born, "born[[:space:]]"),
    birth = if_else(!is.na(born), born, birth)
  ) %>% 
  select(-born) %>% 
  rename(born = birth) %>% 
  mutate(across(c(born, died), as.integer)) %>% 
  mutate(Age_at_Death = died - born) %>% 
  distinct()

head(cleaned_data)
write_csv(cleaned_data, "mini_essay_5/cleaned_data.csv")


###Make a table
cleaned_data %>% 
  head() %>% 
  kable(
    col.names = c("Prime Minister", "Birth year", "Death year", "Age at death")
  )