library(tidyverse)
library(dplyr)
library(ggplot2)
library(readr)
library(forcats)
library(zoo)

csv_file <- readr::read_csv("https://github.com/byuistats/data/raw/master/Dart_Expert_Dow_6month_anova/Dart_Expert_Dow_6month_anova.csv")
dat <- csv_file %>% 
  separate(contest_period, c("monthyear_start", "monthyear_end")) %>% 
  separate(monthyear_end, c("month_end", "year_end"), sep = -5) %>% 
  na.omit() %>% 
  mutate(month_end = sub("Febuary", "February", month_end))

dat$month_end[dat$month_end == "Dec"] <- "December"
dat$year_end[dat$year_end == "Dec"] <- "1993"
dat$month_end[dat$month_end == "1993"] <- "December"

month_levels <- c(
  "January", "February", "March", "April", "May", "June", 
  "July", "August", "September", "October", "November", "December"
)
y1 <- factor(dat$month_end, levels = month_levels)

years <- c(as.Date("1991-01-01"), as.Date("1992-01-01"), as.Date("1993-01-01"), 
           as.Date("1994-01-01"), as.Date("1995-01-01"), as.Date("1996-01-01"),
           as.Date("1997-01-01"), as.Date("1998-01-01"), as.Date("1999-01-01"))

dat %>% 
  mutate(date = as.Date(as.yearmon(paste(month_end, year_end, sep = "-"), "%B-%Y"), format = "%b-%Y")) %>% 
  ggplot(aes(x = date, y = value, col = variable)) +
  geom_vline(xintercept = as.numeric(years), linetype = 4) + 
  geom_hline(yintercept = 0, col = "red", alpha = 0.5) +
  geom_smooth(alpha = 0.4, size = 0.75) +
  geom_point(size = 3) +
  geom_line() +
  facet_wrap(~ variable, nrow = 3) +
  scale_x_date(date_breaks = "3 month", date_labels =  "%b %Y") +
  theme(axis.text.x = element_text(angle = 60, hjust = 1)) +
  labs(title = "Stocks over the years 1990-1999", col = "Stock", y = "Value", x = "Date") +
  ggsave("Case_Study_07/Class_Task_13/factors.png", width = 12, height = 6)


