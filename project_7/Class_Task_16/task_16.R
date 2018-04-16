# library(riem)
# library(ggplot2)
# library(tidyverse)
# library(dplyr)
# library(ggridges)
# library(gridExtra)
# library(knitr)
# library(lubridate)
# library(readr)
# 
# df <- read_csv("https://byuistats.github.io/M335/data/carwash.csv")
# 
# new_df <- df %>% 
#   mutate(time = ymd_hms(time, tz = "America/Edmonton"), hour = hour(time), day = day(time), month = month(time), year = year(time))
  # group_by(hour, day, month, year, name, type) %>%
  # summarise(hour_amount = sum(amount))
# 
# new_df <- df %>% 
#   mutate(time = ymd_hms(time, tz = "America/Edmonton"), hour = ceiling_date(time, "hour")) %>% 
#   group_by(hour, name, type) %>% 
#   summarise(hour_amount = sum(amount))
# 
# temp_df <- riem_measures(station = "RXE",  date_start = "2016-05-13",  date_end = "2016-07-19")
# 
# new_temp_df <- temp_df %>%
#   select(station, valid, tmpf) %>%
#   drop_na() %>% 
#   mutate(hour = ceiling_date(valid, "hour"))
# 
# full_df <- left_join(new_df, new_temp_df)
# 
full_df %>% 
  ggplot(aes(x = tmpf, y = hour_amount, col = tmpf)) +
  geom_smooth() +
  geom_point() +
  scale_color_gradient(low = "blue", high = "red") +
  labs(y = "Dollars", x = "Temperature ºF", col = "Temp", title = "Money made according to temperature",
       subtitle = "It seems like people prefer going to the car wash when the temperature is not extreme") +
  ggsave("Case_Study_08/Class_Task_16/plot1.png", width = 12)
  