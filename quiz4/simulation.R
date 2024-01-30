###Set up
library(tidyverse)

###Simulation foundation
set.seed(2002)
number_of_friend <- 20
real_heights <- rnorm(number_of_friend, 170, 5)

###Error of measurement
error_jenny <- 1
error_arial <- runif(number_of_friend, -1, 1)
error_ken <- -1

###Chart simulated
simulation_chart <-
  tibble(
    "real_hieght" = real_heights,
    "Jenny" = real_heights + error_jenny,
    "Arial" = real_heights + error_arial,
    "Ken" = real_heights + error_ken
  )

head(simulation_chart)

###Test of real height range
max(real_heights) <= 200
min(real_heights) >= 150

###Test of error
simulation_chart$Jenny - simulation_chart$Arial == 0
simulation_chart$Jenny - simulation_chart$Ken == 0
simulation_chart$Arial - simulation_chart$Ken == 0

###Test of each measurement error
simulation_chart$Jenny - simulation_chart$real_hieght == 0
simulation_chart$Arial - simulation_chart$real_hieght == 0
simulation_chart$Ken - simulation_chart$real_hieght == 0