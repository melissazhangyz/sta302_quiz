library(tidyverse)

set.seed(42) 

# Parameters
n_days <- 100
min_pages <- 20
max_pages <- 100
people <- c('Matt', 'Ash', 'Jacki', 'Rol', 'Mike')

# Simulate independent reading for Matt, Ash, and Jacki
independent_readings <- tibble(
  Person = rep(people[1:3], each = n_days),
  Day = rep(1:n_days, times = 3),
  Pages = sample(min_pages:max_pages, size = n_days * 3, replace = TRUE)
)

# Simulate correlated reading for Rol and Mike (the couple)
rol_readings <- sample(min_pages:max_pages, size = n_days, replace = TRUE)
mike_readings <- rol_readings + sample(-10:10, size = n_days, replace = TRUE)
mike_readings <- pmax(pmin(mike_readings, max_pages), min_pages) # Ensuring within bounds

couple_readings <- tibble(
  Person = rep(c('Rol', 'Mike'), each = n_days),
  Day = rep(1:n_days, times = 2),
  Pages = c(rol_readings, mike_readings)
)

# Combine all readings
all_readings <- bind_rows(independent_readings, couple_readings)

# Convert to wide format for analysis
reading_data_wide <- all_readings %>% 
  pivot_wider(names_from = Day, values_from = Pages)

# Calculate average pages read by each person
avg_pages_read <- reading_data_wide %>% 
  select(-Person) %>% 
  summarise(across(everything(), mean, na.rm = TRUE)) %>% 
  pivot_longer(everything(), names_to = "Person", values_to = "AveragePages")

# Calculate correlation between Rol and Mike's readings
correlation_rol_mike <- all_readings %>% 
  filter(Person %in% c('Rol', 'Mike')) %>% 
  spread(key = Person, value = Pages) %>% 
  summarise(correlation = cor(Rol, Mike)) %>% 
  .$correlation

print("Average pages read by each person:")
print(avg_pages_read)
print("\nCorrelation between Rol and Mike's readings:")
print(correlation_rol_mike)

# Draw Graph
library(tidyverse)

# Assuming all_readings contains the simulated data from the previous step
# all_readings <- bind_rows(independent_readings, couple_readings)

# Visualize the reading data
ggplot(all_readings, aes(x = Day, y = Pages, color = Person)) +
  geom_line() + 
  theme_minimal() +
  labs(title = "Daily Pages Read by Each Undergraduate Over 100 Days",
       x = "Day",
       y = "Pages Read",
       color = "Undergraduate") +
  theme(legend.position = "bottom")
