library(readr)
library(tidyverse)
library(dplyr)
library(haven)
library(readxl)
library(rio)
library(downloader)

rds_file <- import("https://github.com/byuistats/data/blob/master/Dart_Expert_Dow_6month_anova/Dart_Expert_Dow_6month_anova.RDS?raw=true.rds")
xlsx_file <- import("https://github.com/byuistats/data/blob/master/Dart_Expert_Dow_6month_anova/Dart_Expert_Dow_6month_anova.xlsx?raw=true.xlsx")
csv_file <- import("https://github.com/byuistats/data/raw/master/Dart_Expert_Dow_6month_anova/Dart_Expert_Dow_6month_anova.csv")
dta_file <- import("https://github.com/byuistats/data/blob/master/Dart_Expert_Dow_6month_anova/Dart_Expert_Dow_6month_anova.dta?raw=true.dta")
sav_file <- import("https://github.com/byuistats/data/blob/master/Dart_Expert_Dow_6month_anova/Dart_Expert_Dow_6month_anova.sav?raw=true.sav")

all.equal(rds_file, xlsx_file)
all.equal(rds_file, csv_file)
all.equal(rds_file, dta_file)
all.equal(rds_file, sav_file)

average_csv <- csv_file %>%
  group_by(variable) %>% 
  summarise(mean_value = mean(value))

csv_file %>%
  ggplot() +
  geom_jitter(aes(col = variable, x = variable, y = value), 
              position = position_jitter(width = .05), alpha = 0.5) +
  geom_boxplot(aes(x = variable, y = value), outlier.shape = "jitter") +
  geom_point(data = average_csv, aes(x = variable, y = mean_value), col = "purple", shape = 4, size = 3) +
  # coord_cartesian(ylim = boxplot.stats(flights_delay$dep_delay)$stats[c(1, 5)] * 1.50) +
  # geom_hline(yintercept = 0, color = "black", size = 1, linetype = "dotted") +
  labs(title = "Performance in stocks", x = "Stocks", y = "Stock Prices", col = "Stocks") +
  theme_bw() +
  ggsave("Case_Study_05/Class_Task_09/stocks.png")