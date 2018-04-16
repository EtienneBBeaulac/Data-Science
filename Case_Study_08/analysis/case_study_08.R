# library(riem)
# library(tidyverse)
# library(ggridges)
# library(gridExtra)
# library(knitr)
# library(lubridate)
# library(readr)
# 
# original_dat <- read_csv("https://byuistats.github.io/M335/data/sales.csv")
# 
# dat <- original_dat %>%
#   filter(month(Time) > 5 & Name != 'Missing' & Amount <= 500) %>%
#   mutate(Time = as.Date(Time),
#          hourly = floor_date(Time, unit = "hour"),
#          daily = floor_date(Time, unit = "day"),
#          weekly = floor_date(Time, unit = "week"),
#          monthly = floor_date(Time, unit = "month"))
# 
# hour_dat <- dat %>%
#   group_by(Name, Type, hourly) %>%
#   summarise(Amount = sum(Amount))
# 
# day_dat <- dat %>%
#   group_by(Name, Type, daily) %>%
#   summarise(Amount = sum(Amount))
# 
# week_dat <- dat %>%
#   group_by(Name, Type, weekly) %>%
#   summarise(Amount = sum(Amount))
# 
# month_dat <- dat %>%
#   group_by(Name, Type, monthly) %>%
#   summarise(Amount = sum(Amount))
# 
# plot1 <- dat %>%
#   ggplot(aes(x = Time, y = Amount)) +
#   geom_smooth() +
#   geom_point(aes(col = Name), position = "jitter") +
#   facet_wrap(~Name) +
#   labs(title = 'Business profits from June - July 2016')

plot2 <- hour_dat %>% 
  ggplot(aes(x = hourly, y = Amount)) +
  geom_smooth() +
  geom_point(aes(col = Name), position = "jitter") +
  facet_wrap(~Name) +
  labs(title = 'Business profits from June - July 2016', 
       subtitle = "Combined into hours - Every point is an hour", 
       x = "Date")

plot3 <- day_dat %>% 
  ggplot(aes(x = daily, y = Amount, col = Name)) +
  geom_smooth(col = 'blue') +
  geom_point(size = 2) +
  geom_line() +
  facet_wrap(~Name) +
  labs(title = 'Business profits from June - July 2016',
       subtitle = "Combined into days - Every point is a day",
       x = "Date")

plot4 <- week_dat %>% 
  ggplot(aes(x = weekly, y = Amount, col = Name)) +
  geom_point(size = 2) +
  geom_line() +
  labs(title = 'Business profits from June - July 2016',
       subtitle = "Combined into weeks - Every point is a week", 
       x = "Date")

plot5 <- day_dat %>% 
  ggplot(aes(x = daily, y = Amount, col = Name)) +
  geom_point(size = 2) +
  geom_line() +
  facet_wrap(~week(daily), scales = 'free_x', nrow = 2) +
  labs(title = 'Business profits from June - July 2016',
       subtitle = "Combined into days - Every point is a day", 
       x = "Date")

plot6 <- hour_dat %>% 
  ggplot(aes(x = hour(hourly), y = Amount, col = Name)) +
  geom_point(size = 2, position = 'jitter', alpha = 0.3) +
  geom_smooth(aes(group = Name), se = FALSE) +
  facet_wrap(~wday(hourly, label = TRUE), scales = 'free_x', nrow = 2) +
  labs(title = 'Overview of week profits in June - July 2016')

ggsave(plot = plot2, filename = "Case_Study_08/analysis/hourly_plot.png", width = 12, height = 6)
ggsave(plot = plot3, filename = "Case_Study_08/analysis/daily_plot.png", width = 12, height = 6)
ggsave(plot = plot4, filename = "Case_Study_08/analysis/weekly_plot.png", width = 12, height = 6)
ggsave(plot = plot5, filename = "Case_Study_08/analysis/daily_new_plot.png", width = 12, height = 6)
ggsave(plot = plot6, filename = "Case_Study_08/analysis/overview_plot.png", width = 12, height = 6)
